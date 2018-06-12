//
//  KKLikesNode.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/5.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKLikesNode.h"
#import "KKSocialTextStyles.h"

@interface KKLikesNode()

@property (nonatomic, strong) ASImageNode *iconNode;
@property (nonatomic, strong) ASTextNode *countNode;
@property (nonatomic, assign) NSInteger likesCount;
@property (nonatomic, assign) BOOL liked;

@end

@implementation KKLikesNode

- (instancetype)initWithLikesCount:(NSInteger)likesCount {
    self = [super init];
    if (self) {
        _likesCount = likesCount;
        _liked = (_likesCount > 0) ? [KKLikesNode getYesOrNo] : NO;
        
        _iconNode = [[ASImageNode alloc] init];
        _iconNode.image = (_liked) ? [UIImage imageNamed:@"icon_liked.png"] : [UIImage imageNamed:@"icon_like.png"];
        
        _countNode = [[ASTextNode alloc] init];
        if (_likesCount > 0) {
            NSDictionary *attributes = _liked ? [KKSocialTextStyles cellControlColoredStyle] : [KKSocialTextStyles cellControlStyle];
            _countNode.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)_likesCount] attributes:attributes];
        }
        
        self.automaticallyManagesSubnodes = YES;
        self.hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10);
    }
    return self;
}

+ (BOOL)getYesOrNo
{
    int tmp = (arc4random() % 30)+1;
    if (tmp % 5 == 0) {
        return YES;
    }
    return NO;
}

- (void)setLiked:(BOOL)isLiked {
    NSInteger likeNumExpand = isLiked ? 1 : -1;
    _liked = isLiked;
    _iconNode.image = (_liked) ? [UIImage imageNamed:@"icon_liked.png"] : [UIImage imageNamed:@"icon_like.png"];
    _likesCount += likeNumExpand;
    if (_likesCount > 0) {
        NSDictionary *attributes = _liked ? [KKSocialTextStyles cellControlColoredStyle] : [KKSocialTextStyles cellControlStyle];
        _countNode.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)_likesCount] attributes:attributes];
    }
}

- (BOOL)isLiked {
    return _liked;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:6.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_iconNode, _countNode]];
    mainStack.style.minWidth = ASDimensionMakeWithPoints(60.0);
    mainStack.style.maxHeight = ASDimensionMakeWithPoints(40.0);
    return mainStack;
    
}

@end
