//
//  JYAddressPicker.h
//  LakalaClient
//
//  Created by flying on 2018/8/17.
//  Copyright © 2018年 LR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectedItemBlock)(NSArray *addressArr);

@interface JYAddressPicker : UIViewController

+(JYAddressPicker *)jy_showAt:(UIViewController *)vc;
+(JYAddressPicker *)jy_showAt:(UIViewController *)vc defaultShow:(NSArray *)values;
@property (nonatomic, copy) SelectedItemBlock selectedItemBlock;

@end
