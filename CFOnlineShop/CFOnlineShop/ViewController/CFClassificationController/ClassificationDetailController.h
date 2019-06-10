//
//  ClassificationDetailController.h
//  CFOnlineShop
//
//  Created by app on 2019/5/30.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "CFBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassificationDetailController : CFBaseController
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  记录当前点击的indexPath
 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSMutableArray* adList;
@end

NS_ASSUME_NONNULL_END
