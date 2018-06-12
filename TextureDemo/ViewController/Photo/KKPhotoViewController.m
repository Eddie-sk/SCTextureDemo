//
//  KKPhotoViewController.m
//  TextureDemo
//
//  Created by sunkai on 2018/5/30.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKPhotoViewController.h"
#import "PhotoFeedModel.h"
#import "PhotoCellNode.h"

@interface KKPhotoViewController ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) PhotoFeedModel *photoFeed;

@end

@implementation KKPhotoViewController

- (instancetype)init {
    _tableNode = [[ASTableNode alloc] init];
    self = [super initWithNode:_tableNode];
    
    if (self) {
        _tableNode.dataSource = self;
        _tableNode.delegate = self;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _photoFeed = [[PhotoFeedModel alloc] initWithPhotoFeedModelType:PhotoFeedModelTypePopular imageSize:[self imageSizeForScreenWidth]];
    
    [self refreshFeed];
    
    self.tableNode.leadingScreensForBatching = 2.5;
    self.tableNode.allowsSelection = NO;
    
}

- (void)refreshFeed
{
    // small first batch
    [_photoFeed refreshFeedWithCompletionBlock:^(NSArray *newPhotos){
        
        
        [self.tableNode reloadData];
        
        // immediately start second larger fetch
        [self loadPage];
        
    } numResultsToReturn:4];
}

- (void)insertNewRows:(NSArray *)newPhotos
{
    NSInteger section = 0;
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    NSInteger newTotalNumberOfPhotos = [_photoFeed numberOfItemsInFeed];
    NSInteger existingNumberOfPhotos = newTotalNumberOfPhotos - newPhotos.count;
    for (NSInteger row = existingNumberOfPhotos; row < newTotalNumberOfPhotos; row++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
        [indexPaths addObject:path];
    }
    [self.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)loadPageWithContext:(ASBatchContext *)context
{
    [self.photoFeed requestPageWithCompletionBlock:^(NSArray *newPhotos){
        
        [self insertNewRows:newPhotos];
        if (context) {
            [context completeBatchFetching:YES];
        }
    } numResultsToReturn:20];
}

- (void)loadPage {
    [self loadPageWithContext:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFeed)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - ASTableViewDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [self.photoFeed numberOfItemsInFeed];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    Photo *photoModel = [self.photoFeed objectAtIndex:indexPath.row];
    ASCellNode *(^ASCellNodeBlock)(void) = ^ASCellNode *() {
        PhotoCellNode *cellNode = [[PhotoCellNode alloc] initWithPhotoObject:photoModel];
        return cellNode;
    };
    return ASCellNodeBlock;
}


- (CGSize)imageSizeForScreenWidth
{
    CGRect screenRect   = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    return CGSizeMake(screenRect.size.width * screenScale, screenRect.size.width * screenScale);
}

@end
