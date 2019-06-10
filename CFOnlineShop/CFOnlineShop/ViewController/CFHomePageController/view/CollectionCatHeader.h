//
//  CollectionCatHeader.h
//  CFOnlineShop
//
//  Created by app on 2019/5/23.
//  Copyright © 2019年 俞渊华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "topicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectionCatHeader : UICollectionReusableView
@property (nonatomic,strong) SDCycleScrollView* cycleScrollView;
@property (nonatomic, strong) topicModel *model;

@end

NS_ASSUME_NONNULL_END
