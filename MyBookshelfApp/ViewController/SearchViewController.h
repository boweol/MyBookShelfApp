//
//  SearchViewController.h
//  MyBookshelfApp
//
//  Created by sens i on 2020/10/07.
//

#import <UIKit/UIKit.h>
#import "HTTPBookService.h"
#import "BookCell.h"
#import "DetailBookViewController.h"

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
- (IBAction)clickedTopButton:(id)sender;



@end
