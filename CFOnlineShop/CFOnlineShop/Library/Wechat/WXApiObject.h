//
//  WXApiObject.h
//  BuyPay
//
//  Created by 杨慧超 on 2018/6/28.
//  Copyright © 2018年 Mr*yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXApiObject : NSObject

+ (WXApiObject *)shareInstance;


- (void)WXApiPayWithParam:(NSDictionary *)paydic;

@end
