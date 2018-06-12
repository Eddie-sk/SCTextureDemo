//
//  KKSocialNode.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/5.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Post;

@interface KKSocialNode : ASCellNode

- (instancetype)initWithPost:(Post *)post;

@end
