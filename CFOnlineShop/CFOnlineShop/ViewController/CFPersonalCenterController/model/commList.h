//
//  commList.h
//  CFOnlineShop
//
//  Created by app on 2019/6/6.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface commList : NSObject
@property (nonatomic, copy) NSArray * goodsId;
@property (nonatomic, copy) NSArray * content;
@property (nonatomic, copy) NSString * star;
@property (nonatomic, copy) NSString * status;
@end

NS_ASSUME_NONNULL_END
