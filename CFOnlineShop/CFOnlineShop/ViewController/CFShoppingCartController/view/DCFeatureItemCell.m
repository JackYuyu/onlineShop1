//
//  DCFeatureItemCell.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCFeatureItemCell.h"

// Controllers

// Models
//#import "DCFeatureItem.h"
#import "DCFeatureList.h"
// Views

// Vendors

// Categories

// Others

@interface DCFeatureItemCell ()

/* 属性 */
@property (strong , nonatomic)UILabel *attLabel;

@end

@implementation DCFeatureItemCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _attLabel = [[UILabel alloc] init];
    _attLabel.textAlignment = NSTextAlignmentCenter;
    _attLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_attLabel];
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _attLabel.frame=CGRectMake(0, 0, 60, 30);
//    [_attLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self);
//    }];
}


#pragma mark - Setter Getter Methods

- (void)setContent:(DCFeatureList *)content
{
    _content = content;
    NSString* a=content.infoname;
    _attLabel.text = content.infoname;
    
    if (content.isSelect) {
        _attLabel.textColor = [UIColor redColor];
        [_attLabel setBackgroundColor:[UIColor redColor]];
        [_attLabel setTextColor:kWhiteColor];
//        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    }else{
        _attLabel.textColor = [UIColor blackColor];
        [_attLabel setBackgroundColor:[UIColor clearColor]];
        [_attLabel setTextColor:KDarkTextColor];
//        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.4] canMasksToBounds:YES];
    }
}

@end
