//
//  KKLodingNode.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/4.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKLodingNode.h"

@interface KKLodingNode() {
    ASDisplayNode *_loadingSpinner;
}
@end
@implementation KKLodingNode


- (instancetype)init {
    self = [super init];
    _loadingSpinner = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        return spinner;
    }];
    _loadingSpinner.style.preferredSize = CGSizeMake(50, 50);
    self.automaticallyManagesSubnodes = YES;
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASCenterLayoutSpec *centerSpec = [[ASCenterLayoutSpec alloc] init];
    centerSpec.centeringOptions =ASCenterLayoutSpecCenteringXY;
    centerSpec.sizingOptions = ASCenterLayoutSpecSizingOptionDefault;
    centerSpec.child = _loadingSpinner;
    return centerSpec;
}


@end
