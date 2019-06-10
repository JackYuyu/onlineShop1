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
        
        UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        addButton.frame = CGRectMake(15, MaxY(_titleStr) + 10, 80, 20);
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.titleLabel.font = SYSTEMFONT(14);
        [addButton setTitle:@"加入购物车" forState:(UIControlStateNormal)];
        [addButton setTitleColor:kRedColor forState:(UIControlStateNormal)];
        [addButton addTarget:self action:@selector(addAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:addButton];
        
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
