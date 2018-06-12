//
//  KKKittenNode.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/2.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface KKKittenNode : ASCellNode

- (instancetype)initWithKittenOfSize:(CGSize)size;

- (void)toggleImageEnlargement;

@end
