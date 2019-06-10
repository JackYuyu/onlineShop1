//
//  CFHomeCollectionHeader.h
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/19.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "topicModel.h"
#import "SDCycleScrollView.h"

@interface CFHomeCollectionHeader : UICollectionReusableView
@property (nonatomic, strong) topicModel *model;
@property (nonatomic,strong) SDCycleScrollView* cycleScrollView;
@end
