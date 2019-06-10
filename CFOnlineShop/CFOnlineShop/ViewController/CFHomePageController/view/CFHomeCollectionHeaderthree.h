//
//  CFHomeCollectionHeaderthree.h
//  CFOnlineShop
//
//  Created by app on 2019/5/27.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYRollingNoticeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFHomeCollectionHeaderthree : UICollectionReusableView
{
    NSArray *_arr1;
@public
    GYRollingNoticeView *_noticeView1;
    UIView* _uv;
}
@end

NS_ASSUME_NONNULL_END
