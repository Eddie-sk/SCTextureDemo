//
//  KKCollectionStyles.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/4.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KKCollectionStyles : NSObject


+ (NSDictionary *)titleStyle;
+ (NSDictionary *)subtitleStyle;
+ (NSDictionary *)distanceStyle;
+ (NSDictionary *)secondInfoStyle;
+ (NSDictionary *)originalPriceStyle;
+ (NSDictionary *)finalPriceStyle;
+ (NSDictionary *)soldOutStyle;
+ (NSDictionary *)badgeStyle;
+ (UIColor *)badgeColor;
+ (UIImage *)placeholderImage;

@end
