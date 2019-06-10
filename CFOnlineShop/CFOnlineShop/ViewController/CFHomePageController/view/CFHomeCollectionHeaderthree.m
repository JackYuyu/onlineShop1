//
//  CFHomeCollectionHeaderthree.m
//  CFOnlineShop
//
//  Created by app on 2019/5/27.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "CFHomeCollectionHeaderthree.h"
#import "UIView+Extension.h"
#import "CFHomeHeaderTwoCell.h"

@interface CFHomeCollectionHeaderthree ()<GYRollingNoticeViewDataSource, GYRollingNoticeViewDelegate>
{
    
}
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray* buttons;
@end
@implementation CFHomeCollectionHeaderthree
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _uv=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 80)];
//        [_uv setBackgroundColor:[UIColor blueColor]];

        UITapGestureRecognizer* rec=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCellTapAction:)];
        [_uv addGestureRecognizer:rec];
        
        UILabel* recommend=[[UILabel alloc] initWithFrame:CGRectMake((Main_Screen_Width-80)/2, 10, 150, 50)];
        recommend.font=[UIFont systemFontOfSize:18];
        recommend.text=@"商品推荐";
        [_uv addSubview:recommend];
//        [_uv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_uv).offset(10);
//            make.centerX.mas_equalTo(_uv).offset(100);
//
//            make.width.equalTo(@150);
//            make.height.equalTo(@50);
//
//        }];
        [self addSubview:_uv];
        
    }
    return self;
}
- (void)handleCellTapAction:(UITapGestureRecognizer *)selfTap{
    
}
- (UIView *)contentView {
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

@end
