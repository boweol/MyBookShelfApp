//
//  SearchViewController.m
//  MyBookshelfApp
//
//  Created by sens i on 2020/10/07.
//

#import "SearchViewController.h"

@implementation SearchViewController

NSMutableArray *mHistoryArray;
NSMutableArray *mBookArray;
NSString *mSearchWord;
int mTotalPageNumber = 0;
int mCurrentMaxPageNumber = 0;
bool mIsGetNextPage = false;

enum tableType {
    TableTypeHistory,
    TableTypeBook,
};
typedef enum tableType TableType;
TableType mTableType;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Bookshelf";
    mBookArray = [[NSMutableArray alloc] init];
    mHistoryArray = [[NSMutableArray alloc] init];
    [self setLoadingIndicator:NO];
    mTableType = TableTypeHistory;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.searchTableView setTableFooterView: footerView];
}

#pragma mark - Navigation
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (mTableType == TableTypeHistory) {
        static NSString *identifier = @"HistoryCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.text = mHistoryArray[indexPath.row];
        return cell;
    } else {
        static NSString *identifier = @"BookCell";
        BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[BookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        Book *book = mBookArray[indexPath.row];
        cell.titleLabel.text = book.title;
        cell.subtitleLabel.text = book.subtitle;
        cell.isbn13Label.text = book.isbn13;
        cell.priceLabel.text = book.price;
        cell.urlLabel.text = book.url;
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: book.imageurl]];
        cell.bookImageView.image = [UIImage imageWithData: imageData];
        
        if (mIsGetNextPage == false && indexPath.row == mBookArray.count - 10 && mCurrentMaxPageNumber < mTotalPageNumber) {
            mIsGetNextPage = true;
            [self searchNextPage];
        }
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (mTableType == TableTypeHistory) {
        return mHistoryArray.count;
    } else {
        return mBookArray.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (mTableType == TableTypeHistory) {
        self.searchBar.text = mHistoryArray[indexPath.row];
        [self startSearch:mHistoryArray[indexPath.row]];
    } else {
        [self getDetailBook:(long)indexPath.row];
    }
}

#pragma mark - SearchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length <= 0) {
        [self showHistoryTable];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = self.searchBar.searchTextField.text;
    [self startSearch:searchText];
}

- (void)startSearch:(NSString *)searchText {
    [self.searchBar resignFirstResponder];
    [self clear:searchText];
    mTableType = TableTypeBook;
    [self insertHistoryArray:searchText];
    [self searchFirstPage];
}

- (void)insertHistoryArray:(NSString *)searchText {
    bool isConflict = false;
    for (int i = 0; i < mHistoryArray.count; i++) {
        if (mHistoryArray[i] == searchText) {
            isConflict = true;
            break;
        }
    }
    if (isConflict) {
        [mHistoryArray removeObject:searchText];
    }
    [mHistoryArray insertObject:searchText atIndex:0];
}

- (void)showHistoryTable {
    mTableType = TableTypeHistory;
    [self.searchTableView reloadData];
}

- (void)clear:(NSString *)searchWord {
    mBookArray = [NSMutableArray array];
    mSearchWord = searchWord;
    mTotalPageNumber = 0;
    mCurrentMaxPageNumber = 1;
}

#pragma mark - API
- (void)searchFirstPage {
    [self setLoadingIndicator:YES];
    [[HTTPBookService sharedInstance] getSearchResult:mSearchWord completionHandler:^(NSMutableArray *books, int totalPageNum) {
        [self setLoadingIndicator:NO];
        if (books.count > 0) {
            mTotalPageNumber = totalPageNum;
            mBookArray = books;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchTableView reloadData];
            });
        }
    }];
}

- (void)searchNextPage {
    [self setLoadingIndicator:YES];
    [[HTTPBookService sharedInstance] getSearchResultByPage:mSearchWord pageNum:mCurrentMaxPageNumber + 1 completionHandler:^(NSMutableArray *books) {
        [self setLoadingIndicator:NO];
        if (books.count > 0) {
            mCurrentMaxPageNumber += 1;
            mIsGetNextPage = false;
            [mBookArray addObjectsFromArray:books];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchTableView reloadData];
            });
        }
    }];
}

- (void)getDetailBook:(long)index {
    Book *book = mBookArray[index];
    [self setLoadingIndicator:YES];
    [[HTTPBookService sharedInstance] getBookDetailByISBN:book.isbn13 completionHandler:^(Book *book) {
        [self setLoadingIndicator:NO];
        if (book != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                DetailBookViewController *detailBookVC = (DetailBookViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailBookVC"];
                detailBookVC.bookInfo = book;
                [self.navigationController pushViewController:detailBookVC animated:true];
            });
        }
    }];
}

#pragma mark - Indicator
- (void)setLoadingIndicator:(bool)isSet {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isSet) {
            [self.view setUserInteractionEnabled:NO];
            [self.loadingIndicatorView startAnimating];
            [self.loadingIndicatorView setHidden:NO];
        } else {
            [self.view setUserInteractionEnabled:YES];
            [self.loadingIndicatorView stopAnimating];
            [self.loadingIndicatorView setHidden:YES];
        }
    });
}

#pragma mark - Top button
- (IBAction)clickedTopButton:(id)sender {
    [self.searchTableView setContentOffset:CGPointZero animated:YES];
}
@end
