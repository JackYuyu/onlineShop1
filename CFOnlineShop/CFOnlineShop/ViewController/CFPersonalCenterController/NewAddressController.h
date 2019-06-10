//
//  NewAddressController.h
//  CFOnlineShop
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewAddressController : CFBaseController
@property (nonatomic,strong) NSString* province;
@property (nonatomic,strong) NSString* city;
@property (nonatomic,strong) NSString* area;
@property (nonatomic,strong) NSString* addressInfo;

@property (nonatomic,strong) NSString* input;
@property (nonatomic,strong) NSString* input1;
@property (nonatomic,strong) NSString* input3;
@end

NS_ASSUME_NONNULL_END
