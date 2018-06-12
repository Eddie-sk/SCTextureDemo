//
//  KKCustomCollectionVC.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/7.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKCustomCollectionVC.h"
#import "KKCollectionLayoutDelegate.h"

#import "KKImageCellNode.h"
#import "KKImageCollectionViewCell.h"

static BOOL kShowUICollectionViewCells = YES;
static NSString *kReuseIdentifier = @"KKImageCellNode";
static NSUInteger kNumberOfImages = 14;

@interface KKCustomCollectionVC ()<ASCollectionDataSourceInterop, ASCollectionDelegate, ASCollectionViewLayoutInspecting> {
    NSMutableArray *_sections;
    ASCollectionNode *_collectionNode;
}

@end

@implementation KKCustomCollectionVC

- (instancetype)init {
    KKCollectionLayoutDelegate *layoutDelegate = [[KKCollectionLayoutDelegate alloc] initWithNumberOfColumns:2 headerHeight:44.0];
    _collectionNode = [[ASCollectionNode alloc] initWithLayoutDelegate:layoutDelegate layoutFacilitator:nil];
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    _collectionNode.layoutInspector = self;
    
    self = [super initWithNode:_collectionNode];
    if (self) {
        _sections = [NSMutableArray array];
        [_sections addObject:NSMutableArray.array];
        
        for (NSUInteger idx = 0, section = 0; idx < kNumberOfImages ; idx ++) {
            NSString *name = [NSString stringWithFormat:@"image_%lu.jpg",(unsigned long)idx];
            [_sections[section] addObject:[UIImage imageNamed:name]];
            if ((idx + 1) % 5 == 0 && idx < kNumberOfImages - 1) {
                section ++;
                [_sections addObject:NSMutableArray.array];
            }
        }
        [_collectionNode registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_collectionNode.view registerClass:[KKImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(KKImageCollectionViewCell.class)];
}

- (void)reloadTapped {
    [_collectionNode reloadData];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (kShowUICollectionViewCells && indexPath.item % 3 == 1) {
//        return nil;
//    }
    UIImage *image = _sections[indexPath.section][indexPath.item];
    return ^{
        return [[KKImageCellNode alloc] initWithImage:image];
    };
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return ASSizeRangeUnconstrained;
}

- (ASScrollDirection)scrollableDirections {
    return ASScrollDirectionVerticalDirections;
}

- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section {
    return [kind isEqualToString:UICollectionElementKindSectionHeader] ? 1 : 0;
}

#pragma mark - ASCollectionDelegateFlowLayout

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode sizeRangeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return ASSizeRangeUnconstrained;
    } else {
        return ASSizeRangeZero;
    }
}

- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],NSForegroundColorAttributeName :[UIColor grayColor]};
    
    UIEdgeInsets textInsets = UIEdgeInsetsMake(11.0, 0, 11.0, 0);
    
    ASTextCellNode *textCellNode = [[ASTextCellNode alloc] initWithAttributes:textAttributes insets:textInsets];
    
    textCellNode.text = [NSString stringWithFormat:@"Section %zd",indexPath.section + 1];
    return textCellNode;
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return _sections.count;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return [_sections[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KKImageCollectionViewCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[KKImageCollectionViewCell alloc] init];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
