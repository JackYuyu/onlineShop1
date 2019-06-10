//
//  OrderModel.h
//  CFOnlineShop
//
//  Created by mac on 2019/6/4.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : FSBaseModel
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, copy) NSArray * goodsOrderItemVO;
@property (nonatomic, copy) NSDictionary * goodsOrderEntity;

@end

NS_ASSUME_NONNULL_END
