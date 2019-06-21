//
//  FSSettlementViewController.m
//  FSFurnitureStore
//
//  Created by CODER_TJ on 2018/12/1.
//  Copyright © 2018 Mac TAN. All rights reserved.
//

#import "FSSettlementViewController.h"
#import "FSShoppingCartInfoCell.h"
#import "PPNumberButton.h"
#import "AddressListController.h"
#import "FSShopCartList.h"
#import "checkModel.h"
#import "commModel.h"
#import "cartModel.h"

#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"
#import "commonOrder.h"
static NSString *const kOrderCellWithIdentifier = @"kOrderCellWithIdentifier";

@interface FSSettlementViewController ()<WXApiManagerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;

@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@property (weak, nonatomic) IBOutlet UITableView *curTabView;

@property (nonatomic, strong) NSMutableArray *addressResult;

@property (nonatomic, copy) NSString * addressID;
@property (nonatomic, strong) NSArray *detailTitles;
@property (nonatomic, strong) NSArray *rightTitles;

@property (nonatomic, copy) NSString * totalPrice;
@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) NSString* input;
@end
static NSInteger num_;

@implementation FSSettlementViewController

- (NSMutableArray *)addressResult {
    
    if (!_addressResult) {
        
        _addressResult = [NSMutableArray array];
    }
    return _addressResult;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认订单";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _detailTitles = @[@"配送方式",@"买家留言:",@"积分 共10",@"商品总额",@"运费",@"积分"];
    _rightTitles = @[@"快递公司",@"本次交易的说明:",@"当前使用积分 0",@"75",@"+10",@"-0"];

    [self initSubview];
    [self requestAddress];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 0;
    [self showLeftBackButton];
    
    //
    double pro;
    double sum=0.0;
    for (int i=0; i<self.dataSource.count; i++) {
        FSShopCartList* p=[self.dataSource objectAtIndex:i];
        pro=[p.productPrice doubleValue]*[p.num doubleValue];
        sum=sum+pro;
    }
    _totalPrice=[NSString stringWithFormat:@"%.2f",sum];
//    if ([_productList count]>0) {
//        [self setBottomView];
//    }
    [self postRecordUI];
    [WXApiManager sharedManager].delegate = self;
}

- (void)initSubview {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bottomButton.layer.cornerRadius = 5.0;
    self.bottomButton.layer.masksToBounds = YES;
    
    self.orderButton.layer.cornerRadius = 5;
    self.orderButton.layer.masksToBounds = YES;
    self.orderButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.orderButton addTarget:self action:@selector(addNewOrder) forControlEvents:UIControlEventTouchUpInside];
    
    self.totalMoneyLab.text = @"￥0.0";
    self.totalPriceLab.text = @"￥0.0";
    
    [self initTabView];
    [self initAddress];
}

- (void)initTabView {
    
    self.curTabView.delegate = self;
    self.curTabView.dataSource = self;
    self.curTabView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.curTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.curTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.curTabView registerNib:[UINib nibWithNibName:@"FSShoppingCartInfoCell" bundle:nil] forCellReuseIdentifier:kOrderCellWithIdentifier];
}
-(void)initAddress
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    _nameLabel.text=[userd objectForKey:@"nickname"];
    _telLabel.text=[userd objectForKey:@"cartPhone"];
    _addressLabel.text=[NSString stringWithFormat:@"%@%@",[userd objectForKey:@"address"],[userd objectForKey:@"street"]];
    if (![userd objectForKey:@"nickname"]) {
        _nameLabel.text=@"去设置收货地址";
    }
}

#pragma mark - Request

- (void)addNewOrder {
    
}


- (void)requestAddress {
    
}

- (void)addToAddress {
    
//    FSAddressAddViewController *addAddress = [[FSAddressAddViewController alloc] init];
//    [self.navigationController pushViewController:addAddress animated:YES];
}

- (void)popToController {
    
}
- (void)pp_numberButton:(__kindof UIView *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
{
    FSShopCartList* fsc=self.dataSource[0];
    double pro0=[fsc.productPrice doubleValue]*number;
    _totalPrice=[NSString stringWithFormat:@"%.2f",pro0];
    
    
    double pro;
    double sum=0.0;
    for (int i=0; i<self.dataSource.count; i++) {
        if (i==numberButton.tag) {
            FSShopCartList* p=[self.dataSource objectAtIndex:i];
            p.num=[NSString stringWithFormat:@"%i", number];
            pro=[p.productPrice doubleValue]*number;
        }
        else
        {
            FSShopCartList* p=[self.dataSource objectAtIndex:i];
            pro=[p.productPrice doubleValue]*[p.num doubleValue];
        }
        sum=sum+pro;
    }
    _totalPrice=[NSString stringWithFormat:@"%.2f",sum];
    NSLog(@"");
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:3];
    
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    [_curTabView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//    [_curTabView reloadData];
//    for (int i=0; i<_productList.count; i++) {
//        if (i==numberButton.tag) {
//            productModel* p=[_productList objectAtIndex:i];
//            p.num=number;
//        }
//    }
    //    for (productModel* p in _productList) {
    //        float s
    //    }
    NSInteger b=numberButton.tag;
}
#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
        return self.dataSource.count;
    else if (section==1) {
        return 2;
    }
    else if (section==2) {
        return 1;
    }
    else {
        return 4;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {

//    FSShoppingCartInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderCellWithIdentifier];
    FSShoppingCartInfoCell *cell = [[NSBundle mainBundle]loadNibNamed:@"FSShoppingCartInfoCell" owner:self options:nil].firstObject;
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
        cell.hideAdd = YES;
        PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectZero];
        numberButton.shakeAnimation = YES;
        numberButton.minValue = 1;
        numberButton.inputFieldFont = 14;
        numberButton.increaseTitle = @"＋";
        numberButton.decreaseTitle = @"－";
        num_ = (_lastNum == 0) ?  1 : [_lastNum integerValue];
        
        FSShopCartList* p=[self.dataSource objectAtIndex:indexPath.row];

        numberButton.currentNumber = [p.num integerValue];
        numberButton.delegate = self;
        numberButton.tag=indexPath.row;

        numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
            num_ = num;
        };
        [cell.contentView addSubview:numberButton];
        [numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(cell.contentView)setOffset:-10];
            [make.bottom.mas_equalTo(cell.contentView)setOffset:10];
            make.size.mas_equalTo(CGSizeMake(100, 60));
        }];
        
        
       UILabel* _normStr = [[UILabel alloc] init];
        _normStr.font = SYSTEMFONT(14);
        _normStr.textColor = kBlackColor;
        FSShopCartList* ff=self.dataSource[indexPath.row];
        _normStr.text=ff.goodNorm;
        [cell.contentView addSubview:_normStr];
        [_normStr mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(numberButton)setOffset:-110];
            [make.centerY.mas_equalTo(numberButton)setOffset:-3];
            make.size.mas_equalTo(CGSizeMake(80, 40));
        }];
    }
    return cell;
    }
    else
    {
        static NSString *identifier = @"identifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.font = SYSTEMFONT(16);
        cell.textLabel.textColor = KDarkTextColor;
        cell.textLabel.text = @"哈哈哈哈哈啊哈哈";
        if (indexPath.section>0) {
            cell.textLabel.text = [_detailTitles objectAtIndex:indexPath.row+indexPath.section-1];
            cell.detailTextLabel.text=[_rightTitles objectAtIndex:indexPath.row+indexPath.section-1];
        }
        if (indexPath.section>0 && indexPath.row==1) {
            FSShopCartList* fsc=[FSShopCartList new];
            fsc=self.dataSource[0];
            if (!_totalPrice) {
                cell.detailTextLabel.text=fsc.productPrice;
            }
            else{
                cell.detailTextLabel.text=[NSString stringWithFormat:@"¥%@",_totalPrice];
            }

        }
        if (indexPath.section==2 && indexPath.row==0) {
            cell.textLabel.text=@"当前积分";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"积分:%d分",_checkList.count];
        }
        if (indexPath.section==1&& indexPath.row==1) {
            cell.detailTextLabel.hidden=YES;
            UITextField* input=[UITextField new];
            input.placeholder=@"请输入留言";
            input.delegate=self;
            [cell.contentView addSubview:input];
            [input mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.contentView).offset(10);
                make.centerY.mas_equalTo(cell.contentView);
                make.left.mas_equalTo(cell.textLabel.right).offset(100);
            }];
        }
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0)
        return 100;

    else {
        return 44;
    }
}

//设置分区头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
//设置分区的头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    return view;
}
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"");
}
#pragma mark - Action

- (IBAction)arrowDidEvent:(id)sender {
    AddressListController* a=[AddressListController new];
    [self.navigationController pushViewController:a animated:YES];
    if (!self.addressID) {
        [self addToAddress];
    }
}

-(IBAction)addOrder:(id)sender
{
    NSLog(@"");
    [self postUI];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int b=textField.tag;
    if (b==0) {
    }
    textField.backgroundColor = [UIColor whiteColor];
    _input=[textField.text stringByAppendingString:string];

    NSLog(@"结束编辑");
    return YES;
}
-(void)postUI
{
    NSMutableArray* comm=[NSMutableArray new];
    for (FSShopCartList* newCart in self.dataSource) {
        cartItemList* c=[cartItemList new];
        c.goodsId=newCart.goodsId;
        c.goodsSkuId=newCart.goodsSkuId;
        c.priceId=@"1027013640128811079";
        c.num=newCart.num;
        c.evaluateStatus=@"0";
        c.status=@"0";
        [comm addObject:c];
    }
    cartModel* m=[cartModel new];
    m.goodsOrderItemList=[comm copy];
    
    cartOrderEntity* ce=[cartOrderEntity new];
    ce.deliverStatus=@"0";
    ce.auditStatus=@"0";
    ce.logisticsCode=@"0";
    ce.logisticsNo=@"0";
    ce.payStatus=@"0";
    ce.totalPrice=_totalPrice;
    ce.hasDefaultAddress=@"0";
    ce.totalGoodsPrice=_totalPrice;
    ce.actualPrice=_totalPrice;
    ce.openId=[MySingleton sharedMySingleton].openId;
    ce.status=@"0";
    if (_input) {
        ce.remarks=_input;
    }
    else
        ce.remarks=@"买入一件";
    
    m.goodsOrderEntity=ce;
    NSString* a=m.mj_JSONString;
    //    NSDictionary *params = @{
    //                             @"list" : [comm mj_JSONString]
    //                             };
    NSData *data =   [a dataUsingEncoding:NSUTF8StringEncoding];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/goodsorder/save"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"");
        [MBProgressHUD showMBProgressHud:self.view withText:@"新增订单成功" withTime:1];
        commonOrder* order=[commonOrder mj_objectWithKeyValues:jsonDict[@"GoodsOrderEntity"]];
        [self postOrderUI:order];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postRecordUI
{
    if (![MySingleton sharedMySingleton].openId) {
        [self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];
        
        return;
    }
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"todayScore" : @"1",
                             @"conDays" : @"1",
                             @"score" : @"1"
                             };
    WeakSelf(self)
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/usersigininfo/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        _checkList=[[NSMutableArray alloc] init];
        //
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            checkModel* t=[checkModel mj_objectWithKeyValues:products];
            NSLog(@"");
            //            [_topicList addObject:t];
            [_checkList addObject:t];
        }
        [_curTabView reloadData];

//        _label.text=[NSString stringWithFormat:@"积分:%d分",_checkList.count];
        
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

-(void)postOrderUI:(commonOrder*)order
{
    if (![MySingleton sharedMySingleton].openId) {
        [self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];
        
        return;
    }
    
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    NSString* tp=[user objectForKey:@"phone"];
    NSTimeInterval timestamp=[[NSDate date] timeIntervalSince1970];
    NSString* tradeno=[NSString stringWithFormat:@"%@%.0f",tp,timestamp];
    NSDictionary *params = @{
//                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"body" : @"商品购买",
                             @"detail" : @"确认订单",
                             @"outTradeNo" : order.payTradeNo,
                             @"totalFee" : [NSString stringWithFormat:@"%.0f",[order.totalPrice doubleValue]*100],
                             @"spbillCreateIp" : @"14.23.14.24",
                             @"notifyUrl" : @"http://192.168.0.198:8080/renren-fast/weChatPay/notify/order",
                             @"tradeType" : @"APP",
                             };
    WeakSelf(self)
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/weChatPay/createOrder"] body:data showLoading:false success:^(NSDictionary *responseObj) {
//    [HttpTool post:[NSString stringWithFormat:@"renren-fast/weChatPay/createOrder"] params:params success:^(id responseObj) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];

//        NSDictionary* a=responseObj[@"page"][@"list"];
        _checkList=[[NSMutableArray alloc] init];
        //
//        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
//            checkModel* t=[checkModel mj_objectWithKeyValues:products];
//            NSLog(@"");
//            //            [_topicList addObject:t];
//            [_checkList addObject:t];
//        }
//        [_curTabView reloadData];
        
        //        _label.text=[NSString stringWithFormat:@"积分:%d分",_checkList.count];
        NSDictionary* d=[jsonDict copy];
        [self wechatPay:d];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)wechatPay:(NSDictionary*)d
{
    [self.navigationController popViewControllerAnimated:NO];
//    NSDictionary* d=[NSDictionary new];
//    [[WXApiObject shareInstance]WXApiPayWithParam:d];
    NSString *res = [WXApiRequestHandler jumpToBizPay:d];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
}
@end
