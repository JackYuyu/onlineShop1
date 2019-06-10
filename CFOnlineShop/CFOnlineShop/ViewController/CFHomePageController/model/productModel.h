//
//  productModel.h
//  CFOnlineShop
//
//  Created by app on 2019/5/29.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface productModel : FSBaseModel
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, copy) NSString * priceName;
@property (nonatomic, copy) NSString * costPrice;
@property (nonatomic, copy) NSString * evaluateCount;
//@property (nonatomic, copy) NSString * description;
@property (nonatomic, copy) NSString * logo;
@property (nonatomic, copy) NSString * thumLogo;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, copy) NSString * goodsSkuId;
@property (nonatomic, copy) NSString * marketPrice;
@property (nonatomic, copy) NSString * detailInfo;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * goodNorm;

@end

NS_ASSUME_NONNULL_END
