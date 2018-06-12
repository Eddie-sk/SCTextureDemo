//
//  KKAnimationViewController.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/2.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKAnimationViewController.h"

@interface TransitionNode:ASDisplayNode
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong) ASButtonNode *buttonNode;
@property (nonatomic, strong) ASTextNode2 *textNodeOne;
@property (nonatomic, strong) ASTextNode2 *textNodeTwo;

@end

@implementation TransitionNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.defaultLayoutTransitionDuration = 0.2;
        _textNodeOne = [[ASTextNode2 alloc] init];
        _textNodeOne.attributedText = [[NSAttributedString alloc] initWithString:@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled"];
        
        _textNodeTwo = [[ASTextNode2 alloc] init];
        _textNodeTwo.attributedText = [[NSAttributedString alloc] initWithString:@"It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English."];
        
//        ASSetDebugName(_textNodeOne, _textNodeTwo);
        
        NSString *buttonTitle = @"Start Layout Transition";
        UIFont *buttonFont = [UIFont systemFontOfSize:16.0];
        UIColor *buttonColor = [UIColor blueColor];
        
        _buttonNode = [[ASButtonNode alloc] init];
        [_buttonNode setTitle:buttonTitle withFont:buttonFont withColor:buttonColor forState:UIControlStateNormal];
        [_buttonNode setTitle:buttonTitle withFont:buttonFont withColor:[buttonColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        
        _textNodeOne.backgroundColor = [UIColor orangeColor];
        _textNodeOne.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}


- (void)didLoad {
    [super didLoad];
    [self.buttonNode addTarget:self action:@selector(buttonPressed:) forControlEvents:ASControlNodeEventTouchUpInside];
}

- (void)buttonPressed:(id)sender {
    self.enabled = !self.enabled;
    
    [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO
                  measurementCompletion:nil];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASTextNode2 *nextNode = self.enabled ? self.textNodeTwo : self.textNodeOne;
    
    nextNode.style.flexGrow = 1.0;
    nextNode.style.flexShrink = 1.0;
    
    ASStackLayoutSpec *horizontalStackLayout = [ASStackLayoutSpec horizontalStackLayoutSpec];
    horizontalStackLayout.children = @[nextNode];
    
    self.buttonNode.style.alignSelf = ASStackLayoutAlignSelfCenter;
    
    ASStackLayoutSpec *verticalStackLayout = [ASStackLayoutSpec verticalStackLayoutSpec];
    verticalStackLayout.spacing = 10.0;
    verticalStackLayout.children = @[horizontalStackLayout, self.buttonNode];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0) child:verticalStackLayout];
}

- (void)animateLayoutTransition:(id<ASContextTransitioning>)context {
    
    ASDisplayNode *fromNode = [[context removedSubnodes] objectAtIndex:0];
    ASDisplayNode *toNode = [[context insertedSubnodes] objectAtIndex:0];
    
    ASButtonNode *buttonNode = nil;
    for (ASDisplayNode *node in [context subnodesForKey:ASTransitionContextToLayoutKey]) {
        if ([node isKindOfClass:ASButtonNode.class]) {
            buttonNode = node;
            break;
        }
    }
    
    CGRect toNodeFrame = [context finalFrameForNode:toNode];
    toNodeFrame.origin.x += (self.enabled ? toNodeFrame.size.width : -toNodeFrame.size.width);
    toNode.frame = toNodeFrame;
    toNode.alpha = 0.0;
    
    CGRect fromNodeFrame = fromNode.frame;
    fromNodeFrame.origin.x += (self.enabled ? toNodeFrame.size.width : -toNodeFrame.size.width);
    
    [UIView animateWithDuration:self.defaultLayoutTransitionDuration animations:^{
        toNode.frame = [context finalFrameForNode:toNode];
        toNode.alpha = 1.0;
        fromNode.frame = fromNodeFrame;
        fromNode.alpha = 0;
        
        CGSize fromSize = [context layoutForKey:ASTransitionContextFromLayoutKey].size;
        CGSize toSize = [context layoutForKey:ASTransitionContextToLayoutKey].size;
        BOOL isResized = (CGSizeEqualToSize(fromSize, toSize) == NO);
        
        if (!isResized) {
            CGPoint position = self.frame.origin;
            self.frame = CGRectMake(position.x, position.y, toSize.width, toSize.height);
        }
        buttonNode.frame = [context finalFrameForNode:buttonNode];
        
        
    } completion:^(BOOL finished) {
        [context completeTransition:finished];
    }];
}

@end

@interface KKAnimationViewController ()
@property (nonatomic, strong) TransitionNode *transitionNode;

@end


@implementation KKAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _transitionNode = [TransitionNode new];
    [self.view addSubnode:_transitionNode];
    _transitionNode.backgroundColor = [UIColor grayColor];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGSize size = [self.transitionNode layoutThatFits:ASSizeRangeMake(CGSizeZero, self.view.frame.size)].size;
    self.transitionNode.frame = CGRectMake(0, 64, size.width, size.height);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
