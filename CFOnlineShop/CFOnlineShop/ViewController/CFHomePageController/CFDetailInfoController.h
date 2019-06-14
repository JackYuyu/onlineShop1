//
//  CFDetailInfoController.h
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/19.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFBaseController.h"
#import "DCFeatureItem.h"
#import "CFSegmentedControl.h"
#import "CFActivityController.h"
#import "CFOthersController.h"
#import "MoreCommentController.h"
@interface CFDetailInfoController : CFBaseController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) NSString *productId;
@property (strong , nonatomic)NSMutableArray <DCFeatureItem *> *featureAttr;
@property (nonatomic, strong) CFSegmentedControl *segmentedControl;
@property (nonatomic,strong) CFActivityController *activityController;
@property (nonatomic,strong) MoreCommentController *othersController;
@end
