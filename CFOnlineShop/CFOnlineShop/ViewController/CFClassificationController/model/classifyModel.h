//
//  classifyModel.h
//  CFOnlineShop
//
//  Created by app on 2019/5/30.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface classifyModel : FSBaseModel
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * thumLogo;
@property (nonatomic, copy) NSString * categoryId;

@end

NS_ASSUME_NONNULL_END
