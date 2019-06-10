//
//  CommentModel.h
//  CFOnlineShop
//
//  Created by app on 2019/6/3.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "FSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : FSBaseModel
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * start;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * time;

@end

NS_ASSUME_NONNULL_END
