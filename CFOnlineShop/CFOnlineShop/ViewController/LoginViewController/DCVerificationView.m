//
//  DCVerificationView.m
//  STOExpressDelivery
//
//  Created by 陈甸甸 on 2018/2/6.
//Copyright © 2018年 STO. All rights reserved.
//

#import "DCVerificationView.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCVerificationView ()<UITextFieldDelegate>

/* 用户名 */
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
/* 验证码 */
@property (weak, nonatomic) IBOutlet UITextField *verificationField;
/* 验证码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;

@end

@implementation DCVerificationView

#pragma mark - Intial
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUpBase];
}


#pragma mark - initialize
- (void)setUpBase
{
    _loginButton.enabled = _verificationButton.enabled = NO;
    _loginButton.backgroundColor = _verificationButton.backgroundColor =[UIColor lightGrayColor];
    [_userNameField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    [_verificationField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
//    [DCSpeedy dc_setSomeOneChangeColor:_agreementLabel SetSelectArray:@[@"《",@"》",@"服",@"务",@"协",@"议"] SetChangeColor:RGB(56, 152, 181)];

}
-(IBAction)loginClick:(UIButton*)sender
{
    NSInteger a=sender.tag;
    if (a==1) {
            NSMutableDictionary* dic=[NSMutableDictionary new];
            NSDictionary *params = @{
                                     @"mobile" : _userNameField.text,
                                     @"password": _verificationField.text
                                     };
            NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
            [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/app/register"] body:data showLoading:false success:^(NSDictionary *response) {
                NSString * str  =[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                NSLog(@"");
                if(self.block)
                    self.block();
            } failure:^(NSError *error) {
                NSLog(@"");
            }];
    }
    else{
        [self verify];
    }
}
-(void)code
{
    NSDictionary *params = @{
                             @"phone" : _userNameField.text
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/usermessageinfo/setPhone"] body:data showLoading:false success:^(NSDictionary *response) {
        NSString * str  =[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"");

    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)verify
{
    NSDictionary *params = @{
                             @"phone" : _userNameField.text,
                             @"code" : _verificationField.text
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/customerinfo/checkingPhone"] body:data showLoading:false success:^(NSDictionary *response) {
        NSLog(@"");
        NSMutableDictionary* dic=[NSMutableDictionary new];
        NSDictionary *params = @{
                                 @"mobile" : _userNameField.text,
                                 @"password": @"123456"
                                 };
        NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
        [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/app/login"] body:data showLoading:false success:^(NSDictionary *response) {
            //        NSString * str  =[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            //        NSData * datas = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            [MySingleton sharedMySingleton].openId=[jsonDict objectForKey:@"openid"];
            NSLog(@"");
            NSString *passWord = [jsonDict objectForKey:@"openid"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:passWord forKey:@"openid"];
            [user synchronize];
            if (self.block) {
                self.block();
            }
        } failure:^(NSError *error) {
            NSLog(@"");
        }];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
#pragma mark - Setter Getter Methods


#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_userNameField.text.length != 0) {
        _verificationButton.backgroundColor = RGBCOLOR(252, 159, 149);
        _verificationButton.enabled = YES;
    }else{
        _verificationButton.backgroundColor = [UIColor lightGrayColor];
        [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verificationButton.enabled = NO;
    }
    
    if (_userNameField.text.length != 0 && _verificationField.text.length != 0) {
        _loginButton.backgroundColor = RGBCOLOR(252, 159, 149);
        _loginButton.enabled = YES;
    }else{
        _loginButton.backgroundColor = [UIColor lightGrayColor];
        _loginButton.enabled = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


#pragma mark - 验证点击
- (IBAction)validationClick:(UIButton *)sender {
    [self code];
    __block NSInteger time = 59; //设置倒计时时间
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    WeakSelf(self)
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [weakself.verificationButton setTitle:@"重新发送" forState:UIControlStateNormal];
                weakself.verificationButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            NSInteger seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [weakself.verificationButton setTitle:[NSString stringWithFormat:@"重新发送(%.2ld)", (long)seconds] forState:UIControlStateNormal];
                weakself.verificationButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
