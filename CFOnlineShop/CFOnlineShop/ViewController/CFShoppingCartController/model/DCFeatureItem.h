//
//  DCFeatureItem.h
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCFeatureList.h"
#import "DCFeatureTitleItem.h"
@class DCFeatureTitleItem,DCFeatureList;
@interface DCFeatureItem : NSObject

/* 名字 */
@property (strong , nonatomic)DCFeatureTitleItem *attr;
/* 数组 */
@property (strong , nonatomic)NSMutableArray<DCFeatureList *> *list;

@end
