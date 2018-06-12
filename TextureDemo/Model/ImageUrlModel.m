//
//  ImageUrlModel.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/1.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "ImageUrlModel.h"

@implementation ImageUrlModel

+ (NSString *)imageParameterForClosestImageSize:(CGSize)size
{
    BOOL squareImageRequested = (size.width == size.height) ? YES : NO;
    
    if (squareImageRequested) {
        NSUInteger imageParameterID = [self imageParameterForSquareCroppedSize:size];
        return [NSString stringWithFormat:@"&image_size=%lu", (long)imageParameterID];
    } else {
        return @"";
    }
}

// 500px standard cropped image sizes
+ (NSUInteger)imageParameterForSquareCroppedSize:(CGSize)size
{
    NSUInteger imageParameterID;
    
    if (size.height <= 70) {
        imageParameterID = 1;
    } else if (size.height <= 100) {
        imageParameterID = 100;
    } else if (size.height <= 140) {
        imageParameterID = 2;
    } else if (size.height <= 200) {
        imageParameterID = 200;
    } else if (size.height <= 280) {
        imageParameterID = 3;
    } else if (size.height <= 400) {
        imageParameterID = 400;
    } else {
        imageParameterID = 600;
    }
    
    return imageParameterID;
}

@end
