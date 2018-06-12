//
//  KKSocialNode.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/5.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKSocialNode.h"
#import "Post.h"
#import "KKSocialTextStyles.h"
#import "KKLikesNode.h"
#import "KKCommentsNode.h"

@interface KKSocialNode()<ASNetworkImageNodeDelegate, ASTextNodeDelegate>

@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) ASDisplayNode *divider;
@property (strong, nonatomic) ASTextNode2 *nameNode;
@property (strong, nonatomic) ASTextNode2 *usernameNode;
@property (strong, nonatomic) ASTextNode2 *timeNode;
@property (strong, nonatomic) ASTextNode2 *postNode;
@property (strong, nonatomic) ASImageNode *viaNode;
@property (strong, nonatomic) ASNetworkImageNode *avatarNode;
@property (strong, nonatomic) ASNetworkImageNode *mediaNode;
@property (strong, nonatomic) KKLikesNode *likesNode;
@property (strong, nonatomic) KKCommentsNode *commentsNode;
@property (strong, nonatomic) ASImageNode *optionsNode;

@end

@implementation KKSocialNode

- (instancetype)initWithPost:(Post *)post {
    
    self = [super init];
    if (!self) return nil;
    
    _post = post;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _nameNode = [[ASTextNode2 alloc] init];
    _nameNode.attributedText = [[NSAttributedString alloc] initWithString:_post.name attributes:[KKSocialTextStyles nameStyle]];
    _nameNode.maximumNumberOfLines = 1;
    
    _usernameNode = [[ASTextNode2 alloc] init];
    _usernameNode.attributedText = [[NSAttributedString alloc] initWithString:_post.username attributes:[KKSocialTextStyles usernameStyle]];
    _usernameNode.style.flexShrink = 1.0;
    _usernameNode.truncationMode = NSLineBreakByTruncatingTail;
    _usernameNode.maximumNumberOfLines = 1;
    
    _timeNode = [[ASTextNode2 alloc] init];
    _timeNode.attributedText = [[NSAttributedString alloc] initWithString:_post.time attributes:[KKSocialTextStyles timeStyle]];
    
    
    
    if (![_post.post isEqualToString:@""]) {
        _postNode = [[ASTextNode2 alloc] init];
        
        NSString *kLinkAttributeName = @"TextLinkAttributeName";
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_post.post attributes:[KKSocialTextStyles postStyle]];
        
        NSDataDetector *urlDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        
        [urlDetector enumerateMatchesInString:attrString.string options:kNilOptions range:NSMakeRange(0, attrString.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result.resultType == NSTextCheckingTypeLink) {
                NSMutableDictionary *linkAttributes = [[NSMutableDictionary alloc] initWithDictionary:[KKSocialTextStyles postLinkStyle]];
                linkAttributes[kLinkAttributeName] = [NSURL URLWithString:result.URL.absoluteString];
                
                [attrString addAttributes:linkAttributes range:result.range];
            }
        }];
        
        _postNode.delegate = self;
        _postNode.userInteractionEnabled = YES;
        _postNode.linkAttributeNames = @[kLinkAttributeName];
        _postNode.attributedText = attrString;
        _postNode.passthroughNonlinkTouches = YES;
        
    }
    
    if (![_post.media isEqualToString:@""]) {
        _mediaNode = [[ASNetworkImageNode alloc] init];
        _mediaNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _mediaNode.cornerRadius = 4.0;
        _mediaNode.URL = [NSURL URLWithString:_post.media];
        _mediaNode.delegate = self;
        _mediaNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
            UIImage *modifiedImage;
            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, [UIScreen mainScreen].scale);
            
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:8.0] addClip];
            
            [image drawInRect:rect];
            
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            return modifiedImage;
            
        };
    }
    
    _avatarNode = [[ASNetworkImageNode alloc] init];
    _avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
    _avatarNode.style.width = ASDimensionMakeWithPoints(44);
    _avatarNode.style.height = ASDimensionMakeWithPoints(44);
    _avatarNode.cornerRadius = 22.0;
    _avatarNode.URL = [NSURL URLWithString:_post.photo];
    _avatarNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
        UIImage *modifiedImage;
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, [UIScreen mainScreen].scale);
        
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:44.0] addClip];
        [image drawInRect:rect];
        
        modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return modifiedImage;
    };
    
    _divider = [[ASDisplayNode alloc] init];
    _divider.backgroundColor = [UIColor lightGrayColor];
    
    if (_post.via != 0) {
        _viaNode = [[ASImageNode alloc] init];
        _viaNode.image = (_post.via == 1) ? [UIImage imageNamed:@"icon_ios.png"] : [UIImage imageNamed:@"icon_android.png"];
    }
    
    _likesNode = [[KKLikesNode alloc] initWithLikesCount:_post.likes];
    [_likesNode addTarget:self
                   action:@selector(updateLikeStatus:)
         forControlEvents:ASControlNodeEventTouchUpInside];
    
    _commentsNode = [[KKCommentsNode alloc] initWithCommentsCount:_post.comments];
    
    _optionsNode = [[ASImageNode alloc] init];
    _optionsNode.image = [UIImage imageNamed:@"icon_more"];
    
    for (ASDisplayNode *node in self.subnodes) {
        if (node.supportsLayerBacking) {
            node.layerBacked = YES;
        }
    }
    self.automaticallyManagesSubnodes = YES;
    return self;
}

- (void)didLoad {
    self.layer.as_allowsHighlightDrawing = YES;
    [super didLoad];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASLayoutSpec *spacer = [[ASLayoutSpec alloc] init];
    spacer.style.flexGrow = 1.0;
    
    NSMutableArray *layoutSpecChildren = [@[_nameNode, _usernameNode, spacer] mutableCopy];
    
    if (_post.via != 0) {
        [layoutSpecChildren addObject:_viaNode];
    }
    
    [layoutSpecChildren addObject:_timeNode];
    
    ASStackLayoutSpec *nameStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:layoutSpecChildren];
    
    nameStack.style.alignSelf = ASStackLayoutAlignSelfStretch;
    
    ASStackLayoutSpec *controlsStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_likesNode, _commentsNode, _optionsNode]];
    
    controlsStack.style.spacingAfter = 3.0;
    controlsStack.style.spacingBefore = 3.0;
    
    NSMutableArray *mainStackContent = [[NSMutableArray alloc] init];
    [mainStackContent addObject:nameStack];
    [mainStackContent addObject:_postNode];
    
    if (![_post.media isEqualToString:@""]) {
        if (_mediaNode.image != nil) {
            ASRatioLayoutSpec *imagePlace = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:0.5 child:_mediaNode];
            imagePlace.style.spacingAfter = 3.0;
            imagePlace.style.spacingBefore = 3.0;
            [mainStackContent addObject:imagePlace];
        }
    }
    [mainStackContent addObject:controlsStack];
    
    ASStackLayoutSpec *contentSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:8.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:mainStackContent];
    contentSpec.style.flexShrink = 1.0;
    
    ASStackLayoutSpec *avatarContentSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:8.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[_avatarNode, contentSpec]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:avatarContentSpec];
}

- (void)layout {
    [super layout];
    CGFloat pixelHeight = 1.0f / [UIScreen mainScreen].scale;
    _divider.frame = CGRectMake(0, 0, self.calculatedSize.width, pixelHeight);
}

#pragma mark - Event

- (void)updateLikeStatus:(KKLikesNode *)controlNode {
    BOOL isliked = !controlNode.isLiked;
    [controlNode setLiked:isliked];
}

#pragma mark - ASCellNode

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    _divider.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _divider.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - <ASTextNodeDelegate>

- (BOOL)textNode:(ASTextNode *)richTextNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point
{
    // Opt into link highlighting -- tap and hold the link to try it!  must enable highlighting on a layer, see -didLoad
    return YES;
}

- (void)textNode:(ASTextNode *)richTextNode tappedLinkAttribute:(NSString *)attribute value:(NSURL *)URL atPoint:(CGPoint)point textRange:(NSRange)textRange
{
    // The node tapped a link, open it
    [[UIApplication sharedApplication] openURL:URL];
}

#pragma mark - ASNetworkImageNodeDelegate methods.

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image
{
    [self setNeedsLayout];
}


@end
