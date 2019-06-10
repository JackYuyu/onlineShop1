//
//  CFHomeCollectionHeader.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/19.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFHomeCollectionHeader.h"

@implementation CFHomeCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *array = @[@"advertisement_1",@"advertisement_2",@"advertisement_3"];
        CGRect a=self.frame;
        //本地加载图片的轮播器
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.frame imageNamesGroup:array];
        _cycleScrollView.backgroundColor = kWhiteColor;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.currentPageDotColor = kRedColor;
        [self addSubview:_cycleScrollView];
        
    }
    return self;
}
-(void)setModel:(topicModel *)model
{
        [_cycleScrollView setImageURLStringsGroup:model.ad];
}
@end
