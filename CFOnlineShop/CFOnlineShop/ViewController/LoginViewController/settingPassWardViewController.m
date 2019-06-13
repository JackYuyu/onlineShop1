//
//  settingPassWardViewController.m
//  chuanke
//
//  Created by mj on 15/11/30.
//  Copyright © 2015年 jinzelu. All rights reserved.
//

#import "settingPassWardViewController.h"
#import "settinhHeaderViewController.h"
#import "MMZCViewController.h"

@interface settingPassWardViewController ()
{
    UIView *bgView;
    UITextField *passward;
    UITextField *nickname;

}

@end

@implementation settingPassWardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    self.title = @"登录";
    self.title=@"注册2/2";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createTextFields];
}

-(void)createTextFields
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 75, self.view.frame.size.width-90, 30)];
    label.text=@"请设置密码";
    label.textColor=[UIColor grayColor];
    label.textAlignment=UITextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
//    [self.view addSubview:label];
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 110, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    passward=[self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"6-20位字母或数字"];
    passward.clearButtonMode = UITextFieldViewModeWhileEditing;
    passward.secureTextEntry=YES;
    
    nickname=[self createTextFielfFrame:CGRectMake(100, 50, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"昵称名字"];
    nickname.clearButtonMode = UITextFieldViewModeWhileEditing;
   
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 25)];
    phonelabel.text=@"密码";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=UITextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *nicklabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 52, 50, 25)];
    nicklabel.text=@"昵称";
    nicklabel.textColor=[UIColor blackColor];
    nicklabel.textAlignment=UITextAlignmentLeft;
    nicklabel.font=[UIFont systemFontOfSize:14];
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
    landBtn.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    
    [bgView addSubview:passward];
    [bgView addSubview:nickname];

    [bgView addSubview:phonelabel];
    [bgView addSubview:nicklabel];
    [self.view addSubview:landBtn];
}

-(void)landClick
{
        if([passward.text isEqualToString:@""])
        {
            [MBProgressHUD showMBProgressHud:self.view withText:@"您还未设置密码" withTime:1];
            return;
        }
        else if (passward.text.length <6)
        {
            [MBProgressHUD showMBProgressHud:self.view withText:@"亲,密码长度至少六位" withTime:1];
            return;
        }
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"mobile" : _phone,
                             @"password": passward.text,
                             @"nickname": nickname.text
                             
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/app/register"] body:data showLoading:false success:^(NSDictionary *response) {
        NSString * str  =[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"");
        [self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];

    } failure:^(NSError *error) {
        NSLog(@"");
    }];
//    [self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];


//    [self.navigationController pushViewController:[[settinhHeaderViewController alloc]init] animated:YES];
    //[CheckTools savePassword:passward.text];
}

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
