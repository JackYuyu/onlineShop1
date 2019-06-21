//
//  DCFeatureList.h
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCFeatureList : NSObject

/** 类型名 */
@property (nonatomic, copy) NSString *infoname;
/** 额外价格 */
@property (nonatomic, copy) NSString *plusprice;
@property (nonatomic, copy) NSString *priceId;
//新skulogolist接口字段
@property (nonatomic, copy) NSString *thumLogo;
@property (nonatomic, copy) NSString *goodsSkuVals;
@property (nonatomic, copy) NSString *stockNum;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsId;

/** 是否点击 */
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic, copy) NSString *goodsSkuId;

@end
