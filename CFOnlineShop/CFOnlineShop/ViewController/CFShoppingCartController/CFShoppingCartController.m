//
//  CFShoppingCartController.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/18.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFShoppingCartController.h"
#import "CFShoppingCartCell1.h"
#import "CFShoppingCartCell2.h"
#import "CFShoppingCartHeaderView.h"
#import "productModel.h"
#import "FSSettlementViewController.h"
#import "PPNumberButton.h"
#import "delcartModel.h"
#import "commModel.h"
#import "CFDetailInfoController.h"
@interface CFShoppingCartController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,PPNumberButtonDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray* productList;
@property (nonatomic,strong) NSMutableArray* productListM;

@property (nonatomic, assign) CGFloat bottomHeight;
@property (nonatomic,strong) NSString* productId;
@property (nonatomic, strong) NSString* totalPrice;
@property (nonatomic,strong) UIButton* addButton;
@property (nonatomic,strong) UIButton* totalButton;
@property (nonatomic,assign) BOOL totalStatus;
@property (nonatomic, strong) UIImageView *gou;

@property (strong , nonatomic)FSShopCartList *cartItem;

@end
static NSInteger num_;

@implementation CFShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _productListM=[NSMutableArray new];
    _productList=[NSMutableArray new];
    
    [self setTitle:@"购物车"];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    [self setCollectionView];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (![MySingleton sharedMySingleton].openId) {
//        [_productList removeAllObjects];
        return;
    }
    [self postUI];
}
- (void)setCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height - TabbarHeight - TopHeight) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = kClearColor;
    [_collectionView registerClass:[CFShoppingCartCell1 class] forCellWithReuseIdentifier:@"CollectionCell"];
    [_collectionView registerClass:[CFShoppingCartCell2 class] forCellWithReuseIdentifier:@"CollectionCell2"];
    [_collectionView registerClass:[CFShoppingCartHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collectionView.emptyDataSetSource=self;
    _collectionView.emptyDataSetDelegate=self;
    _collectionView.allowsMultipleSelection=YES;
    [self.view addSubview:_collectionView];
    
    //去掉顶部偏移
    if (@available(iOS 11.0, *))
    {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}
-(void)postUI
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsshoppingcar/querylist"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"list"];
//        _productList=[NSMutableArray new];
        bool psel=false;
        for (NSDictionary* products in responseObj[@"list"]) {
            productModel* p=[productModel mj_objectWithKeyValues:products];
            p.productName=[products objectForKey:@"name"];
            p.productId=[products objectForKey:@"id"];
            p.marketPrice=p.expressPrice;//用expressprice
            NSLog(@"");
            for (productModel* model in _productList) {
                if ([model.productId isEqualToString:p.productId]) {
                    psel=true;
                }
            }
            if (!psel) {
                [_productList addObject:p];
            }
            psel=false;
        }
        
        double pro;
        double sum=0.0;
        for (int i=0; i<_productList.count; i++) {
                productModel* p=[_productList objectAtIndex:i];
                pro=[p.marketPrice doubleValue]*p.num;
            sum=sum+pro;
        }
        _totalPrice=[NSString stringWithFormat:@"¥%.2f",sum];
        if ([_productList count]>0) {
            [self setBottomView];
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postDelUI
{
    NSMutableArray* comm=[NSMutableArray new];
    for (productModel* newCart in _productList) {
        if ([newCart.productId isEqualToString:_productId]) {

        delcartModel* c=[delcartModel new];
        c.id=newCart.productId;
        [comm addObject:c];
        }
    }
    commModel* m=[commModel new];
    m.list=[comm copy];
    NSString* a=m.mj_JSONString;
//    NSDictionary *params = @{
//                             @"openId" : [MySingleton sharedMySingleton].openId,
//                             @"id" : _productId
//                             };
    NSData *data =   [a dataUsingEncoding:NSUTF8StringEncoding];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/goodsshoppingcar/deleteShoppingCar"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"");
        
        //        weakself.segmentedControl.tapIndex=2;
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postUpdateUI
{
    NSString* checked=@"0";
    if (_cartItem.isSelect) {
        checked=@"1";
    }
    NSDictionary *params = @{
                             @"id" : _cartItem.goodsId,
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"ischecked" : checked,
                             @"num": _cartItem.num
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool putWithUrl:[NSString stringWithFormat:@"renren-fast/mall/goodsshoppingcar/update"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
- (void)setBottomView
{
    _bottomHeight = 55+TabbarHeight;

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - _bottomHeight, Main_Screen_Width, 55)];
    bottomView.backgroundColor = [UIColor whiteColor];;
    [self.view addSubview:bottomView];
    
    UIImageView* gou=[[UIImageView alloc] init];
    _gou=gou;
    if (_totalStatus) {
        [gou setImage:[UIImage imageNamed:@"circular"]];
    }
    [bottomView addSubview:gou];

    [gou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView).mas_offset(17);
        make.left.mas_equalTo(bottomView).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        //        make.centerX.mas_equalTo(self.contentView);
    }];
    
    UIButton *totalButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    totalButton.frame = CGRectMake(25, 0, bottomView.mj_w/4, 55);
    totalButton.backgroundColor = [UIColor whiteColor];
    totalButton.titleLabel.font = SYSTEMFONT(16);
    [totalButton setTitle:[NSString stringWithFormat:@"全选",_totalPrice] forState:(UIControlStateNormal)];
    [totalButton setTitleColor:kGrayColor forState:(UIControlStateNormal)];
    [totalButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [totalButton addTarget:self action:@selector(totalAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _totalButton=totalButton;
    if (_totalStatus) {
        totalButton.selected=YES;
    }
    [bottomView addSubview:totalButton];
    
    UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addButton.frame = CGRectMake(bottomView.mj_w/2, 0, bottomView.mj_w/4+10, 55);
    addButton.backgroundColor = [UIColor whiteColor];
    addButton.titleLabel.font = SYSTEMFONT(16);
    [addButton setTitle:[NSString stringWithFormat:@"合计:%@",_totalPrice] forState:(UIControlStateNormal)];
    [addButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [addButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    _addButton=addButton;
    [bottomView addSubview:addButton];
    
    UIButton *addimButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addimButton.frame = CGRectMake(bottomView.mj_w*3/4+10, 0, bottomView.mj_w/4-10, 55);
    addimButton.backgroundColor = kRedColor;
    addimButton.titleLabel.font = SYSTEMFONT(16);
    [addimButton setTitle:@"去结算" forState:(UIControlStateNormal)];
    [addimButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [addimButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:addimButton];
    
}
-(void)totalAction:(UIButton*)sender
{
    sender.selected=!sender.selected;
    if (sender.selected) {
        _gou.hidden=NO;
    [_gou setImage:[UIImage imageNamed:@"circular"]];
    for (productModel* p in _productList) {
        p.isSelect=YES;
    }
        _totalStatus=YES;
    }
    else
    {
        _gou.hidden=YES;
        for (productModel* p in _productList) {
            p.isSelect=NO;
        }
        _totalStatus=NO;
    }
    [_collectionView reloadData];
}
-(void)addAction
{
//    if (_productListM.count>0) {
//        _productList=[_productListM copy];
//    }
    FSSettlementViewController* confirmOrder=[[FSSettlementViewController alloc] initWithNibName:@"FSSettlementViewController" bundle:nil];
    NSMutableArray* source=[NSMutableArray new];
    for (productModel* p in _productList) {
        FSShopCartList *newCart = [FSShopCartList new];
        newCart.num = [NSString stringWithFormat:@"%d", p.num];
        newCart.logo = p.logo;
        newCart.name = p.name;
        newCart.productPrice=p.marketPrice;
        newCart.goodNorm=p.goodsNorm;
        newCart.idField = @"11111";
        
        newCart.goodsId=p.goodsId;
        newCart.goodsSkuId=p.goodsSkuId;
        if (p.isSelect) {
            [source addObject:newCart];
        }
    }
    if (source.count==0) {
        for (productModel* p in _productList) {
            FSShopCartList *newCart = [FSShopCartList new];
            newCart.num = [NSString stringWithFormat:@"%d", p.num];
            newCart.logo = p.logo;
            newCart.name = p.name;
            newCart.productPrice=p.marketPrice;
            newCart.goodNorm=p.goodsNorm;
            newCart.idField = @"11111";
            
            newCart.goodsId=p.goodsId;
            newCart.goodsSkuId=p.goodsSkuId;
            [source addObject:newCart];
        }
    }
    
    confirmOrder.dataSource = source;
    confirmOrder.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:confirmOrder animated:YES];
}
- (void)pp_numberButton:(__kindof UIView *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
{
    FSShopCartList *cartItem=[FSShopCartList new];
    _cartItem=cartItem;
    double pro;
    double sum=0.0;
    for (int i=0; i<_productList.count; i++) {
        if (i==numberButton.tag) {
            productModel* p=[_productList objectAtIndex:i];
            p.num=number;
            pro=[p.marketPrice doubleValue]*number;
            //
            _cartItem.goodsId=p.productId;
            _cartItem.num=[NSString stringWithFormat:@"%d",p.num];
            _cartItem.isSelect=NO;
            [self postUpdateUI];
        }
        else
        {
            productModel* p=[_productList objectAtIndex:i];
            pro=[p.marketPrice doubleValue]*p.num;
        }
        sum=sum+pro;
    }
    _totalPrice=[NSString stringWithFormat:@"¥%.2f",sum];
    [_addButton setTitle:[NSString stringWithFormat:@"合计:%@",_totalPrice] forState:UIControlStateNormal];

    NSInteger b=numberButton.tag;
    NSLog(@"");
    
}
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    productModel* p=[_productList objectAtIndex:label.tag];

    CFDetailInfoController *vc = [[CFDetailInfoController alloc] init];
    vc.productId=p.goodsId;
    UIImageView* iv=[UIImageView new];
    [iv sd_setImageWithURL:[NSURL URLWithString:p.logo]];
    vc.image = iv.image;
    //            vc.image = [UIImage imageNamed:imageName];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"%@被点击了",label.text);
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return [_productList count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *collectionCell = @"CollectionCell";
        CFShoppingCartCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
        [cell configCollectionCellType:(CFEditCollectionCellTypeWithDelete)];
        productModel* p=[_productList objectAtIndex:indexPath.row];
        cell.model=p;
        //cell.backgroundColor = kRedColor;
        cell.titleStr.text = p.productName;
        cell.titleStr.userInteractionEnabled=YES;
        cell.titleStr.tag=indexPath.row;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
        
        [cell.titleStr addGestureRecognizer:labelTapGestureRecognizer];
        cell.priceStr.text=[NSString stringWithFormat:@"￥:%@",p.marketPrice];
        cell.normStr.text=p.goodsNorm;
        NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
//        cell.imageView.image = [UIImage imageNamed:imageName];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:p.logo]];
        [cell setDeleteButtonAction:^(UIButton *button) {
            NSInteger a=indexPath.row;
            productModel* p=[_productList objectAtIndex:indexPath.row];
            _productId=p.productId;
            [self postDelUI];

            [_productList removeObjectAtIndex:indexPath.row];
             [_collectionView reloadData];
            NSLog(@"删除操作");
        }];
        
        PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectZero];
        numberButton.shakeAnimation = YES;
        numberButton.minValue = 1;
        numberButton.inputFieldFont = 23;
        numberButton.increaseTitle = @"＋";
        numberButton.decreaseTitle = @"－";
        num_ = p.num;
        numberButton.currentNumber = num_;
        numberButton.delegate = self;
        numberButton.tag=indexPath.row;
        
        numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
            num_ = num;
        };
        [cell.contentView addSubview:numberButton];
        [numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(cell.contentView)setOffset:-10];
            [make.bottom.mas_equalTo(cell.contentView)setOffset:0];
            make.size.mas_equalTo(CGSizeMake(110, 40));
        }];
        return cell;
    }
    else
    {
        static NSString *collectionCell2 = @"CollectionCell2";
        CFShoppingCartCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell2 forIndexPath:indexPath];
        [cell configCollectionCellType:(CFEditCollectionCellTypeWithNone)];
        cell.backgroundColor = kRedColor;
        cell.titleStr.text = @"测试商品";
        
        NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
        
        cell.imageView.image = [UIImage imageNamed:imageName];
        [cell setDeleteButtonAction:^(UIButton *button) {
            NSLog(@"删除操作");
        }];
        
        return cell;
    }
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
    if (indexPath.section == 0) {
        
        return CGSizeMake(_collectionView.mj_w - 10, 80);
    }
    else
    {
        NSInteger itemCount = 2;
        return CGSizeMake((Main_Screen_Width - 25)/itemCount, (Main_Screen_Width - 25)/itemCount + 60);
    }
}

//距离collectionview的上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,10,0,10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 1){
        
        CFShoppingCartHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableview = headerView;
        //reusableview.backgroundColor = kRedColor;
    }
    
    return reusableview;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    
    return CGSizeMake(Main_Screen_Width, 40);
}

#pragma mark --UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click collectionView row");
    CFShoppingCartCell1 *cell = (CFShoppingCartCell1 *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.imageView1 setImage:[UIImage imageNamed:@"circular"]];
//    cell.imageView1.hidden=NO;
    productModel* p=[_productList objectAtIndex:indexPath.row];
    bool psel=false;
    for (productModel* model in _productListM) {
        if ([model.productId isEqualToString:p.productId]) {
            psel=true;
            p.isSelect=YES;
        }
    }
    p.isSelect=YES;
    if (!psel) {
        [_productListM addObject:p];
    }
    cell.imageView1.hidden=NO;
    [cell.imageView1 setImage:[UIImage imageNamed:@"circular"]];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CFShoppingCartCell1 *cell = (CFShoppingCartCell1 *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.imageView1 setImage:[UIImage imageNamed:@"circle"]];
//    cell.imageView1.hidden=YES;
    productModel* p=[_productList objectAtIndex:indexPath.row];
    bool psel=false;
    for (productModel* model in _productListM) {
        if ([model.productId isEqualToString:p.productId]) {
            psel=true;
            p.isSelect=NO;
        }
    }
    p.isSelect=NO;
    if (psel) {
        [_productListM removeObject:p];
    }
    cell.imageView1.hidden=YES;

    //    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
}
#pragma mark - <DZNEmptyDataSetSource>

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *buttonTitle = @"去逛逛";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:17],
                                 NSForegroundColorAttributeName: [UIColor blackColor]
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_cart"];
}
#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // Do something
//    [self refreshingAgain];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    
    return Main_Screen_Width * 0.75;
}
#pragma mark --UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖动");
    [[_collectionView visibleCells] makeObjectsPerformSelector:@selector(hiddenButtonsWithAnimation)];
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
