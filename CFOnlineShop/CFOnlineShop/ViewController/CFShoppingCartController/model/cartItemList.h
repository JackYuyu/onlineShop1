//
//  cartItemList.h
//  CFOnlineShop
//
//  Created by mac on 2019/6/9.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface cartItemList : NSObject
@property (nonatomic, strong) NSString * goodsId;
@property (nonatomic, strong) NSString * goodsSkuId;
@property (nonatomic, strong) NSString * priceId;
@property (nonatomic, strong) NSString * num;
@property (nonatomic, strong) NSString * evaluateStatus;
@property (nonatomic, strong) NSString * status;

@end

NS_ASSUME_NONNULL_END
