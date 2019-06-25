//
//  CFShoppingCartCell1.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/25.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFShoppingCartCell1.h"

@implementation CFShoppingCartCell1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 60, 60)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        _titleStr = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_imageView) + 15, 15, 250, 20)];
        _titleStr.font = SYSTEMFONT(14);
        _titleStr.textColor = KDarkTextColor;
        [self.contentView addSubview:_titleStr];
        
        _priceStr = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_imageView) + 15, 45, 150, 20)];
        _priceStr.font = SYSTEMFONT(14);
        _priceStr.textColor = [UIColor redColor];
        [self.contentView addSubview:_priceStr];
        
        
        _normStr = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_priceStr) - 55, 45, 150, 20)];
        _normStr.font = SYSTEMFONT(14);
        _normStr.textColor = kBlackColor;
        [self.contentView addSubview:_normStr];
        
        [self.contentView addSubview:self.imageView1];
        
        [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.contentView).mas_offset(25);
            make.left.mas_equalTo(self.contentView).mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            //        make.centerX.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}
-(void)setModel:(productModel *)model
{
    if (model.isSelect) {
        self.imageView1.hidden=NO;
        [self.imageView1 setImage:[UIImage imageNamed:@"circular"]];

    }
    else{
        self.imageView1.hidden=YES;
//        [self.imageView1 setImage:[UIImage imageNamed:@"circle"]];

    }
}

-(UIImageView *)imageView1{
    
    if (!_imageView1) {
        
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
//        _imageView.layer.cornerRadius = 20;
//        _imageView.layer.masksToBounds = YES;
        
    }
    return _imageView1;
}
@end
