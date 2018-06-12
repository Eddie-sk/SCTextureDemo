//
//  KKImageCollectionViewCell.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/12.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKImageCollectionViewCell.h"

@implementation KKImageCollectionViewCell
{
    UILabel *_title;
    UILabel *_description;
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self) {
        _title = [[UILabel alloc] init];
        _title.text = @"UICollectionViewCell";
        [self.contentView addSubview:_title];
        
        _description = [[UILabel alloc] init];
        _description.text = @"description for cell";
        [self.contentView addSubview:_description];
        
        self.contentView.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_title sizeToFit];
    [_description sizeToFit];
    
    CGRect frame = _title.frame;
    frame.origin.y = _title.frame.size.height;
    _description.frame = frame;
}
@end
