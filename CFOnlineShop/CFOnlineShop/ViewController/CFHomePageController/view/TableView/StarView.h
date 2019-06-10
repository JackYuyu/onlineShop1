//
//  StarView.h
//  StarDemo_2016.1.29
//
//  Created by 张重 on 16/1/29.
//  Copyright © 2016年 张重. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView

/** 最大等分    */
@property (nonatomic,assign) NSInteger max_star;

/** 显示多少份*/
@property (nonatomic,assign) NSInteger show_star;

/** 设置字体*/
@property (nonatomic,assign) CGFloat font_size;

/** 填充色*/
@property (nonatomic,strong) UIColor *full_color;

/** ---默认色*/
@property (nonatomic,strong) UIColor *empty_color;

/** 设置是否可以点击选中   yes可以点击，拖动 No 用来简单显示*/
@property (nonatomic,assign) BOOL canSelected;


@end
