//
//  KKCollectionViewController.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/4.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKCollectionViewController.h"
#import "KKCollectionNode.h"
#import "KKBlurbNode.h"
#import "KKLodingNode.h"
#import "KKCollectionStyles.h"
#import "Utilities.h"

static const NSTimeInterval kWebResponseDelay = 1.0;
static const BOOL kSimulateWebResponse = YES;
static const NSInteger kBatchSize = 20;

static const CGFloat kHorizontalSectionPadding = 10.0f;

@interface KKCollectionViewController ()<ASCollectionDelegate, ASCollectionDataSource, ASCollectionDelegateFlowLayout> {
    ASCollectionNode *_collectionNode;
    NSMutableArray *_data;
}

@end

@implementation KKCollectionViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionNode  = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
    
    self = [super initWithNode:_collectionNode];
    
    if (!self) {
        return nil;
    }
    
    _collectionNode.dataSource = self;
    _collectionNode.delegate = self;
    _collectionNode.backgroundColor = [UIColor grayColor];
    _collectionNode.accessibilityIdentifier = @"Cat deals list";
    
    ASRangeTuningParameters preloadTuning;
    preloadTuning.leadingBufferScreenfuls = 2;
    preloadTuning.trailingBufferScreenfuls = 1;
    
    [_collectionNode setTuningParameters:preloadTuning forRangeType:ASLayoutRangeTypePreload];
    
    ASRangeTuningParameters displayTuning;
    displayTuning.leadingBufferScreenfuls = 1;
    displayTuning.trailingBufferScreenfuls = 0.5;
    [_collectionNode setTuningParameters:displayTuning forRangeType:ASLayoutRangeTypeDisplay];
    
    [_collectionNode registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
    [_collectionNode registerSupplementaryNodeOfKind:UICollectionElementKindSectionFooter];
    
    _data = [[NSMutableArray alloc] init];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped)];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionNode.leadingScreensForBatching = 2;
    [self fetchMoreCatsWithCompletion:nil];
}

- (void)fetchMoreCatsWithCompletion:(void (^)(BOOL))completion
{
    if (kSimulateWebResponse) {
        __weak typeof(self) weakSelf = self;
        void(^mockWebService)() = ^{
            NSLog(@"ViewController \"got data from a web service\"");
            KKCollectionViewController *strongSelf = weakSelf;
            if (strongSelf != nil)
            {
                [strongSelf appendMoreItems:kBatchSize completion:completion];
            }
            else {
                NSLog(@"ViewController is nil - won't update collection");
            }
        };
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kWebResponseDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), mockWebService);
    } else {
        [self appendMoreItems:kBatchSize completion:completion];
    }
}

- (void)appendMoreItems:(NSInteger)numberOfNewItems completion:(void (^)(BOOL))completion
{
    NSArray *newData = [self getMoreData:numberOfNewItems];
    [_collectionNode performBatchAnimated:YES updates:^{
        [_data addObjectsFromArray:newData];
        NSArray *addedIndexPaths = [self indexPathsForObjects:newData];
        [_collectionNode insertItemsAtIndexPaths:addedIndexPaths];
    } completion:completion];
}

- (NSArray *)getMoreData:(NSInteger)count
{
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [data addObject:[KKCollectionViewModel randomItem]];
    }
    return data;
}

- (NSArray *)indexPathsForObjects:(NSArray *)data
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger section = 0;
    for (KKCollectionViewModel *viewModel in data) {
        NSInteger item = [_data indexOfObject:viewModel];
        NSAssert(item < [_data count] && item != NSNotFound, @"Item should be in _data");
        [indexPaths addObject:[NSIndexPath indexPathForItem:item inSection:section]];
    }
    return indexPaths;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [_collectionNode.view.collectionViewLayout invalidateLayout];
}

- (void)reloadTapped
{
    [_collectionNode reloadData];
}

#pragma mark - ASCollectionNodeDelegate / ASCollectionNodeDataSource

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ^{
        return [[KKCollectionNode alloc] init];
    };
}

- (id)collectionNode:(ASCollectionNode *)collectionNode nodeModelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _data[indexPath.item];
}

- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 0) {
        return [[KKBlurbNode alloc] init];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter] && indexPath.section == 0) {
        return [[KKLodingNode alloc] init];
    }
    return nil;
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KKCollectionViewModel *nodeViewModel = _data[indexPath.row];
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.view.frame) - 2 * kHorizontalSectionPadding;
    CGFloat oneItemWidth = [self preferredViewSize].width;
    NSInteger numColumns = floor(collectionViewWidth / oneItemWidth);
    // Number of columns should be at least 1
    numColumns = MAX(1, numColumns);

    CGFloat totalSpaceBetweenColumns = (numColumns - 1) * kHorizontalSectionPadding;
    CGFloat itemWidth = ((collectionViewWidth - totalSpaceBetweenColumns) / numColumns);
    CGSize itemSize = [self sizeForWidth:itemWidth viewModel:nodeViewModel];
    return ASSizeRangeMake(itemSize, itemSize);
}

- (CGSize)sizeForWidth:(CGFloat)width viewModel:(KKCollectionViewModel *)nodeViewModel
{
    CGFloat imageHeight = width * (10 / 21.0f);
    
    
    CGFloat kInsetTop = 6.0;
    CGSize titleSize = [nodeViewModel.titleText boundingSizeWithAttribuiteDic:[KKCollectionStyles titleStyle] maxWidth:width maxNumOfLines:2];
    
    CGSize infoSize = [nodeViewModel.firstInfoText boundingSizeWithAttribuiteDic:[KKCollectionStyles subtitleStyle] maxWidth:width maxNumOfLines:1];
    
    CGSize secondInfoSize = [nodeViewModel.secondInfoText boundingSizeWithAttribuiteDic:[KKCollectionStyles secondInfoStyle] maxWidth:width maxNumOfLines:1];
    
    CGSize finalPiceSize = [nodeViewModel.finalPriceText boundingSizeWithAttribuiteDic:[KKCollectionStyles finalPriceStyle] maxWidth:width maxNumOfLines:1];
    
    CGFloat contentHeight = titleSize.height + infoSize.height + MAX(secondInfoSize.height, finalPiceSize.height) + kInsetTop * 2;
    
    
    CGFloat height = contentHeight + imageHeight;
    return CGSizeMake(width, height);
}

- (CGSize)preferredViewSize
{
    return CGSizeMake(320.0, 320.0);
}

- (CGFloat)scaledHeightForPreferredSize:(CGSize)preferredSize scaledWidth:(CGFloat)scaledWidth
{
    
    
    CGFloat scaledHeight = scaledWidth;
    
    return scaledHeight;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    return [_data count];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
    return 1;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [self fetchMoreCatsWithCompletion:^(BOOL finished){
        [context completeBatchFetching:YES];
    }];
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

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode sizeRangeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return ASSizeRangeUnconstrained;
    } else {
        return ASSizeRangeZero;
    }
}

@end
