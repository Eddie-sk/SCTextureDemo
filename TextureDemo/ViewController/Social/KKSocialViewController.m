//
//  KKSocialViewController.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/5.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKSocialViewController.h"
#import "Post.h"
#import "KKSocialNode.h"

@interface KKSocialViewController ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) NSMutableArray *socialAppDataSource;

@end

@implementation KKSocialViewController

- (instancetype)init {
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
//    _tableNode.inverted = YES;
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    self = [super initWithNode:_tableNode];
    if (!self) {
        return nil;
    }
    self.title = @"Timeline";
    
    [self createSocialAppDataSource];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (CGFloat)topBarsHeight {
    if ((self.edgesForExtendedLayout & UIRectEdgeTop) == 0) {
        return 0.0;
    }
    return CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

#pragma mark - Data Model

- (void)createSocialAppDataSource {
    
    _socialAppDataSource = [[NSMutableArray alloc] init];
    
    Post *newPost = [[Post alloc] init];
    newPost.name = @"Apple Guy";
    newPost.username = @"@appleguy";
    newPost.photo = @"https://avatars1.githubusercontent.com/u/565251?v=3&s=96";
    newPost.post = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    newPost.time = @"3s";
    newPost.media = @"";
    newPost.via = 0;
    newPost.likes = arc4random_uniform(74);
    newPost.comments = arc4random_uniform(40);
    [_socialAppDataSource addObject:newPost];
    
    newPost = [[Post alloc] init];
    newPost.name = @"Huy Nguyen";
    newPost.username = @"@nguyenhuy";
    newPost.photo = @"https://avatars2.githubusercontent.com/u/587874?v=3&s=96";
    newPost.post = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    newPost.time = @"1m";
    newPost.media = @"";
    newPost.via = 1;
    newPost.likes = arc4random_uniform(74);
    newPost.comments = arc4random_uniform(40);
    [_socialAppDataSource addObject:newPost];
    
    newPost = [[Post alloc] init];
    newPost.name = @"Alex Long Name";
    newPost.username = @"@veryyyylongusername";
    newPost.photo = @"https://avatars1.githubusercontent.com/u/8086633?v=3&s=96";
    newPost.post = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    newPost.time = @"3:02";
    newPost.media = @"http://www.ngmag.ru/upload/iblock/f93/f9390efc34151456598077c1ba44a94d.jpg";
    newPost.via = 2;
    newPost.likes = arc4random_uniform(74);
    newPost.comments = arc4random_uniform(40);
    [_socialAppDataSource addObject:newPost];
    
    newPost = [[Post alloc] init];
    newPost.name = @"Vitaly Baev";
    newPost.username = @"@vitalybaev";
    newPost.photo = @"https://avatars0.githubusercontent.com/u/724423?v=3&s=96";
    newPost.post = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. https://github.com/facebook/AsyncDisplayKit Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    newPost.time = @"yesterday";
    newPost.media = @"";
    newPost.via = 1;
    newPost.likes = arc4random_uniform(74);
    newPost.comments = arc4random_uniform(40);
    [_socialAppDataSource addObject:newPost];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self.socialAppDataSource[indexPath.row];
    ASCellNode *(^ASCellNodeBlock)(void) = ^ASCellNode *() {
        KKSocialNode *cellNode = [[KKSocialNode alloc] initWithPost:post];
        return cellNode;
    };
    return ASCellNodeBlock;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.socialAppDataSource.count;
}


@end
