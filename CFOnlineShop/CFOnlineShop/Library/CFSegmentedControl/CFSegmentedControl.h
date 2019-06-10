//
//  CFSegmentedControl.h
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/20.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFSegmentedControlDataSource <NSObject>
@required
//获取分段title显示
- (NSArray *)getSegmentedControlTitles;
@end

@class CFSegmentedControl;

@protocol CFSegmentedControlDelegate <NSObject>
@optional
- (void)control:(CFSegmentedControl *)control didSelectAtIndex:(NSInteger )index;
@end

@interface CFSegmentedControl : UIView

@property (nonatomic, weak) id <CFSegmentedControlDataSource> dataSource;
@property (nonatomic, weak) id <CFSegmentedControlDelegate> delegate;
@property (nonatomic, strong) UIView *bottomLine;//底部滑动横线
@property (nonatomic, assign) NSInteger tapIndex;

- (void)didSelectIndex:(NSInteger )index;

@end
