//
//  KKImageCellNode.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/7.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKImageCellNode.h"

@interface KKImageCellNode() {
    ASImageNode *_imageNode;
}

@end

@implementation KKImageCellNode

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _imageNode = [[ASImageNode alloc] init];
        _imageNode.image = image;
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    CGSize imageSize = self.image.size;
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:[ASRatioLayoutSpec ratioLayoutSpecWithRatio:imageSize.height / imageSize.width child:_imageNode]];
}

- (void)setImage:(UIImage *)image {
    _imageNode.image = image;
}

- (UIImage *)image {
    return _imageNode.image;
}

@end
