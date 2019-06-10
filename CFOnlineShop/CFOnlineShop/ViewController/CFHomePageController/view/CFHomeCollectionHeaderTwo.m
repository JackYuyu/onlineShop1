//
//  CFHomeCollectionHeaderTwo.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/23.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFHomeCollectionHeaderTwo.h"
#import "CFHomeHeaderTwoCell.h"
#import "UIView+Extension.h"
#import "FSBaseModel.h"
#import "UIImageView+WebCache.h"

#define kItemHeight 80

@interface FSItemButton : UIButton
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *coloe;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *logoView;
@end

@implementation  FSItemButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.logoView = [[UIImageView alloc] init];
        [self addSubview:self.logoView];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 10;
    
    CGFloat h1 = self.width * 0.4;
    CGFloat w1 = h1;
    CGFloat x1 = (self.width - w1) / 2;
    self.logoView.frame = CGRectMake(x1, space, w1, h1);
    
    CGFloat h2 = 20;
    CGFloat y2 = self.logoView.maxY + 5;
    self.textLabel.frame = CGRectMake(0, y2, self.width, h2);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.textLabel.text = title;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
    if ([url containsString:@"http"]) {
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:url]];
    }else {
        self.logoView.image = [UIImage imageNamed:url];
    }
}


@end
@interface CFHomeCollectionHeaderTwo ()<GYRollingNoticeViewDataSource, GYRollingNoticeViewDelegate>
{

}
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSArray <FSBaseModel *> *customImages;
@property (nonatomic, strong) NSMutableArray* buttons;
@end

@implementation CFHomeCollectionHeaderTwo

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        GYRollingNoticeView *noticeView = [[GYRollingNoticeView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 80)];
//        noticeView.dataSource = self;
//        noticeView.delegate = self;
//        [self addSubview:noticeView];
        
//        noticeView.backgroundColor = [UIColor lightGrayColor];
//        
//        _arr1 = @[@"",
//                  @"",
//                  @"",
//                  @"",
//                  @""
//                  ];
//        
//        _noticeView1 = noticeView;
//        [noticeView registerClass:[GYNoticeViewCell class] forCellReuseIdentifier:@"GYNoticeViewCell"];
//        [noticeView registerClass:[CFHomeHeaderTwoCell class] forCellReuseIdentifier:@"CFHomeHeaderTwoCell"];
//    
//        [noticeView reloadDataAndStartRoll];
        
        CGFloat height = self.contentView.height;
        CGFloat width = Main_Screen_Width / 4;
        _uv=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 80)];
        UITapGestureRecognizer* rec=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCellTapAction:)];
        [_uv addGestureRecognizer:rec];
        self.buttons=[[NSMutableArray alloc] init];
            [self.customImages enumerateObjectsUsingBlock:^(FSBaseModel * _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
                FSBaseModel *mode = self.customImages[idx];
                FSItemButton *button = [FSItemButton new];
                button.url = mode.image;
                button.title = mode.title;
                button.frame = CGRectMake(width * idx, 0, width, height);
                [_uv addSubview:button];
                button.tag = idx;
                [self.buttons addObject: button];
                [button addTarget:self action:@selector(subClassDidEvent:) forControlEvents:UIControlEventTouchUpInside];
            }];
        [self addSubview:_uv];

    }
    return self;
}
- (void)handleCellTapAction:(UITapGestureRecognizer *)selfTap{
    
    
    
    CGPoint selectPoint = [selfTap locationInView:self];
    
    NSLog(@"%@",[NSValue valueWithCGPoint:selectPoint]);
    
    //CGRectContainsPoint(CGRect rect, <#CGPoint point#>)判断某个点是否包含在某个CGRect区域内
    CGFloat height = kItemHeight;
    CGFloat width = Main_Screen_Width / 4;
    for (UIButton* b in self.buttons) {
        CGRect a=CGRectMake(b.origin.x, 0, width, height);
        
        if (CGRectContainsPoint(a, selectPoint)) {
            NSLog(@"%i",b.tag);
            if (self.delegate && [self.delegate respondsToSelector:@selector(header:DidSelectAtSubClass:)]) {
                        [self.delegate header:self DidSelectAtSubClass:b.tag];
                    }
        }
    }
}
- (UIView *)contentView {
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (NSArray<FSBaseModel *> *)customImages {
    
    if (!_customImages) {
        
        _customImages = @[[FSBaseModel initImage:@"icon_nav_01_new" title:@"签到有礼"],
                          [FSBaseModel initImage:@"icon_nav_03_new" title:@"特价专区"],
                          [FSBaseModel initImage:@"icon_nav_04_new" title:@"超级品牌"],
                          [FSBaseModel initImage:@"icon_nav_01" title:@"中秋特惠"]];
    }
    return _customImages;
}
#pragma mark - Action

- (void)subClassDidEvent:(UIButton *)button {
    NSLog(@"");
//    FSHomeSubClass *sub = self.items[button.tag];
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(header:DidSelectAtSubClass:)]) {
//        [self.delegate header:self DidSelectAtSubClass:sub];
//    }
}
- (NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView
{
    return _arr1.count;
    
}

- (__kindof GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index
{
    // 普通用法，只有一行label滚动显示文字
    // normal use, only one line label rolling
    if (rollingView == _noticeView1) {
        if (index < 3) {
            GYNoticeViewCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"GYNoticeViewCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", _arr1[index]];
            cell.contentView.backgroundColor = kWhiteColor;
            
            return cell;
        }else {
            
            CFHomeHeaderTwoCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"CFHomeHeaderTwoCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", _arr1[index]];
            cell.contentView.backgroundColor = kWhiteColor;
            return cell;
        }
    }
    
    return nil;
}

- (void)didClickRollingNoticeView:(GYRollingNoticeView *)rollingView forIndex:(NSUInteger)index
{
    NSLog(@"点击的index: %ld",(long)index);
}

@end
