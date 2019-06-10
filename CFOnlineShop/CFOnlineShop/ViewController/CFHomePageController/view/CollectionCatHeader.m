//
//  CollectionCatHeader.m
//  CFOnlineShop
//
//  Created by app on 2019/5/23.
//  Copyright © 2019年 俞渊华. All rights reserved.
//

#import "CollectionCatHeader.h"

@implementation CollectionCatHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *array = @[@"catcommodity_6"];
        CGRect a=CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Width/16*7);
        //本地加载图片的轮播器
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.frame imageNamesGroup:array];
        _cycleScrollView.backgroundColor = kWhiteColor;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.currentPageDotColor = kRedColor;
        _cycleScrollView.autoScroll=false;
        [self addSubview:_cycleScrollView];
        
    }
    return self;
}
-(void)setModel:(topicModel *)model
{
    [_cycleScrollView setImageURLStringsGroup:model.ad];
}
@end
