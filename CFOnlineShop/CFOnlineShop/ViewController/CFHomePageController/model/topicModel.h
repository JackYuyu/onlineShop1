//
//  topicModel.h
//  CFOnlineShop
//
//  Created by app on 2019/5/30.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface topicModel : FSBaseModel
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSArray * ad;
@property (nonatomic, copy) NSString * brandId;

@property (nonatomic, copy) NSString * signTime;

@end

NS_ASSUME_NONNULL_END
