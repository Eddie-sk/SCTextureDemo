//
//  KKCommentsNode.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/5.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKCommentsNode.h"
#import "KKSocialTextStyles.h"

@interface KKCommentsNode()

@property (nonatomic, strong) ASImageNode *iconNode;
@property (nonatomic, strong) ASTextNode2 *countNode;
@property (nonatomic, assign) NSInteger commentsCount;

@end

@implementation KKCommentsNode

- (instancetype)initWithCommentsCount:(NSInteger)commentsCount {
    self = [super init];
    if (self) {
        _commentsCount = commentsCount;
        
        _iconNode = [[ASImageNode alloc] init];
        _iconNode.image = [UIImage imageNamed:@"icon_comment.png"];
        
        _countNode = [[ASTextNode2 alloc] init];
        if (_commentsCount > 0) {
            _countNode.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd",_commentsCount] attributes:[KKSocialTextStyles cellControlStyle]];
        }
        self.hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10);
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:6.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_iconNode, _countNode]];
    mainStack.style.minWidth = ASDimensionMakeWithPoints(60.0);
    mainStack.style.minHeight = ASDimensionMakeWithPoints(40.0);
    return mainStack;
}

@end
