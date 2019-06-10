//
//  DCLoginViewController.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/28.
//Copyright © 2017年 STO. All rights reserved.
//

#import "DCLoginViewController.h"
#import "DCRegisteredViewController.h"

// Controllers
//#import "DCNavigationController.h"
//#import "DCTabBarController.h"
//#import "DCRegisteredViewController.h"
// Models

// Views
//#import "DCAccountPsdView.h" //账号密码登录
#import "DCVerificationView.h" //验证码登录
// Vendors

// Categories
#import "UIView+DCRolling.h"

// Others

@interface DCLoginViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *middleLoginView;
@property (weak, nonatomic) IBOutlet UIButton *reg;

/* 上一次选中的按钮 */
@property (strong , nonatomic)UIButton *selectBtn;
/* indicatorView */
@property (strong , nonatomic)UIView *indicatorView;
/* titleView */
@property (strong , nonatomic)UIView *titleView;
/* contentView */
@property (strong , nonatomic)UIScrollView *contentView;

/* 验证码 */
@property (strong , nonatomic)DCVerificationView *verificationView;
/* 账号密码登录 */
//@property (strong , nonatomic)DCAccountPsdView *accountPsdView;
@end

@implementation DCLoginViewController

#pragma mark - LazyLoad
- (UIScrollView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
        _contentView.bounces = NO;
        _contentView.delegate = self;
    }
    return _contentView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 0;
    [self showLeftBackButton];
    self.title = @"登录";

    [self sertUpBase];
    
    [self setUpTiTleView];
    
    [self setUpContentView];
    UIButton *firstButton = [UIButton new];
    firstButton.tag=1;
    [self buttonClick:firstButton];
    
    [_reg addTarget:self action:@selector(regs) forControlEvents:UIControlEventTouchUpInside];
}
-(void)regs
{
    DCRegisteredViewController *dcRegistVc = [DCRegisteredViewController new];
    [self.navigationController pushViewController:dcRegistVc animated:YES];
}
#pragma mark - base
- (void)sertUpBase {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
}

#pragma mark - 标题登录
- (void)setUpTiTleView
{
    _titleView = [UIView new];
    _titleView.frame = CGRectMake(0, 0, Main_Screen_Width, 35);
    [_middleLoginView addSubview:_titleView];
    
    NSArray *titleArray = @[@"",@"短信验证登录"];
    CGFloat buttonW = (_titleView.mj_w - 30) / 2;
    CGFloat buttonH = _titleView.mj_h - 3;
    CGFloat buttonX = 15;
    CGFloat buttonY = 0;
    for (NSInteger i = 0; i < titleArray.count; i++) {
        
        UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.tag = i;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.frame = CGRectMake((0.5 * buttonW) + buttonX, buttonY, buttonW, buttonH);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:button];
    }
    
    UIButton *firstButton = _titleView.subviews[0];
    [self buttonClick:firstButton];
    
    _indicatorView = [UIView new];
    _indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    
    
    [firstButton.titleLabel sizeToFit];
    
    _indicatorView.mj_h = 2;
    _indicatorView.mj_w = firstButton.titleLabel.mj_w;
    _indicatorView.dc_centerX = firstButton.dc_centerX;
    _indicatorView.mj_y = _titleView.dc_bottom - _indicatorView.mj_h;
    [_titleView addSubview:_indicatorView];
    
    self.contentView.contentSize = CGSizeMake(Main_Screen_Width * titleArray.count, 0);
}


#pragma mark - 按钮点击
- (void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    [_selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _selectBtn = button;
    
    WeakSelf(self)
    [UIView animateWithDuration:0.25 animations:^{
        weakself.indicatorView.mj_w = button.titleLabel.mj_w;
        weakself.indicatorView.dc_centerX = button.dc_centerX;
    }];
    
    CGPoint offset = _contentView.contentOffset;
    offset.x = _contentView.dc_width * 1;
    [_contentView setContentOffset:offset animated:YES];
}

#pragma mark - 内容
- (void)setUpContentView
{
    
    self.contentView.backgroundColor = [UIColor orangeColor];
    self.contentView.frame = CGRectMake(0, _titleView.dc_bottom + 10, Main_Screen_Width, _middleLoginView.dc_height - _titleView.dc_bottom - 10);
    [self.middleLoginView addSubview:_contentView];
    
    _verificationView = [DCVerificationView dc_viewFromXib];
    _verificationView.block = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [_contentView addSubview:_verificationView];
//    _accountPsdView = [DCAccountPsdView dc_viewFromXib];
//    [_contentView addSubview:_accountPsdView];

    _verificationView.frame = CGRectMake(Main_Screen_Width, 0, Main_Screen_Width, _middleLoginView.dc_height - _titleView.dc_height);
//    _accountPsdView.frame = CGRectMake(0, 0, ScreenW, _middleLoginView.dc_height - _titleView.dc_height);
}

#pragma mark - 注册
- (IBAction)registAccount {
    DCRegisteredViewController *dcRegistVc = [DCRegisteredViewController new];
    [self.navigationController pushViewController:dcRegistVc animated:YES];
//    NSMutableDictionary* dic=[NSMutableDictionary new];
//    NSDictionary *params = @{
//                             @"mobile" : @"15821414708",
//                             @"password": @"123456"
//                             };
//    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
//    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/app/register"] body:data showLoading:false success:^(NSDictionary *response) {
//        NSString * str  =[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
//        NSLog(@"");
//    } failure:^(NSError *error) {
//        NSLog(@"");
//    }];

}

#pragma mark - 退出当前界面
- (IBAction)dismissViewController {
    
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.dc_width;
    UIButton *button = _titleView.subviews[index];
    
    [self buttonClick:button];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end

