//
//  skuModel.h
//  CFOnlineShop
//
//  Created by mac on 2019/6/9.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface skuModel : FSBaseModel
@property (nonatomic, copy) NSString * goodsSkuVals;
@property (nonatomic, copy) NSString * goodsNorm;
@property (nonatomic, copy) NSString * priceId;
@property (nonatomic, copy) NSString * priceName;

@end

NS_ASSUME_NONNULL_END
