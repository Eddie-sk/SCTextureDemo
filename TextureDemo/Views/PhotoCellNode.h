//
//  PhotoCellNode.h
//  TextureDemo
//
//  Created by sunkai on 2018/5/30.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "Photo.h"

@interface PhotoCellNode : ASCellNode
- (instancetype)initWithPhotoObject:(Photo *)photo;

@end
