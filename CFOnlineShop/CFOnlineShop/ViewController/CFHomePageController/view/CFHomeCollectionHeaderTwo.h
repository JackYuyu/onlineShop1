//
//  CFHomeCollectionHeaderTwo.h
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/23.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYRollingNoticeView.h"

@class CFHomeCollectionHeaderTwo;
@protocol FSHomeBannerHeaderDelegate <NSObject>
@optional
- (void)header:(CFHomeCollectionHeaderTwo *)header DidSelectAtSubClass:(NSInteger *)subClass;

@end
@interface CFHomeCollectionHeaderTwo : UICollectionReusableView
{
    NSArray *_arr1;
    @public
    GYRollingNoticeView *_noticeView1;
    UIView* _uv;
}
@property (nonatomic, weak) id<FSHomeBannerHeaderDelegate> delegate;

@end
