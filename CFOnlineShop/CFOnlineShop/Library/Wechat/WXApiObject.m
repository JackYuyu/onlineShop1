//
//  WXApiObject.m
//  BuyPay
//
//  Created by 杨慧超 on 2018/6/28.
//  Copyright © 2018年 Mr*yang. All rights reserved.
//

#import "WXApiObject.h"
#import "WXApi.h"

@implementation WXApiObject

+ (WXApiObject *)shareInstance {
    
    static WXApiObject *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //线程安全
        sharedInstance = [[WXApiObject alloc] init];
    });
    return sharedInstance;
}
- (void)WXApiPayWithParam:(NSDictionary *)paydic
{
    if(!paydic.count)
    {
        return;
    }
    
    NSString *timestamp=[NSString stringWithFormat:@"%@",paydic[@"timestamp"]];
               /// 调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [paydic objectForKey:@"appId"];
        req.partnerId           = [paydic objectForKey:@"partnerId"];
        req.prepayId            = [paydic objectForKey:@"prepayId"];
        req.nonceStr            = [paydic objectForKey:@"noncestr"];
        req.timeStamp           = timestamp.intValue;
    req.package                 = @"Sign=WXPay";
        req.sign                = [paydic objectForKey:@"sign"];
        [WXApi sendReq:req];
    
    
}
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
