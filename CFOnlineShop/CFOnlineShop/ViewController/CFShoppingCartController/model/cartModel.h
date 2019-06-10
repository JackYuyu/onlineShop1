//
//  cartModel.h
//  CFOnlineShop
//
//  Created by mac on 2019/6/9.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cartOrderEntity.h"
#import "cartItemList.h"
NS_ASSUME_NONNULL_BEGIN

@interface cartModel : NSObject
@property (nonatomic,strong) cartOrderEntity* goodsOrderEntity;
@property (nonatomic, strong) NSArray * goodsOrderItemList;

@end

NS_ASSUME_NONNULL_END
