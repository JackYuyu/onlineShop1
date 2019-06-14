//
//  CFActivityController.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/8/6.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFActivityController.h"

@interface CFActivityController ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CFActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
    label.font = SYSTEMFONT(16);
    label.textColor = KDarkTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"没有内容";
    [self.view addSubview:label];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 55, Main_Screen_Width, Main_Screen_Height - 55)];
    _webView.backgroundColor = [UIColor clearColor];
    
    _webView.scrollView.delegate = self;
    
 
    [self.view addSubview:_webView];
}

-(void)loadWeb
{
    NSString* a=[MySingleton sharedMySingleton].pModel.logo;
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[MySingleton sharedMySingleton].pModel.logo]]];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
