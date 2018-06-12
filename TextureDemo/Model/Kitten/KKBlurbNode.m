//
//  KKBlurbNode.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/2.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKBlurbNode.h"

static CGFloat kTextPadding = 10.0f;
static NSString *kLinkAttributeName = @"PlaceKittenNodeLinkAttributeName";
@interface KKBlurbNode()<ASTextNodeDelegate>
@end
@implementation KKBlurbNode
{
    ASTextNode2 *_textNode;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        _textNode = [[ASTextNode2 alloc] init];
        _textNode.delegate = self;
        _textNode.userInteractionEnabled = YES;
        _textNode.linkAttributeNames = @[ kLinkAttributeName ];
        
        
        NSString *blurb = @"kittens courtesy placekitten.com \U0001F638";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:blurb];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f] range:NSMakeRange(0, blurb.length)];
        [string addAttributes:@{
                                kLinkAttributeName: [NSURL URLWithString:@"http://placekitten.com/"],
                                NSForegroundColorAttributeName: [UIColor grayColor],
                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternDot),
                                }
                        range:[blurb rangeOfString:@"placekitten.com"]];
        _textNode.attributedText = string;
        
    }
    return self;
}

- (void)didLoad {
    self.layer.as_allowsHighlightDrawing = YES;
    [super didLoad];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASCenterLayoutSpec *centerLayoutSpec = [[ASCenterLayoutSpec alloc] init];
    centerLayoutSpec.centeringOptions = ASCenterLayoutSpecCenteringX;
    centerLayoutSpec.sizingOptions = ASCenterLayoutSpecSizingOptionMinimumY;
    centerLayoutSpec.child = _textNode;
    UIEdgeInsets padding = UIEdgeInsetsMake(kTextPadding, kTextPadding, kTextPadding, kTextPadding);
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:padding child:centerLayoutSpec];
}

- (BOOL)textNode:(ASTextNode *)textNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point {
    return YES;
}

- (void)textNode:(ASTextNode *)textNode tappedLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point textRange:(NSRange)textRange {
    NSLog(@"attribute = %@ value = %@",attribute, value);
    if ([value isKindOfClass:NSURL.class]) {
        [[UIApplication sharedApplication] openURL:(NSURL *)value];;
    }
}

@end
