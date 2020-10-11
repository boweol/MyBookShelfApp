//
//  HTTPBookService.h
//  MyBookshelfApp
//
//  Created by sens i on 2020/10/07.
//

#import <Foundation/Foundation.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPBookService : NSObject
+ (instancetype)sharedInstance;
- (void)getSearchResult:(NSString *)searchString completionHandler:(void(^)(NSMutableArray *, int))completion;
- (void)getSearchResultByPage:(NSString *)searchString pageNum:(int)pageNum completionHandler:(void(^)(NSMutableArray *))completion;
- (void)getBookDetailByISBN:(NSString *)isbnString completionHandler:(void(^)(Book *))completion;
@end


NS_ASSUME_NONNULL_END
