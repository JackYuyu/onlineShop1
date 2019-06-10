//
//  CFHomePageController.h
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/18.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFBaseController.h"

@interface CFHomePageController : CFBaseController

@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  记录当前点击的indexPath
 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end
