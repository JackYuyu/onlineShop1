//
//  addressModel.h
//  CFOnlineShop
//
//  Created by app on 2019/6/4.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface addressModel : FSBaseModel
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * receiptName;

@property (nonatomic, copy) NSString * receiptTelphone;
@property (nonatomic, copy) NSString * provinceName;
@property (nonatomic, copy) NSString * cityName;
@property (nonatomic, copy) NSString * areaName;
@property (nonatomic, copy) NSString * street;

@end

NS_ASSUME_NONNULL_END
