//
//  KKKittenViewController.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/2.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKKittenViewController.h"
#import "KKBlurbNode.h"
#import "KKKittenNode.h"

static const NSInteger kLitterSize = 20;            // intial number of kitten cells in ASTableNode
static const NSInteger kLitterBatchSize = 10;       // number of kitten cells to add to ASTableNode
static const NSInteger kMaxLitterSize = 100;        // max number of kitten cells allowed in ASTableNode

@interface KKKittenViewController () <ASTableDataSource, ASTableDelegate>
{
    ASTableNode *_tableNode;
    
    // array of boxed CGSizes corresponding to placekitten.com kittens
    NSMutableArray *_kittenDataSource;
    
    NSIndexPath *_blurbNodeIndexPath;
}
@property (nonatomic, strong) NSMutableArray *kittenDataSource;

@end

@implementation KKKittenViewController

- (instancetype)init {
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.dataSource = self;
    _tableNode.delegate = self;
    
    self = [super initWithNode:_tableNode];
    if (self) {
        _kittenDataSource = [self createLitterWithSize:kLitterSize];
        _blurbNodeIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        self.title = @"Kittens";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditingMode)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Data Model

- (NSMutableArray *)createLitterWithSize:(NSInteger)litterSize
{
    NSMutableArray *kittens = [NSMutableArray arrayWithCapacity:litterSize];
    for (NSInteger i = 0; i < litterSize; i++) {
        
        // placekitten.com will return the same kitten picture if the same pixel height & width are requested,
        // so generate kittens with different width & height values.
        u_int32_t deltaX = arc4random_uniform(10) - 5;
        u_int32_t deltaY = arc4random_uniform(10) - 5;
        CGSize size = CGSizeMake(350 + 2 * deltaX, 350 + 4 * deltaY);
        
        [kittens addObject:[NSValue valueWithCGSize:size]];
    }
    return kittens;
}

- (void)toggleEditingMode
{
    [_tableNode.view setEditing:!_tableNode.view.editing animated:YES];
}

#pragma mark - ASTableNode

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_blurbNodeIndexPath compare:indexPath] == NSOrderedSame) {
        KKBlurbNode *node = [[KKBlurbNode alloc] init];
        return node;
    }
    NSValue *size = _kittenDataSource[indexPath.row - 1];
    KKKittenNode *node = [[KKKittenNode alloc] initWithKittenOfSize:size.CGSizeValue];
    return node;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return  1 + _kittenDataSource.count;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableNode deselectRowAtIndexPath:indexPath animated:YES];
    
    // Assume only kitten nodes are selectable (see -tableNode:shouldHighlightRowAtIndexPath:).
    KKKittenNode *node = (KKKittenNode *)[_tableNode nodeForRowAtIndexPath:indexPath];
    
    [node toggleImageEnlargement];
}

- (BOOL)tableNode:(ASTableNode *)tableNode shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_blurbNodeIndexPath compare:indexPath] != NSOrderedSame;
}

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // populate a new array of random-sized kittens
        NSArray *moarKittens = [self createLitterWithSize:kLitterBatchSize];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        // find number of kittens in the data source and create their indexPaths
        NSInteger existingRows = _kittenDataSource.count + 1;
        
        for (NSInteger i = 0; i < moarKittens.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:existingRows + i inSection:0]];
        }
        
        // add new kittens to the data source & notify table of new indexpaths
        [_kittenDataSource addObjectsFromArray:moarKittens];
        [tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        [context completeBatchFetching:YES];
    });
}

- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    
    return _kittenDataSource.count < kMaxLitterSize;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Enable editing for Kitten nodes
    return [_blurbNodeIndexPath compare:indexPath] != NSOrderedSame;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Assume only kitten nodes are editable (see -tableView:canEditRowAtIndexPath:).
        [_kittenDataSource removeObjectAtIndex:indexPath.row - 1];
        [_tableNode deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
