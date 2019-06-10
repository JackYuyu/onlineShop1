//
//  HomeSpecialController.m
//  CFOnlineShop
//
//  Created by app on 2019/5/30.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "HomeSpecialController.h"
#import "CFHomeCollectionCell.h"
#import "PurchaseCarAnimationTool.h"
#import "CFTabBarController.h"
#import "CFHomeCollectionHeader.h"
#import "CFHomeCollectionHeaderTwo.h"
#import "CFRefreshHeader.h"
#import "CFDetailInfoController.h"
#import "HomeCollectionCatCell.h"
#import "CollectionCatHeader.h"
#import "CFSegmentedControl.h"
#import "productModel.h"
@interface HomeSpecialController ()<UICollectionViewDelegate,UICollectionViewDataSource,CFSegmentedControlDataSource,CFSegmentedControlDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, assign) CGFloat headerOffsetY;
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) CFSegmentedControl *segmentedControl;
@property (nonatomic,strong) NSMutableArray* productList;
@end

@implementation HomeSpecialController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _segmentTitles = @[@"综合",@"销量",@"价格",@"筛选"];
    _productList=[NSMutableArray new];
    
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 0;
    [self showLeftBackButton];
    
    [self setUI];
    [self postUI];
}
- (void)setSegmentedControl
{
    //注意宽度要留够，不然title显示不完，title宽度是计算出来的。代码并不复杂，可以根据需要去内部进行修改
    _segmentedControl = [[CFSegmentedControl alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - (60 * [_segmentTitles count])/2, TopHeight - 40, 60 * [_segmentTitles count], 40)];
    _segmentedControl.delegate = self;
    _segmentedControl.dataSource = self;
    _segmentedControl.alpha = 1;
    [self.navigationView addSubview:_segmentedControl];
}
#pragma mark -- SegmentedControlDelegate & datasource

- (NSArray *)getSegmentedControlTitles
{
    return _segmentTitles;
}

- (void)control:(CFSegmentedControl *)control didSelectAtIndex:(NSInteger)index
{
    NSLog(@"");
    //    [_bgScrollView setContentOffset:CGPointMake(Main_Screen_Width * index, 0) animated:YES];
}

-(void)postUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"categoryId" : _categoryId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsinfo/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            productModel* p=[productModel mj_objectWithKeyValues:products];
            p.productName=[products objectForKey:@"description"];
            p.productId=[products objectForKey:@"id"];
            NSLog(@"");
            [_productList addObject:p];
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
- (void)setUI
{
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(20, StatusBarHeight + 5, Main_Screen_Width - 40, 30);
    _searchBtn.backgroundColor = kWhiteColor;
    [_searchBtn setTitle:@"搜索你想要的商品名称" forState:UIControlStateNormal];
    _searchBtn.titleLabel.font = SYSTEMFONT(16);
    [_searchBtn setTitleColor:KGrayTextColor forState:UIControlStateNormal];
    _searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20 , 0, -20);
    _searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30 , 0, -30);
    _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[searchBtn addTarget:self action:@selector(homePageSearchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.navigationView addSubview:_searchBtn];
    
    ViewRadius(_searchBtn, 15);
    
    _searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 21)];
    _searchImageView.image = [UIImage imageNamed:@"home_search"];
    [_searchBtn addSubview:_searchImageView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.emptyDataSetSource=self;
    _collectionView.emptyDataSetDelegate=self;
    _collectionView.backgroundColor = kClearColor;
    [_collectionView registerClass:[HomeCollectionCatCell class] forCellWithReuseIdentifier:@"CollectionCatCell"];
    [_collectionView registerClass:[CollectionCatHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[CFHomeCollectionHeaderTwo class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2"];
    [self.view addSubview:_collectionView];
    
    //去掉顶部偏移
    if (@available(iOS 11.0, *))
    {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    WeakSelf(self);
    _collectionView.mj_header = [CFRefreshHeader headerWithRefreshingBlock:^{
        
        //        if (weakself.headerOffsetY < pass150Offset) {
        //
        //            [weakself.collectionView.mj_header endRefreshing];
        //
        //            UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"谢谢惠顾" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        //            }];
        //            [actionSheetController addAction:confirm];
        //            [weakself presentViewController:actionSheetController animated:YES completion:nil];
        //        }
        //        else
        //        {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.collectionView.mj_header endRefreshing];
        });
        //        }
    }];
    
}
#pragma mark - <DZNEmptyDataSetSource>

//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    NSString *buttonTitle = @"去逛逛";
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:17],
//                                 NSForegroundColorAttributeName: [UIColor blackColor]
//                                 };
//    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
//}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty"];
}
#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // Do something
    //    [self refreshingAgain];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    
    return Main_Screen_Width * 0.75;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return [_productList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectionCell = @"CollectionCatCell";
    HomeCollectionCatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    productModel* p=[_productList objectAtIndex:indexPath.row];
    cell.titleStr.text = p.productName;
    
    NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
    
    [cell.imageView sd_setImageWithURL:p.logo];
    
    /// 点击事件
    cell.addToShoppingCar = ^(UIImageView *imageView){
        
        UICollectionViewCell * wCell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        CGRect rect = wCell.frame;
        
        /// 获取当前cell 相对于self.view 当前的坐标
        rect.origin.y          = rect.origin.y - collectionView.contentOffset.y;
        
        CGRect imageViewRect   = imageView.frame;
        imageViewRect.origin.x = rect.origin.x;
        imageViewRect.origin.y = rect.origin.y + imageViewRect.origin.y;
        
        [[PurchaseCarAnimationTool shareTool] startAnimationandView:imageView
                                                               rect:imageViewRect
                                                        finisnPoint:CGPointMake(ScreenWidth / 4 * 2.5, ScreenHeight - 49)
                                                        finishBlock:^(BOOL finish) {
                                                            
                                                            if ([self.tabBarController isKindOfClass:[CFTabBarController class]]) {
                                                                
                                                                CFTabBarController *tabBar = (CFTabBarController *)self.tabBarController;
                                                                
                                                                UIButton *tabbarBtn = tabBar.tabBarItemView.subviews[3];
                                                                
                                                                [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
                                                            }
                                                            
                                                        }];
    };
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0){
        
        CollectionCatHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableview = headerView;
        topicModel* t=[topicModel new];
        t.ad=_adList;
        headerView.model=t;
        //        reusableview.backgroundColor = kRedColor;
    }
    else if (kind == UICollectionElementKindSectionHeader && indexPath.section == 1){
        
        CFHomeCollectionHeaderTwo *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2" forIndexPath:indexPath];
        headerView->_noticeView1.hidden=YES;
        headerView->_uv.hidden=YES;
        
        _segmentedControl = [[CFSegmentedControl alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - (60 * [_segmentTitles count])/2, -5, 60 * [_segmentTitles count], 40)];
        _segmentedControl.delegate = self;
        _segmentedControl.dataSource = self;
        _segmentedControl.alpha = 1;
        _segmentedControl.bottomLine.hidden=YES;//分类二级不显示下划线
        [headerView addSubview:_segmentedControl];
        reusableview = headerView;
    }
    
    return reusableview;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    }
    
    return CGSizeZero;
}

#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemCount = 2;
    return CGSizeMake((Main_Screen_Width - 25)/itemCount, (Main_Screen_Width - 25)/itemCount+80);
}

//距离collectionview的上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,10,0,10);
}

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndexPath = indexPath;
    
    NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
    
    CFDetailInfoController *vc = [[CFDetailInfoController alloc] init];
    productModel* p=[_productList objectAtIndex:indexPath.row];
    vc.productId=p.productId;
    UIImageView* iv=[UIImageView new];
    [iv sd_setImageWithURL:[NSURL URLWithString:p.logo]];
    vc.image = iv.image;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark --UIScllowViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%lf",scrollView.mj_offsetY);
    
    if (scrollView.mj_offsetY < 0) {
        _headerOffsetY = scrollView.mj_offsetY;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%lf",scrollView.mj_offsetY);
    
    if (scrollView.mj_offsetY < 0)
    {
        if (self.navigationView.alpha == 1) {
            [UIView animateWithDuration:0.1 animations:^{
                self.navigationView.alpha = 0;
            }];
        }
    }
    else
    {
        if (self.navigationView.alpha == 0) {
            [UIView animateWithDuration:0.1 animations:^{
                self.navigationView.alpha = 1;
            }];
        }
        
        if (scrollView.mj_offsetY > 0 && scrollView.mj_offsetY < 40) {
            
            self.navigationBgView.alpha = 1 * (scrollView.mj_offsetY / 40.f);
            //由于只有白色导航背景是渐变，所以做个判断，以免一直执行
            if (self.searchBtn.currentTitleColor != KGrayTextColor) {
                self.navigationBgView.backgroundColor = kWhiteColor;
                _searchImageView.image = [UIImage imageNamed:@"home_search"];
                self.searchBtn.backgroundColor = kWhiteColor;
                [self.searchBtn setTitleColor:KGrayTextColor forState:UIControlStateNormal];
            }
        }
        else if (scrollView.mj_offsetY <= 0)
        {
            self.navigationBgView.alpha = 0;
        }
        else if (scrollView.mj_offsetY > 40)
        {
            if (self.navigationBgView.alpha != 1) {
                self.navigationBgView.alpha = 1;
                self.searchBtn.backgroundColor = KLineGrayColor;
                [self.searchBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                _searchImageView.image = [UIImage imageNamed:@"home_search_white"];
            }
        }
    }
}

@end
