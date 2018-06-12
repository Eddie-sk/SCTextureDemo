//
//  PhotoCellNode.m
//  TextureDemo
//
//  Created by sunkai on 2018/5/30.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "PhotoCellNode.h"
#import "Utilities.h"

static const CGFloat kNameFontSize = 14.0f;
static const CGFloat kUserImageHeight = 30.0f;

@interface PhotoCellNode() <ASNetworkImageNodeDelegate>

@end

@implementation PhotoCellNode
{
    Photo *_photo;
    ASNetworkImageNode *_avatarImageNode;
    ASNetworkImageNode *_photoImageNode;
    ASTextNode2 *_userNameNode;
    ASTextNode2 *_photoLocationLabel;
    ASTextNode *_photoTimeintervalSincePostLabel;
    ASTextNode *_photoLikesLabel;
    ASTextNode *_photoDescriptionLabel;
}

#pragma mark - Lifecycle

- (instancetype)initWithPhotoObject:(Photo *)photo {
    self = [super init];
    if (self) {
        _photo = photo;
        
        _avatarImageNode = [[ASNetworkImageNode alloc] init];
        _avatarImageNode.URL = photo.ownerUserProfile.userPicURL;
        
        [_avatarImageNode setImageModificationBlock:^UIImage * _Nullable(UIImage * _Nonnull image) {
            CGSize profileImageSize = CGSizeMake(kUserImageHeight, kUserImageHeight);
            return [image makeCircularImageWithSize:profileImageSize];
        }];
        
        _photoImageNode = [[ASNetworkImageNode alloc] init];
        _photoImageNode.URL = photo.URL;
        _photoImageNode.delegate = self;
        _photoImageNode.layerBacked = YES;
        
        _userNameNode = [[ASTextNode2 alloc] init];
        _userNameNode.attributedText = [photo.ownerUserProfile usernameAttributedStringWithFontSize:kNameFontSize];
        
        _photoLocationLabel = [[ASTextNode2 alloc] init];
        _photoLocationLabel.maximumNumberOfLines = 1;
        _photoLocationLabel.attributedText = [photo locationAttributedStringWithFontSize:kNameFontSize];
        
        _photoTimeintervalSincePostLabel = [[ASTextNode alloc] init];
        _photoTimeintervalSincePostLabel.layerBacked = YES;
        _photoTimeintervalSincePostLabel.attributedText = [photo uploadDateAttributedStringWithFontSize:kNameFontSize];
        
        _photoLikesLabel = [[ASTextNode alloc] init];
        _photoLikesLabel.layerBacked = YES;
        _photoLikesLabel.attributedText = [photo likesAttributedStringWithFontSize:kNameFontSize];
        
        _photoDescriptionLabel = [[ASTextNode alloc] init];
        _photoDescriptionLabel.layerBacked = YES;
        _photoDescriptionLabel.attributedText = [photo descriptionAttributedStringWithFontSize:kNameFontSize];
        
        self.automaticallyManagesSubnodes = YES;
        
    }
    return self;
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    NSMutableArray *headerChildren = [NSMutableArray array];
    NSMutableArray *verticalChildren = [NSMutableArray array];
    
    //头部水平布局
    ASStackLayoutSpec *headerStack = [ASStackLayoutSpec horizontalStackLayoutSpec];
    headerStack.alignItems = ASStackLayoutAlignItemsCenter;
    
    //头像首选size，若超过或小于最大、小size，maxsize、minsize会被强制执行
    _avatarImageNode.style.preferredSize = CGSizeMake(kUserImageHeight, kUserImageHeight);
    
    [headerChildren addObject:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 0, 10, 10) child:_avatarImageNode]];
    
    ASStackLayoutSpec *userPhotoLocationStack = [ASStackLayoutSpec verticalStackLayoutSpec];
//    userPhotoLocationStack.style.flexShrink = 1;
    userPhotoLocationStack.style.flexGrow = 1;
    [headerChildren addObject:userPhotoLocationStack];
    
    _userNameNode.style.flexShrink = 1;
    _photoLocationLabel.style.flexShrink = 1;
    [userPhotoLocationStack setChildren:@[_userNameNode,_photoLocationLabel]];
    
    ASLayoutSpec *spacer = [ASLayoutSpec new];
    spacer.style.flexShrink = 1.0;
    [headerChildren addObject:spacer];
    
    _photoTimeintervalSincePostLabel.style.spacingBefore = 10;
    [headerChildren addObject:_photoTimeintervalSincePostLabel];
    
    headerStack.children = headerChildren;
    
    ASStackLayoutSpec *footerStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    footerStack.spacing = 5;
    footerStack.children = @[_photoLikesLabel, _photoDescriptionLabel];
    
    //整体垂直布局
    ASStackLayoutSpec * verticalStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    [verticalChildren addObject:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 10, 0, 10) child:headerStack]];
    [verticalChildren addObject:[ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0 child:_photoImageNode]];
    [verticalChildren addObject:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 10, 5, 10) child:footerStack]];
    verticalStack.children = verticalChildren;
    
    return verticalStack;
}

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image info:(ASNetworkImageLoadInfo *)info {
    if (info.sourceType == ASNetworkImageSourceDownload) {
        ASPerformBlockOnBackgroundThread(^{
            NSLog(@"Received image %@ from %@ with userInfo %@", image, info.url.path, ASObjectDescriptionMakeTiny(info.userInfo));
        });
    }
}

@end
