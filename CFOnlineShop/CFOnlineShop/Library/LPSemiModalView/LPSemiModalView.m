//
//  LPSemiModalView.m
//
//  Created by litt1e-p on 16/3/10.
//  Copyright © 2016年 itt1e-p. All rights reserved.
//

#import "LPSemiModalView.h"
#import <QuartzCore/QuartzCore.h>
#import "PPNumberButton.h"
#import "DCFeatureChoseTopCell.h"
#import "FSSettlementViewController.h"
#import "FSShopCartList.h"

#import "DCFeatureHeaderView.h"
#import "DCCollectionHeaderLayout.h"
#import "DCFeatureItemCell.h"
@interface LPSemiModalView ()<PPNumberButtonDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HorizontalCollectionLayoutDelegate>

@property (strong, nonatomic) UIControl *closeControl;
@property (strong, nonatomic) UIImageView *maskImageView;
@property (nonatomic, strong) UIViewController *baseViewController;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
@property (strong , nonatomic)UICollectionView *collectionView;

@property (weak , nonatomic)DCFeatureChoseTopCell *cell;
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,assign) BOOL norm;

@property (nonatomic,strong) UILabel* stockLabel;
@end

static NSInteger num_;
static NSString *const DCFeatureChoseTopCellID = @"DCFeatureChoseTopCell";
static NSString *const DCFeatureHeaderViewID = @"DCFeatureHeaderView";
static NSString *const DCFeatureItemCellID = @"DCFeatureItemCell";
@implementation LPSemiModalView

+ (UIImage *)snapshotWithWindow
{
    @autoreleasepool
    {
        UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, YES, 2);
        [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView registerClass:[DCFeatureChoseTopCell class] forCellReuseIdentifier:DCFeatureChoseTopCellID];
    }
    return _tableView;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        DCCollectionHeaderLayout *layout = [DCCollectionHeaderLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //自定义layout初始化
        layout.delegate = self;
        layout.lineSpacing = 8.0;
        layout.interitemSpacing = 10;
        layout.headerViewHeight = 35;
        layout.footerViewHeight = 5;
        layout.itemInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[DCFeatureItemCell class] forCellWithReuseIdentifier:DCFeatureItemCellID];//cell
        [_collectionView registerClass:[DCFeatureHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID]; //头部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //尾部
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCFeatureChoseTopCell *cell = [tableView dequeueReusableCellWithIdentifier:DCFeatureChoseTopCellID forIndexPath:indexPath];
    _cell = cell;
//    if (_seleArray.count != _featureAttr.count && _lastSeleArray.count != _featureAttr.count) {
        cell.chooseAttLabel.textColor = [UIColor redColor];
        cell.chooseAttLabel.text = [NSString stringWithFormat:@"¥ %@",_cartItem.productPrice];
//    }else {
//        cell.chooseAttLabel.textColor = [UIColor darkGrayColor];
//        NSString *attString = (_seleArray.count == _featureAttr.count) ? [_seleArray componentsJoinedByString:@"，"] : [_lastSeleArray componentsJoinedByString:@"，"];
//        cell.chooseAttLabel.text = [NSString stringWithFormat:@"已选属性：%@",attString];
//    }
    
    cell.goodPriceLabel.text = _cartItem.name;
    [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:_cartItem.logo]];
//    [cell.goodImageView setImage:[UIImage imageNamed:@"commodity_7"]];
    __weak typeof(self) weakSelf = self;
    cell.crossButtonClickBlock = ^{
        [weakSelf dismissFeatureViewControllerWithTag:100];
    };
    return cell;
}
#pragma mark - 退出当前界面
- (void)dismissFeatureViewControllerWithTag:(NSInteger)tag
{
    [self close:tag];
}
-(void)setup{
//    self.backgroundColor=[UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, Main_Screen_Height-360, Main_Screen_Width, 360);
    self.tableView.rowHeight = 100;
    
    self.collectionView.frame = CGRectMake(0, Main_Screen_Height-360+100 ,Main_Screen_Width , 150);
    //collectionview的背景色在lazy中设置不能成功
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
}
- (void)pp_numberButton:(__kindof UIView *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
{
    FSShopCartList *newCart = _cartItem;
    newCart.num=[NSString stringWithFormat:@"%i",number];

}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger a=[_featureAttr count];
    return _featureAttr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _featureAttr[section].list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DCFeatureItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCFeatureItemCellID forIndexPath:indexPath];
    cell.content = _featureAttr[indexPath.section].list[indexPath.row];
//    cell.backgroundColor=[UIColor redColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {
        DCFeatureHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID forIndexPath:indexPath];
        headerView.headTitle = _featureAttr[indexPath.section].attr;
        return headerView;
    }else {
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        return footerView;
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.norm=YES;
    for (DCFeatureItem* l in _featureAttr) {
        for (DCFeatureList* d in l.list ) {
            d.isSelect=NO;
        }
    }
    DCFeatureItem* item=[_featureAttr objectAtIndex:0];
    DCFeatureList* l;
    for (int i=0; i<[item.list count]; i++) {
        if (i==indexPath.row) {
            l=[item.list objectAtIndex:indexPath.row];
            l.isSelect=YES;
            _cartItem.goodsSkuId=l.goodsSkuId;
            _cartItem.goodNorm=l.infoname;
            _stockLabel.text=[NSString stringWithFormat:@"库存:%@件",l.stockNum];
        }
        
    }
//    [item.list replaceObjectAtIndex:indexPath.row withObject:l];
//    for (DCFeatureList* l in _featureAttr[indexPath.section].list) {
//        l.isSelect=YES;
//    }
    
    //刷新tableView和collectionView
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.tableView reloadData];
        
    });

}


#pragma mark - <HorizontalCollectionLayoutDelegate>
#pragma mark - 自定义layout必须实现的方法
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    return _featureAttr[indexPath.section].list[indexPath.row].goodsSkuVals;
}

#pragma mark - 底部按钮
- (void)setUpBottonView
{
    NSArray *titles = @[@"确定"];
    CGFloat buttonH = 50;
    CGFloat buttonW = Main_Screen_Width / titles.count;
    CGFloat buttonY = Main_Screen_Height - buttonH;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttton setTitle:titles[i] forState:0];
        buttton.backgroundColor = (i == 0) ? [UIColor redColor] : [UIColor orangeColor];
        CGFloat buttonX = buttonW * i;
        buttton.tag = i;
        buttton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self addSubview:buttton];
        [buttton addTarget:self action:@selector(buttomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *numLabel = [UILabel new];
    numLabel.text = @"数量";
    numLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:numLabel];
    numLabel.frame = CGRectMake(10, Main_Screen_Height-100, 50, 35);
    
    UILabel *stockLabel = [UILabel new];
    stockLabel.text = @"库存:0件";
    stockLabel.font = [UIFont systemFontOfSize:14];
    _stockLabel=stockLabel;
    [self addSubview:stockLabel];
    stockLabel.frame = CGRectMake(CGRectGetMaxX(numLabel.frame)+10, Main_Screen_Height-100, 150, 35);
    
    PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(CGRectGetMaxX(stockLabel.frame), numLabel.frame.origin.y, 110, numLabel.frame.size.height)];
    numberButton.shakeAnimation = YES;
    numberButton.minValue = 1;
    numberButton.inputFieldFont = 23;
    numberButton.increaseTitle = @"＋";
    numberButton.decreaseTitle = @"－";
    num_ = (_lastNum == 0) ?  1 : [_lastNum integerValue];
    numberButton.currentNumber = num_;
    numberButton.delegate = self;
    
    numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        num_ = num;
    };
    [self addSubview:numberButton];
    
    UIView* line=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), Main_Screen_Width, 0.5)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line];
}

#pragma mark - 底部按钮点击
- (void)buttomButtonClick:(UIButton *)button
{
//    if (_seleArray.count != _featureAttr.count && _lastSeleArray.count != _featureAttr.count) {//未选择全属性警告
//        [SVProgressHUD showInfoWithStatus:@"请选择全属性"];
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//        [SVProgressHUD dismissWithDelay:1.0];
//        return;
//    }
    if (!self.norm) {
        [MBProgressHUD showMBProgressHud:self.baseViewController.view withText:@"请选择商品属性" withTime:1];
        return;
    }
    [self dismissFeatureViewControllerWithTag:button.tag];
    [self postUI];
}
-(void)postUI
{
    NSDictionary *params = @{
                             @"goodsId" : _cartItem.goodsId,
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"goodsSkuId" : _cartItem.goodsSkuId,
                             @"num": _cartItem.num
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/goodsshoppingcar/save"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
- (void)open:(NSInteger)tag
{
    self.tag=tag;
    if (!self.narrowedOff) {
        //self.contentView.hidden = YES;
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -0.004;
        [self.maskImageView.layer setTransform:t];
        self.maskImageView.layer.zPosition = -10000;
        
        self.maskImageView.image = [self.class snapshotWithWindow];
        if (self.baseViewController) {
            [self.baseViewController.view bringSubviewToFront:self];
        }
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.5f animations:^{
            self.maskImageView.alpha = 0.5;
            self.contentView.frame = CGRectMake(0,
                                                [[UIScreen mainScreen] bounds].size.height - self.contentView.bounds.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        }];
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.layer.transform = CATransform3DRotate(t, 7/90.0 * M_PI_2, 1, 0, 0);
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    [self transNavigationBarToHide:YES];
                }
            }
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
            }];
        }];
    } else {
        self.maskImageView.image = [self.class snapshotWithWindow];
        if (self.baseViewController) {
            [self.baseViewController.view bringSubviewToFront:self];
        }
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 0.25;
            self.contentView.frame = CGRectMake(0,
                                                [[UIScreen mainScreen] bounds].size.height - self.contentView.bounds.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    self.baseViewController.navigationController.navigationBarHidden = YES;
                }
            }
        }];
    }
    _cartItem=[MySingleton sharedMySingleton].cartItem;

    [self setup];
    [self setUpBottonView];
}

- (void)close:(NSInteger)tag
{
    if (self.semiModalViewWillCloseBlock) {
        self.semiModalViewWillCloseBlock();
    }
    if (!self.narrowedOff) {
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -0.004;
        [self.maskImageView.layer setTransform:t];
        self.closeControl.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5f animations:^{
            self.maskImageView.alpha = 1;
            self.contentView.frame = CGRectMake(0,
                                                self.frame.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        } completion:^(BOOL finished) {
            if (self.semiModalViewDidCloseBlock) {
                self.semiModalViewDidCloseBlock();
            }
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    if (self.block) {
                        if (tag==100) {
                            [self.baseViewController.view sendSubviewToBack:self];
                            return;
                        }
                        if (self.tag==0) {
                            [MBProgressHUD showMBProgressHud:self.baseViewController.view withText:@"亲,加入购物车成功" withTime:1];
                        }
                        else{
                        FSSettlementViewController* confirmOrder=[[FSSettlementViewController alloc] initWithNibName:@"FSSettlementViewController" bundle:nil];
//                        FSShopCartList *newCart = [FSShopCartList new];
//                        newCart.num = [NSString stringWithFormat:@"%ld", 1.0];
//                        newCart.img = @"commodity_7";
//                        newCart.name = @"测试商品";
//                        newCart.idField = @"11111";
                        confirmOrder.dataSource = [NSMutableArray arrayWithObjects:_cartItem, nil];
                        [self.baseViewController.navigationController pushViewController:confirmOrder animated:YES];
                        }
                    }
                    else
                    {
                    [self transNavigationBarToHide:NO];
                    }
                }
                [self.baseViewController.view sendSubviewToBack:self];
            }
        }];
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
            self.maskImageView.layer.transform = CATransform3DRotate(t, 7/90.0 * M_PI_2, 1, 0, 0);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, 0, 0);
            }];
        }];
    } else {
        self.closeControl.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 1;
            self.contentView.frame = CGRectMake(0,
                                                self.frame.size.height,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        } completion:^(BOOL finished) {
            if (self.semiModalViewDidCloseBlock) {
                self.semiModalViewDidCloseBlock();
            }
            if (self.baseViewController) {
                [self.baseViewController.view sendSubviewToBack:self];
                if (self.baseViewController.navigationController) {
                    self.baseViewController.navigationController.navigationBarHidden = NO;
                }
            }
        }];
    }
}

- (void)transNavigationBarToHide:(BOOL)hide
{
    if (hide) {
        CGRect frame = self.baseViewController.navigationController.navigationBar.frame;
        [self setNavigationBarOriginY:-frame.size.height animated:NO];
    } else {
        [self setNavigationBarOriginY:[self statusBarHeight] animated:NO];
    }
}

- (void)setNavigationBarOriginY:(CGFloat)y animated:(BOOL)animated
{
    CGFloat statusBarHeight         = [self statusBarHeight];
    UIWindow *appKeyWindow          = [UIApplication sharedApplication].keyWindow;
    UIView *appBaseView             = appKeyWindow.rootViewController.view;
    CGRect viewControllerFrame      = [appBaseView convertRect:appBaseView.bounds toView:appKeyWindow];
    CGFloat overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y;
    CGRect frame                    = self.baseViewController.navigationController.navigationBar.frame;
    frame.origin.y                  = y;
    CGFloat navBarHiddenRatio       = overwrapStatusBarHeight > 0 ? (overwrapStatusBarHeight - frame.origin.y) / overwrapStatusBarHeight : 0;
    CGFloat alpha                   = MAX(1.f - navBarHiddenRatio, 0.000001f);
    [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
        self.baseViewController.navigationController.navigationBar.frame = frame;
        NSUInteger index = 0;
        for (UIView *view in self.baseViewController.navigationController.navigationBar.subviews) {
            index++;
            if (index == 1 || view.hidden || view.alpha <= 0.0f) continue;
            view.alpha = alpha;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            UIColor *tintColor = self.baseViewController.navigationController.navigationBar.tintColor;
            if (tintColor) {
                self.baseViewController.navigationController.navigationBar.tintColor = [tintColor colorWithAlphaComponent:alpha];
            }
        }
    }];
}

- (CGFloat)statusBarHeight
{
    CGSize statuBarFrameSize = [UIApplication sharedApplication].statusBarFrame.size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        return statuBarFrameSize.height;
    }
    return UIInterfaceOrientationIsPortrait(self.baseViewController.interfaceOrientation) ? statuBarFrameSize.height : statuBarFrameSize.width;
}

- (void)contentViewHeight:(float)height
{
    if (height > [UIScreen mainScreen].bounds.size.height) {
        height = [UIScreen mainScreen].bounds.size.height;
    }
    self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, height);
}

- (CGRect)contentViewFrameWithSize:(CGSize)size
{
    if (size.height > [UIScreen mainScreen].bounds.size.height) {
        size.height = [UIScreen mainScreen].bounds.size.height;
    }
    if (size.width > [UIScreen mainScreen].bounds.size.width) {
        size.width = [UIScreen mainScreen].bounds.size.width;
    }
    return CGRectMake(0, self.frame.size.height, self.frame.size.width, size.height);
}

- (id)initWithSize:(CGSize)size andBaseViewController:(UIViewController *)baseViewController
{
    if (self = [super init]) {
        self.frame           = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.maskImageView];
        [self addSubview:self.closeControl];
        [self addSubview:self.contentView];
        self.contentView.frame  = [self contentViewFrameWithSize:size];
        self.baseViewController = baseViewController;
        if (baseViewController) {
            [baseViewController.view insertSubview:self atIndex:0];
            [baseViewController.view sendSubviewToBack:self];
        }
    }
    return self;
}

#pragma mark - lazy loads 📌
- (UIView *)contentView
{
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    self.frame.size.height,
                                                                    self.frame.size.width,
                                                                    self.frame.size.height)];
        contentView.backgroundColor = [UIColor whiteColor];
        self.contentView = contentView;
    }
    return _contentView;
}

- (UIControl *)closeControl
{
    if (!_closeControl) {
        UIControl *closeControl             = [[UIControl alloc] initWithFrame:self.bounds];
        closeControl.userInteractionEnabled = NO;
        closeControl.backgroundColor        = [UIColor clearColor];
        [closeControl addTarget:self action:@selector(close1) forControlEvents:UIControlEventTouchUpInside];
        self.closeControl = closeControl;
    }
    return _closeControl;
}
-(void)close1
{
    [self dismissFeatureViewControllerWithTag:100];
}

- (UIImageView *)maskImageView
{
    if (!_maskImageView) {
        self.maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.frame.size.width,
                                                                           self.frame.size.height)];
    }
    return _maskImageView;
}

@end
