//
//  Photo.h
//  TextureDemo
//
//  Created by sunkai on 2018/5/30.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface Photo : NSObject

@property (nonatomic, strong, readonly) NSURL                  *URL;
@property (nonatomic, strong, readonly) NSString               *photoID;
@property (nonatomic, strong, readonly) NSString               *uploadDateString;
@property (nonatomic, strong, readonly) NSString               *descriptionText;
@property (nonatomic, assign, readonly) NSUInteger             likesCount;
@property (nonatomic, strong, readonly) NSString               *location;
@property (nonatomic, strong, readonly) UserModel              *ownerUserProfile;
@property (nonatomic, assign, readonly) NSUInteger             width;
@property (nonatomic, assign, readonly) NSUInteger             height;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUnsplashPhoto:(NSDictionary *)photoDictionary NS_DESIGNATED_INITIALIZER;

- (NSAttributedString *)descriptionAttributedStringWithFontSize:(CGFloat)size;
- (NSAttributedString *)uploadDateAttributedStringWithFontSize:(CGFloat)size;
- (NSAttributedString *)likesAttributedStringWithFontSize:(CGFloat)size;
- (NSAttributedString *)locationAttributedStringWithFontSize:(CGFloat)size;

@end
