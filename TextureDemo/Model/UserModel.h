//
//  UserModel.h
//  TextureDemo
//
//  Created by sunkai on 2018/5/30.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong, readonly) NSDictionary *dictionaryRepresentation;
@property (nonatomic, assign, readonly) NSString     *userID;
@property (nonatomic, strong, readonly) NSString     *username;
@property (nonatomic, strong, readonly) NSString     *firstName;
@property (nonatomic, strong, readonly) NSString     *lastName;
@property (nonatomic, strong, readonly) NSString     *fullName;
@property (nonatomic, strong, readonly) NSString     *location;
@property (nonatomic, strong, readonly) NSString     *about;
@property (nonatomic, strong, readonly) NSURL        *userPicURL;
@property (nonatomic, assign, readonly) NSUInteger   photoCount;
@property (nonatomic, assign, readonly) NSUInteger   galleriesCount;
@property (nonatomic, assign, readonly) NSUInteger   affection;
@property (nonatomic, assign, readonly) NSUInteger   friendsCount;
@property (nonatomic, assign, readonly) NSUInteger   followersCount;
@property (nonatomic, assign, readonly) BOOL         following;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUnsplashPhoto:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (NSAttributedString *)usernameAttributedStringWithFontSize:(CGFloat)size;
- (NSAttributedString *)fullNameAttributedStringWithFontSize:(CGFloat)size;

- (void)fetchAvatarImageWithCompletionBlock:(void(^)(UserModel *, UIImage *))block;

- (void)downloadCompleteUserDataWithCompletionBlock:(void(^)(UserModel *))block;

@end
