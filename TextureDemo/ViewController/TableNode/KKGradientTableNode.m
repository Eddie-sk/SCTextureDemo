//
//  KKGradientTableNode.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/6.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKGradientTableNode.h"
#import "KKRandomCoreGraphicsNode.h"

@interface KKGradientTableNode () <ASTableDelegate, ASTableDataSource>
{
    ASTableNode *_tableNode;
    CGSize _elementSize;
}

@end

@implementation KKGradientTableNode

- (instancetype)initWithElementSize:(CGSize)size {
    if (!(self = [super init]))
        return nil;
    
    _elementSize = size;
    
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    
    ASRangeTuningParameters rangeTuningParameters;
    rangeTuningParameters.leadingBufferScreenfuls = 1.0;
    rangeTuningParameters.trailingBufferScreenfuls = 0.5;
    [_tableNode setTuningParameters:rangeTuningParameters forRangeType:ASLayoutRangeTypeDisplay];
    
    [self addSubnode:_tableNode];
    
    return self;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKRandomCoreGraphicsNode *elementNode = [[KKRandomCoreGraphicsNode alloc] init];
    elementNode.style.preferredSize = _elementSize;
    elementNode.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    return elementNode;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableNode reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)layout {
    [super layout];
    _tableNode.frame = self.bounds;
}

@end
