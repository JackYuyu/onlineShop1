//
//  newPassWardViewController.h
//  chuanke
//
//  Created by mj on 15/11/30.
//  Copyright © 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFBaseController.h"

@class  login;
@interface newPassWardViewController : CFBaseController
@property(nonatomic,strong)NSMutableDictionary* dict;
@property(nonatomic,copy) login *logininfo;

//从a传值到b  属性必须定义在.h文件中
@property(nonatomic,strong)NSString *userPhone;
@end
