//
//  HTTPBookService.m
//  MyBookshelfApp
//
//  Created by sens i on 2020/10/07.
//

#import "HTTPBookService.h"

@implementation HTTPBookService
static NSString *const URL_ITBOOKSTORE = @"https://api.itbook.store/1.0/";
static NSString *const URL_SEARCH = @"search/";
static NSString *const URL_BOOKS = @"books/";

+ (instancetype)sharedInstance {
    static HTTPBookService *shared = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[HTTPBookService alloc] init];
    });

    return shared;
}

- (void)getSearchResult:(NSString *)searchString completionHandler:(void(^)(NSMutableArray *, int))completion {
    NSString *getURL = [NSString stringWithFormat:@"%@%@%@", URL_ITBOOKSTORE, URL_SEARCH, searchString];
    NSString *encodedURLString = [getURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"getURL: %@", getURL);
    NSLog(@"encodedURLString: %@", encodedURLString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:encodedURLString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            int totalPageNum = [json[@"total"] intValue];
            NSLog(@"totalPageNum: %d", totalPageNum);
            completion([self setBookArray:json], totalPageNum);
        } else {
            if (error == nil) {
                NSLog(@"getSearchResult ERROR");
            } else {
                NSLog(@"getSearchResult ERROR %@", error.localizedFailureReason);
            }
            completion([NSMutableArray array], 0);
        }
    }] resume];
}

- (void)getSearchResultByPage:(NSString *)searchString pageNum:(int)pageNum completionHandler:(void(^)(NSMutableArray *))completion {
    NSString *getURL = [NSString stringWithFormat:@"%@%@%@/%d", URL_ITBOOKSTORE, URL_SEARCH, searchString, pageNum];
    NSString *encodedURLString = [getURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:encodedURLString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completion([self setBookArray:json]);
        } else {
            if (error == nil) {
                NSLog(@"getSearchResultByPage ERROR");
            } else {
                NSLog(@"getSearchResultByPage ERROR %@", error.localizedFailureReason);
            }
            completion([NSMutableArray array]);
        }
    }] resume];
}

- (void)getBookDetailByISBN:(NSString *)isbnString completionHandler:(void(^)(Book *))completion {
    NSString *getURL = [NSString stringWithFormat:@"%@%@%@", URL_ITBOOKSTORE, URL_BOOKS, isbnString];
    NSString *encodedURLString = [getURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:encodedURLString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            completion([self setBookInfo:json]);
        } else {
            if (error == nil) {
                NSLog(@"getBookDetailByISBN ERROR");
            } else {
                NSLog(@"getBookDetailByISBN ERROR %@", error.localizedFailureReason);
            }
            completion(nil);
        }
    }] resume];
}

- (NSMutableArray *)setBookArray: (NSDictionary *)json {
    NSMutableArray *bookArray = [NSMutableArray array];
    for (NSDictionary *bookD in json[@"books"]) {
        NSString *image = bookD[@"image"];
        NSString *isbn13 = bookD[@"isbn13"];
        NSString *price = bookD[@"price"];
        NSString *subtitle = bookD[@"subtitle"];
        NSString *title = bookD[@"title"];
        NSString *url = bookD[@"url"];
        
        Book *book = [[Book alloc] initWithInfo:image andIsbn13:isbn13 andPrice:price andSubtitle:subtitle andTitle:title andUrl:url];
        [bookArray addObject:book];
    }
    return bookArray;
}

- (Book *)setBookInfo: (NSDictionary *)json {
    Book *book = [[Book alloc] init];
    book.authors = json[@"authors"];
    book.desc = json[@"desc"];
    book.imageurl = json[@"image"];
    book.isbn10 = json[@"isbn10"];
    book.isbn13 = json[@"isbn13"];
    book.language = json[@"language"];
    book.pages = json[@"pages"];
    book.price = json[@"price"];
    book.publisher = json[@"publisher"];
    book.rating = json[@"rating"];
    book.subtitle = json[@"subtitle"];
    book.title = json[@"title"];
    book.url = json[@"url"];
    book.year = json[@"year"];
    return book;
}


@end
