//
//  FSSettlementViewController.h
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/1.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "CFBaseController.h"
#import "OrderEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSSettlementViewController : CFBaseController

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (assign , nonatomic)NSString *lastNum;
@property(nonatomic,strong) OrderEntity* entity;

@end

NS_ASSUME_NONNULL_END
