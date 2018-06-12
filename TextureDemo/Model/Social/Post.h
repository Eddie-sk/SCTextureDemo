//
//  Post.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/5.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *media;
@property (nonatomic, assign) NSInteger via;

@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger comments;

@end
