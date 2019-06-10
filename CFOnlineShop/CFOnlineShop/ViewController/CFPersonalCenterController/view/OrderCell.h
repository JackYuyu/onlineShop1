//
//  OrderCell.h
//  CFOnlineShop
//
//  Created by app on 2019/6/4.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *orderno;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UILabel *status;

@property (nonatomic, strong) IBOutlet UILabel *payprice;
@property (nonatomic, strong) IBOutlet UIButton *cancel;
@property (nonatomic, strong) IBOutlet UIButton *paybtn;

@end

NS_ASSUME_NONNULL_END
