//
//  CFDetailViewController.h
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/8/6.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFBaseController.h"
#import "DCFeatureItem.h"
#import "CFDetailInfoController.h"
@interface CFDetailViewController : CFBaseController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) CFDetailInfoController* basecontroller;

@property (nonatomic, strong) void (^addActionWithBlock)(NSInteger tag);
@property (nonatomic, strong) void (^featureBlock)(DCFeatureItem* features);

@property (nonatomic, strong) void (^scrollViewDidScroll)(UIScrollView *scrollView);

@end
