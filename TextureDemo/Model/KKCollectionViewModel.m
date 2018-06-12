//
//  KKCollectionViewModel.m
//  TextureDemo
//
//  Created by sunkai on 2018/6/4.
//  Copyright © 2018年 CCWork. All rights reserved.
//

#import "KKCollectionViewModel.h"
#import <stdatomic.h>

static  NSArray const*titles;
static  NSArray const*firstInfos;
static  NSArray const*badges;

@interface KKCollectionViewModel()
@property (nonatomic, assign) NSInteger catNumber;
@property (nonatomic, assign) NSInteger labelNumber;
@end

@implementation KKCollectionViewModel


+(KKCollectionViewModel *)randomItem {
    return [[KKCollectionViewModel alloc] init];
}

+ (void)initialize {
    
    titles = @[@"Leave fur on owners clothes intrigued by the shower",
               @"Meowwww",
               @"Immediately regret falling into bathtub stare out the window",
               @"Jump launch to pounce upon little yarn mouse, bare fangs at toy run hide in litter box until treats are fed",
               @"Sleep nap",
               @"Lick butt",
               @"Chase laser lick arm hair present belly, scratch hand when stroked"];
    firstInfos = @[@"Kitty Shop",
                   @"Cat's r us",
                   @"Fantastic Felines",
                   @"The Cat Shop",
                   @"Cat in a hat",
                   @"Cat-tastic"
                   ];
    
    badges = @[@"ADORABLE",
               @"BOUNCES",
               @"HATES CUCUMBERS",
               @"SCRATCHY"
               ];
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    static _Atomic(NSInteger) nextID = ATOMIC_VAR_INIT(1);
    _identifier = atomic_fetch_add(&nextID, 1);
    _titleText = [self randomObjectFromArray:titles];
    _firstInfoText = [self randomObjectFromArray:firstInfos];
    _secondInfoText = [NSString stringWithFormat:@"%u+ bought",[self randomNumberInRange:5 to:6000]];
    _originalPriceText = [NSString stringWithFormat:@"$%u",[self randomNumberInRange:40 to:90]];
    _finalPriceText = [NSString stringWithFormat:@"$%u",[self randomNumberInRange:5 to:30]];
    
    _soldOutText = (arc4random() % 5 == 0) ? @"SOLD OUT" : nil;
    _distanceLabelText = [NSString stringWithFormat:@"%u mi", [self randomNumberInRange:1 to:20]];
    if (arc4random() % 2 == 0) {
        _badgeText = [self randomObjectFromArray:badges];
    }
    _catNumber = [self randomNumberInRange:1 to:10];
    _labelNumber = [self randomNumberInRange:1 to:10000];
    return self;
}

- (NSURL *)imageURLWithSize:(CGSize)size {
    NSString *imageText = [NSString stringWithFormat:@"Fun cat pic %zd",self.labelNumber];
    NSString *urlString = [NSString stringWithFormat:@"https://placekitten.com/%zd/%zd",(NSInteger)roundl(size.width),(NSInteger)roundl(size.height)];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    return [NSURL URLWithString:urlString];
}

- (id)randomObjectFromArray:(NSArray *)strings
{
    u_int32_t ipsumCount = (u_int32_t)[strings count];
    u_int32_t location = arc4random_uniform(ipsumCount);
    
    return strings[location];
}

- (uint32_t)randomNumberInRange:(uint32_t)start to:(uint32_t)end {
    
    return start + arc4random_uniform(end - start);
}

@end
