//
//  DCRegisteredViewController.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/28.
//Copyright © 2017年 STO. All rights reserved.
//

#import "DCRegisteredViewController.h"

// Controllers

// Models

// Views
#import "DCVerificationView.h"
// Vendors

// Categories
#import "UIView+DCRolling.h"
// Others

@interface DCRegisteredViewController ()

/* 手机注册 */
@property (strong , nonatomic)DCVerificationView *verificationView;

@end

@implementation DCRegisteredViewController

#pragma mark - LazyLoad


#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 0;
    [self showLeftBackButton];
    self.title = @"注册";
    
    [self setUpBase];
}

- (void)setUpBase
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"手机注册";
    
    _verificationView = [DCVerificationView dc_viewFromXib];
    [_verificationView.loginButton setTitle:@"注册" forState:0];
    _verificationView.frame = CGRectMake(0, NavBarHeight+20, Main_Screen_Width, 400);
    _verificationView.agreementLabel.text = @"注册成功即代表同意《云邻服务协议》";
    _verificationView.loginButton.tag=1;
    _verificationView.block = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:_verificationView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
