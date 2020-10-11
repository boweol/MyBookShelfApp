//
//  Book.m
//  MyBookshelfApp
//
//  Created by sens i on 2020/10/07.
//

#import "Book.h"

@implementation Book

- (id) initWithInfo:(NSString *)image andIsbn13:(NSString *)isbn13 andPrice:(NSString *)price andSubtitle:(NSString *)subTitle andTitle:(NSString *)title andUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.imageurl = image;
        self.isbn13 = isbn13;
        self.price = price;
        self.subtitle = subTitle;
        self.title = title;
        self.url = url;
    }
    return self;
}
@end
