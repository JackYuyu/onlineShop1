//
//  MBProgressHUD+Add.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

// MBProgressHUD 文本提示框
+ (void) showMBProgressHud:(UIView* )view withText:(NSString* )str withTime:(CGFloat)time;

+ (void) showMBProgressHud:(UIView *)view withTitle:(NSString *)str detail:(NSString* )detail withTime:(CGFloat)time;
+ (void) showMBProgressHud:(UIView *)view withTitle:(NSString *)str detail:(NSString* )detail withTime:(CGFloat)time completion:(void(^)())block;

@end
