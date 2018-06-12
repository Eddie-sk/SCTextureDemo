//
//  KKRandomCoreGraphicsNode.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/6.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKRandomCoreGraphicsNode.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@implementation KKRandomCoreGraphicsNode
@synthesize indexPath = _indexPath;

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


+ (void)drawRect:(CGRect)bounds withParameters:(id<NSObject>)parameters isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing
{
    CGFloat locations[3];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
    [colors addObject:(id)[[KKRandomCoreGraphicsNode randomColor] CGColor]];
    locations[0] = 0.0;
    [colors addObject:(id)[[KKRandomCoreGraphicsNode randomColor] CGColor]];
    locations[1] = 1.0;
    [colors addObject:(id)[[KKRandomCoreGraphicsNode randomColor] CGColor]];
    locations[2] = ( arc4random() % 256 / 256.0 );
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
    
    CGContextDrawLinearGradient(ctx, gradient, CGPointZero, CGPointMake(bounds.size.width, bounds.size.height), 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _indexPathTextNode = [[ASTextNode2 alloc] init];
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    @synchronized (self) {
        _indexPath = indexPath;
        _indexPathTextNode.attributedText = [[NSAttributedString alloc] initWithString:[indexPath description] attributes:nil];
    }
}

- (NSIndexPath *)indexPath
{
    NSIndexPath *indexPath = nil;
    @synchronized (self) {
        indexPath = _indexPath;
    }
    return indexPath;
}

- (void)layout
{
    [super layout];
    
    _indexPathTextNode.frame = self.bounds;
}
@end
