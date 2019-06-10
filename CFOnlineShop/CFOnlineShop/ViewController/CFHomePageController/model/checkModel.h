//
//  checkModel.h
//  CFOnlineShop
//
//  Created by app on 2019/6/3.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface checkModel : FSBaseModel
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * todayScore;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * signTime;
@property (nonatomic, copy) NSString * createdDt;

@end

NS_ASSUME_NONNULL_END
