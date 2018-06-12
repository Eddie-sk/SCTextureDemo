//
//  KKLikesNode.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/5.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface KKLikesNode : ASControlNode

@property (nonatomic, readonly) BOOL isLiked;

- (instancetype)initWithLikesCount:(NSInteger)likesCount;

- (void)setLiked:(BOOL)isLiked;

@end
