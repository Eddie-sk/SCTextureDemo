//
//  KKCollectionLayoutInfo.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/7.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KKCollectionLayoutInfo : NSObject

@property (nonatomic, assign, readonly) NSInteger numberOfColumns;
@property (nonatomic, assign, readonly) CGFloat headerHeight;
@property (nonatomic, assign, readonly) CGFloat columnSpacing;
@property (nonatomic, assign, readonly) UIEdgeInsets sectionInsets;
@property (nonatomic, assign, readonly) UIEdgeInsets interItemSpacing;


- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                           headerHeight:(CGFloat)headerHeight
                          columnSpacing:(CGFloat)columnSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets
                       interItemSpacing:(UIEdgeInsets)interItemSpacing NS_DESIGNATED_INITIALIZER;

- (instancetype)init __unavailable;

@end
