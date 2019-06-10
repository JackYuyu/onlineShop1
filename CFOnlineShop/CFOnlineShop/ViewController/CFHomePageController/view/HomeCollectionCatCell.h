//
//  HomeCollectionCatCell.h
//  CFOnlineShop
//
//  Created by app on 2019/5/23.
//  Copyright © 2019年 俞渊华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCollectionCatCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleStr;

@property (nonatomic, strong) void (^addToShoppingCar)(UIImageView *imageView);
@end

NS_ASSUME_NONNULL_END
