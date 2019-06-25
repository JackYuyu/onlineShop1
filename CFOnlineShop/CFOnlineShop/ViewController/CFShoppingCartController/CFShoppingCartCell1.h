//
//  CFShoppingCartCell1.h
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/25.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFEditCollectionCell.h"
#import "productModel.h"
@interface CFShoppingCartCell1 : CFEditCollectionCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleStr;
@property (nonatomic, strong) UILabel *priceStr;
@property (nonatomic, strong) UILabel *normStr;

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic,strong) productModel* model;
@end
