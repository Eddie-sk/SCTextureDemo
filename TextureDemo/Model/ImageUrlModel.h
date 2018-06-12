//
//  ImageUrlModel.h
//  TextureDemo
//
//  Created by sunkai on 2018/6/1.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageUrlModel : NSObject

+ (NSString *)imageParameterForClosestImageSize:(CGSize)size;

@end
