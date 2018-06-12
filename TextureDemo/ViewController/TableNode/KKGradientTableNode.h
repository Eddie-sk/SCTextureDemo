//
//  KKGradientTableNode.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/6.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface KKGradientTableNode : ASCellNode

- (instancetype)initWithElementSize:(CGSize)size;

@property (nonatomic) NSInteger pageNumber;

@end
