//
//  ProductInfoCell.h
//  CFOnlineShop
//
//  Created by app on 2019/5/31.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;

@end

NS_ASSUME_NONNULL_END
