//
//  CommentController.h
//  CFOnlineShop
//
//  Created by app on 2019/6/6.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "CFBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentController : CFBaseController
@property (nonatomic,strong) NSString* orderNo;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END
