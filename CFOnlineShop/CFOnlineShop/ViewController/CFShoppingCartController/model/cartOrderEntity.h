//
//  cartOrderEntity.h
//  CFOnlineShop
//
//  Created by mac on 2019/6/9.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface cartOrderEntity : NSObject
@property (nonatomic, strong) NSString * deliverStatus;
@property (nonatomic, strong) NSString * auditStatus;
@property (nonatomic, strong) NSString * logisticsCode;
@property (nonatomic, strong) NSString * logisticsNo;
@property (nonatomic, strong) NSString * payStatus;
@property (nonatomic, strong) NSString * totalPrice;
@property (nonatomic, strong) NSString * hasDefaultAddress;
@property (nonatomic, strong) NSString * totalGoodsPrice;
@property (nonatomic, strong) NSString * actualPrice;
@property (nonatomic, strong) NSString * openId;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * remarks;

@end

NS_ASSUME_NONNULL_END
