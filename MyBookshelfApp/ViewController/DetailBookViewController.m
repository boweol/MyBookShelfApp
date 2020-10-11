//
//  DetailBookViewController.m
//  MyBookshelfApp
//
//  Created by sens i on 2020/10/10.
//

#import "DetailBookViewController.h"

@interface DetailBookViewController ()

@end

@implementation DetailBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Detail Page";
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDismiss:)];
    [self.mainView setUserInteractionEnabled:YES];
    [self.mainView addGestureRecognizer:gesture];
    
    UITapGestureRecognizer* gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(urlTappedOnLink:)];
    [self.urlLabel setUserInteractionEnabled:YES];
    [self.urlLabel addGestureRecognizer:gesture2];
    
    [[self.noteTextView layer] setBorderWidth:1.0];
    [[self.noteTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.noteTextView layer] setCornerRadius:10.0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setData];
}

- (void)setData {
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.bookInfo.imageurl]];
    self.bookImageView.image = [UIImage imageWithData:imageData];
    self.titleLabel.text = self.bookInfo.title;
    self.subtitleLabel.text = self.bookInfo.subtitle;
    self.priceLabel.text = self.bookInfo.price;
    self.ratingLabel.text = self.bookInfo.rating;
    self.authorLabel.text = self.bookInfo.authors;
    self.publisherLabel.text = self.bookInfo.publisher;
    self.yearLabel.text = self.bookInfo.year;
    self.pageLabel.text = self.bookInfo.pages;
    self.languageLabel.text = self.bookInfo.language;
    self.isbn10Label.text = self.bookInfo.isbn10;
    self.isbn13Label.text = self.bookInfo.isbn13;
    self.urlLabel.text = self.bookInfo.url;
    self.descLabel.text = self.bookInfo.desc;
}

#pragma mark - HyperLink

- (void)urlTappedOnLink:(UIGestureRecognizer*)gestureRecognizer {
    NSURL *url = [[NSURL alloc] initWithString: self.urlLabel.text];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(bool bSuccess) {
        NSLog(@"bSuccess: %id", bSuccess);
    }];
}

#pragma mark - Keyboard

- (void)keyboardDismiss:(UIGestureRecognizer*)gestureRecognizer {
    [self.noteTextView resignFirstResponder];
}

-(void)onKeyboardShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];

    [self.mainScrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardFrameBeginRect.size.height + self.noteTextView.frame.size.height, 0)];
    CGPoint scrollPoint = CGPointMake(0.0, self.mainScrollView.contentOffset.y + keyboardFrameBeginRect.size.height + self.noteTextView.frame.size.height);
    [self.mainScrollView setContentOffset:scrollPoint];
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGPoint scrollPoint = CGPointMake(0.0, self.mainScrollView.contentOffset.y - keyboardFrameBeginRect.size.height - self.noteTextView.frame.size.height);
    [self.mainScrollView setContentOffset:scrollPoint];
    [self.mainScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end
