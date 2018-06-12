//
//  KKHorizontalContentView.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/6.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKHorizontalContentView.h"
#import "KKGradientTableNode.h"

@interface KKHorizontalContentView ()<ASPagerDelegate, ASPagerDataSource>
@property (nonatomic, strong) ASPagerNode *pageNode;
@end

@implementation KKHorizontalContentView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _pageNode = [[ASPagerNode alloc] init];
        _pageNode.delegate = self;
        _pageNode.dataSource = self;
        ASDisplayNode.shouldShowRangeDebugOverlay = YES;
        self.title = @"Paging Table Nodes";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo
                                                                                               target:self
                                                                                               action:@selector(reloadEverything)];
        
    }
    return self;
}


- (void)reloadEverything
{
    [_pageNode reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubnode:_pageNode];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _pageNode.frame = self.view.bounds;
}


- (ASCellNode *)pagerNode:(ASPagerNode *)pagerNode nodeAtIndex:(NSInteger)index {
    CGSize boundsSize = pagerNode.bounds.size;
    CGSize gradientRowSize = CGSizeMake(boundsSize.width, 100);
    KKGradientTableNode *node = [[KKGradientTableNode alloc] initWithElementSize:gradientRowSize];
    node.pageNumber = index;
    return node;
}

- (NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode {
    return 10;
}

@end
