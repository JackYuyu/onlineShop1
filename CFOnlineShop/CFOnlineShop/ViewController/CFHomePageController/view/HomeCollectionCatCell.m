//
//  HomeCollectionCatCell.m
//  CFOnlineShop
//
//  Created by app on 2019/5/23.
//  Copyright © 2019年 俞渊华. All rights reserved.
//

#import "HomeCollectionCatCell.h"

@implementation HomeCollectionCatCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.backgroundColor = kWhiteColor;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.mj_w, self.mj_w)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        _titleStr = [[UILabel alloc] initWithFrame:CGRectMake(15, self.mj_w + 15, self.mj_w - 30, 20)];
        _titleStr.font = SYSTEMFONT(14);
        _titleStr.textColor = KDarkTextColor;
        [self.contentView addSubview:_titleStr];
        
        _addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _addButton.frame = CGRectMake(15, MaxY(_titleStr) + 10, 80, 20);
        _addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addButton.titleLabel.font = SYSTEMFONT(14);
        [_addButton setTitle:@"加入购物车" forState:(UIControlStateNormal)];
        [_addButton setTitleColor:kRedColor forState:(UIControlStateNormal)];
        [_addButton addTarget:self action:@selector(addAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.contentView addSubview:_addButton];
        
        _titleStr2 = [[UILabel alloc] initWithFrame:CGRectMake(_addButton.mj_w-25, MaxY(_titleStr) + 10, 40, 20)];
        _titleStr2.font = SYSTEMFONT(14);
        _titleStr2.textColor = KDarkTextColor;
        [self.contentView addSubview:_titleStr2];
        
        _titleStr1 = [[UILabel alloc] initWithFrame:CGRectMake(_addButton.mj_w+25, MaxY(_titleStr) + 10, 80, 20)];
        _titleStr1.font = SYSTEMFONT(14);
        _titleStr1.textColor = KDarkTextColor;
        [self.contentView addSubview:_titleStr1];
    }
    
    return self;
}

- (void)addAction:(UIButton *)sender
{
    if (_addToShoppingCar != nil) {
        _addToShoppingCar(_imageView);
    }
}
@end
