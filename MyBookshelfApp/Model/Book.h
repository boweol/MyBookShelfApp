//
//  Book.h
//  MyBookshelfApp
//
//  Created by sens i on 2020/10/07.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *isbn13;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *authors;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *isbn10;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *pages;
@property (nonatomic, strong) NSString *publisher;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *year;

- (id) initWithInfo:(NSString *)image andIsbn13:(NSString *)isbn13 andPrice:(NSString *)price andSubtitle:(NSString *)subTitle andTitle:(NSString *)title andUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
