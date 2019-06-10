//
//  CFHomePageController.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/18.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFHomePageController.h"
#import "CFHomeCollectionCell.h"
#import "PurchaseCarAnimationTool.h"
#import "CFTabBarController.h"
#import "CFHomeCollectionHeader.h"
#import "CFHomeCollectionHeaderTwo.h"
#import "CFRefreshHeader.h"
#import "CFDetailInfoController.h"
#import "CategoryInfoController.h"
#import "HomeCheckController.h"
#import "CFHomeCollectionHeaderthree.h"
#import "HomeCollectionCatCell.h"
#import "productModel.h"
#import "topicModel.h"
#import "HomeSpecialController.h"
#import "SeachViewController.h"
@interface CFHomePageController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, assign) CGFloat headerOffsetY;
@property (nonatomic, strong) NSMutableArray* recommendList;
@property (nonatomic, strong) NSMutableArray* topicList;
@property (nonatomic, strong) NSMutableArray* adList;

@end

@implementation CFHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _recommendList=[[NSMutableArray alloc] init];
    _adList=[[NSMutableArray alloc] init];

    [self setUI];
    [self postTopicUI];
    [self postUI];
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
    [_searchBtn addTarget:self action:@selector(homePageSearchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:_searchBtn];
    
    ViewRadius(_searchBtn, 15);
    
    _searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 21)];
    _searchImageView.image = [UIImage imageNamed:@"home_search"];
    [_searchBtn addSubview:_searchImageView];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - TabbarHeight) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kClearColor;
    [_collectionView registerClass:[CFHomeCollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    [_collectionView registerClass:[HomeCollectionCatCell class] forCellWithReuseIdentifier:@"CollectionCatCell"];

    [_collectionView registerClass:[CFHomeCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[CFHomeCollectionHeaderTwo class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2"];
    [_collectionView registerClass:[CFHomeCollectionHeaderthree class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [self.view addSubview:_collectionView];
    
    //去掉顶部偏移
    if (@available(iOS 11.0, *))
    {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    WeakSelf(self);
    _collectionView.mj_header = [CFRefreshHeader headerWithRefreshingBlock:^{
        
        if (weakself.headerOffsetY < pass150Offset) {
            
            [weakself.collectionView.mj_header endRefreshing];
            
            UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"谢谢惠顾" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
            }];
            [actionSheetController addAction:confirm];
            [weakself presentViewController:actionSheetController animated:YES completion:nil];
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.collectionView.mj_header endRefreshing];
            });
        }
    }];
    
}
-(void)homePageSearchButtonClick
{
    SeachViewController* search=[SeachViewController new];
    search.categoryId=@"上衣";
    [self.navigationController pushViewController:search animated:YES];
}
-(void)postTopicUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodstopic/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        _topicList=[[NSMutableArray alloc] init];

        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            topicModel* t=[topicModel mj_objectWithKeyValues:products];
            NSLog(@"");
            [_topicList addObject:t];
            [_adList addObject:t.img];
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
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
             [_recommendList addObject:p];
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
#pragma mark - <FSHomeBannerHeaderDelegate>

- (void)header:(CFHomeCollectionHeaderTwo *)header DidSelectAtSubClass:(NSInteger *)subClass {
    if (subClass==0) {
        HomeCheckController* hcc=[HomeCheckController new];
        [self.navigationController pushViewController:hcc animated:YES];
    }
    else if(subClass==1)
    {
        HomeSpecialController* hs=[HomeSpecialController new];
        hs.categoryId=@"0";
        [self.navigationController pushViewController:hs animated:YES];
    }
    else if(subClass==2)
    {
        HomeSpecialController* hs=[HomeSpecialController new];
        hs.categoryId=@"1";
        [self.navigationController pushViewController:hs animated:YES];
    }
    else if(subClass==3)
    {
        HomeSpecialController* hs=[HomeSpecialController new];
        hs.categoryId=@"2";
        [self.navigationController pushViewController:hs animated:YES];
    }
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    if (section==1) {
        return [_topicList count];
    }
    else
    {
        return [_recommendList count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1||indexPath.section==0) {

    static NSString *collectionCell = @"CollectionCell";
    CFHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    cell.titleStr.text = @"测试商品";
    topicModel* p=[_topicList objectAtIndex:indexPath.row];

    NSString *imageName = [NSString stringWithFormat:@"catcommodity_%ld",(long)indexPath.row + 1];
    
//    cell.imageView.image = [UIImage imageNamed:imageName];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:p.img]];

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
    else
    {
        static NSString *collectionCell = @"CollectionCatCell";
        HomeCollectionCatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
        productModel* p=[_recommendList objectAtIndex:indexPath.row];
        cell.titleStr.text = p.productName;
        
        NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:p.logo]];

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
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0){
        
        CFHomeCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableview = headerView;
        reusableview.backgroundColor = kRedColor;
        topicModel* t=[topicModel new];
        t.ad=_adList;
        [headerView setModel:t];
    }
    else if (kind == UICollectionElementKindSectionHeader && indexPath.section == 1){
        
        CFHomeCollectionHeaderTwo *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header2" forIndexPath:indexPath];
        headerView.delegate=self;
        reusableview = headerView;
    }
    else
    {
        CFHomeCollectionHeaderthree *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];

        reusableview=head;
    }

    return reusableview;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
       return CGSizeMake(Main_Screen_Width, Main_Screen_Width/16*7);
    }
    if (section==2) {
        return CGSizeMake(Main_Screen_Width, 60);
    }
    return CGSizeMake(Main_Screen_Width, 80);
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
    if (indexPath.section==2) {
        return CGSizeMake((Main_Screen_Width - 25)/2, (Main_Screen_Width - 25)/2+80);
    }
    NSInteger itemCount = 2;
    return CGSizeMake((Main_Screen_Width - 25)/1, 210);
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
    
    if (indexPath.section==2) {
            CFDetailInfoController *vc = [[CFDetailInfoController alloc] init];
        productModel* p=[_recommendList objectAtIndex:indexPath.row];
        vc.productId=p.productId;
        UIImageView* iv=[UIImageView new];
        [iv sd_setImageWithURL:[NSURL URLWithString:p.logo]];
        vc.image = iv.image;
//            vc.image = [UIImage imageNamed:imageName];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    CFDetailInfoController *vc = [[CFDetailInfoController alloc] init];
//    vc.image = [UIImage imageNamed:imageName];
    else
    {
        topicModel* t=[_topicList objectAtIndex:indexPath.row];
    CategoryInfoController* vc =[CategoryInfoController new];
        vc.brandId=t.brandId;
        NSMutableArray* addetail=[NSMutableArray new];
        [addetail addObject:[_adList objectAtIndex:indexPath.row]];
        vc.adList=addetail;
    [self.navigationController pushViewController:vc animated:YES];
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
