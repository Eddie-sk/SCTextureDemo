//
//  PlaceholderNetworkImageNode.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/4.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface PlaceholderNetworkImageNode : ASNetworkImageNode
@property (nonatomic, strong) UIImage *placeholderImageOverride;

@end
