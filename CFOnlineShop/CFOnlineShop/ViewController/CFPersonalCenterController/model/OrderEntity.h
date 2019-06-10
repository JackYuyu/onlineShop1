//
//  OrderEntity.h
//  CFOnlineShop
//
//  Created by mac on 2019/6/4.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderEntity : FSBaseModel
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * payStatus;
@property (nonatomic, copy) NSString * totalPrice;
@property (nonatomic, copy) NSString * logisticsCode;
@property (nonatomic, copy) NSMutableArray * productLists;

@end

NS_ASSUME_NONNULL_END
