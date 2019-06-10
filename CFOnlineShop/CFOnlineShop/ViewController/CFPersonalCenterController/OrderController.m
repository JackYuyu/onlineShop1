//
//  OrderController.m
//  CFOnlineShop
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import "OrderController.h"
#import "math.h"
#import "CFSegmentedControl.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "OrderEntity.h"
#import "FSSettlementViewController1.h"
#import "productModel.h"
#import "LogisticController.h"
#import "CommentController.h"
@interface OrderController ()<UITableViewDataSource,UITableViewDelegate,CFSegmentedControlDataSource,CFSegmentedControlDelegate>
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) CFSegmentedControl *segmentedControl;
@property (nonatomic,strong) NSMutableArray* productList;

@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) UITableView* tableView;
@end

@implementation OrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight+40, self.view.bounds.size.width, self.view.bounds.size.height-40) style:UITableViewStyleGrouped];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    //    tableView.editing=YES;
    _tableView=tableView;
    [self.view addSubview:tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"OrderCell"];
    
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    _segmentTitles = @[@"全部订单",@"待支付",@"待发货",@"已完成"];
    
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    view.backgroundColor = [UIColor whiteColor];
    _segmentedControl = [[CFSegmentedControl alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - (90 * [_segmentTitles count])/2, TopHeight, 90 * [_segmentTitles count], 40)];
    _segmentedControl.delegate = self;
    _segmentedControl.dataSource = self;
    _segmentedControl.alpha = 1;
//    [view addSubview:_segmentedControl];
    [self.view addSubview:_segmentedControl];
    [self postRecordUI];
}
-(void)postUI
{
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/usersigininfo/save"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
#pragma mark -- SegmentedControlDelegate & datasource

- (NSArray *)getSegmentedControlTitles
{
    return _segmentTitles;
}

- (void)control:(CFSegmentedControl *)control didSelectAtIndex:(NSInteger)index
{
    if (index==0) {
        [self postRecordUI];
    }
    if (index==1) {
        [self postRecordUI1];
    }
    else if (index==2) {
        [self postRecordUI2];
    }
    else if (index==3) {
        [self postRecordUI3];
    }
    NSLog(@"");
    //    [_bgScrollView setContentOffset:CGPointMake(Main_Screen_Width * index, 0) animated:YES];
}
-(void)postRecordUI
{
    if (![MySingleton sharedMySingleton].openId) {
        return;
    }
    NSDictionary *params = @{
                             @"openId" : @"olEaQ4jE4SkGd1FdU73v4a0IgCD8",
                             @"payStatus" : @"-1"
                             };
    WeakSelf(self)
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsorder/querylist"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"result"];
        _checkList=[[NSMutableArray alloc] init];
        _productList=[[NSMutableArray alloc] init];

        //
        for (NSDictionary* products in responseObj[@"result"]) {
            OrderModel* t=[OrderModel mj_objectWithKeyValues:products];
            OrderEntity* e=[OrderEntity mj_objectWithKeyValues:t.goodsOrderEntity];
            NSMutableArray* tm=[NSMutableArray new];
            for (NSDictionary* m in t.goodsOrderItemVO) {
                productModel* p=[productModel mj_objectWithKeyValues:m];
                NSLog(@"");
                [tm addObject:p];
            }
            e.productLists=tm;
            NSLog(@"");
            //            [_topicList addObject:t];
            [_checkList addObject:e];
            
        }
//        weakself.segmentedControl.tapIndex=2;
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postRecordUI1
{
    NSDictionary *params = @{
                             @"openId" : @"olEaQ4jE4SkGd1FdU73v4a0IgCD8",
                             @"payStatus" : @"0"
                             };
    WeakSelf(self)
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsorder/querylist"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"result"];
        _checkList=[[NSMutableArray alloc] init];
        //
        for (NSDictionary* products in responseObj[@"result"]) {
            OrderModel* t=[OrderModel mj_objectWithKeyValues:products];
            OrderEntity* e=[OrderEntity mj_objectWithKeyValues:t.goodsOrderEntity];
            NSLog(@"");
            //            [_topicList addObject:t];
            [_checkList addObject:e];
        }
        //        weakself.segmentedControl.tapIndex=2;
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postRecordUI2
{
    NSDictionary *params = @{
                             @"openId" : @"olEaQ4jE4SkGd1FdU73v4a0IgCD8",
                             @"payStatus" : @"1"
                             };
    WeakSelf(self)
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsorder/querylist"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"result"];
        _checkList=[[NSMutableArray alloc] init];
        //
        for (NSDictionary* products in responseObj[@"result"]) {
            OrderModel* t=[OrderModel mj_objectWithKeyValues:products];
            OrderEntity* e=[OrderEntity mj_objectWithKeyValues:t.goodsOrderEntity];
            NSLog(@"");
            //            [_topicList addObject:t];
            [_checkList addObject:e];
        }
        //        weakself.segmentedControl.tapIndex=2;
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
-(void)postRecordUI3
{
    NSDictionary *params = @{
                             @"openId" : @"olEaQ4jE4SkGd1FdU73v4a0IgCD8",
                             @"payStatus" : @"4"
                             };
    WeakSelf(self)
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodsorder/querylist"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"result"];
        _checkList=[[NSMutableArray alloc] init];
        //
        for (NSDictionary* products in responseObj[@"result"]) {
            OrderModel* t=[OrderModel mj_objectWithKeyValues:products];
            OrderEntity* e=[OrderEntity mj_objectWithKeyValues:t.goodsOrderEntity];
            NSLog(@"");
            //            [_topicList addObject:t];
            [_checkList addObject:e];
        }
        //        weakself.segmentedControl.tapIndex=2;
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
//设置表格视图有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (section==0) {
    return [_checkList count];
    //    }else{
    //        return 10;
    //    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置每行的UITableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
//    if (cell==nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
//
//    }
    

    //    cell.imageView.image= [UIImage imageNamed:@"image"];
    //    cell.backgroundColor = [UIColor greenColor];
    //    cell.showsReorderControl=YES;
    //    cell.shouldIndentWhileEditing=YES;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    OrderEntity* e=[_checkList objectAtIndex:indexPath.row];
    cell.orderno.text=[NSString stringWithFormat:@"订单号: %@",e.orderNo];
    cell.date.text=[NSString stringWithFormat:@"提交时间: %@",e.createTime];
    
//    cell.status.text=[NSString stringWithFormat:@"订单号: %@",e.orderNo];
    cell.payprice.text=[NSString stringWithFormat:@"应付款: ¥:%@",e.totalPrice];
    [cell.paybtn setBackgroundColor:[UIColor redColor]];
    [cell.paybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.paybtn addTarget:self action:@selector(logi:) forControlEvents:UIControlEventTouchUpInside];
    cell.paybtn.tag=indexPath.row;
    
    [cell.cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cell.cancel addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    cell.cancel.tag=indexPath.row;
//    cell.detailTextLabel.text=c.signTime;
    //    cell.
    [cell.paybtn.layer setMasksToBounds:YES]; [cell.paybtn.layer setCornerRadius:3.0];
    [cell.cancel.layer setMasksToBounds:YES]; [cell.cancel.layer setCornerRadius:3.0];
    if ([e.payStatus isEqualToString:@"0"]) {
        cell.status.text=@"待支付";

    }
    else{
        cell.status.text=@"已支付";
        [cell.cancel setBackgroundColor:[UIColor redColor]];
        [cell.cancel setTitle:@"申请退款" forState:UIControlStateNormal];
        [cell.cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.paybtn setBackgroundColor:[UIColor whiteColor]];
        [cell.paybtn setTitle:@"暂未发货" forState:UIControlStateNormal];
        [cell.paybtn setTitleColor:KDarkTextColor forState:UIControlStateNormal];
    }
    return cell;
}
-(void)logi:(UIButton*)sender
{
    NSInteger a=sender.tag;
    if (sender.tag==0) {
        CommentController* c=[CommentController new];
        
        OrderEntity* e=[_checkList objectAtIndex:sender.tag];
        NSMutableArray* source=[NSMutableArray new];
        for (productModel* p in e.productLists) {
            FSShopCartList *newCart = [FSShopCartList new];
            newCart.num = [NSString stringWithFormat:@"%ld", 1.0];
            newCart.logo = p.logo;
            newCart.name = p.name;
            newCart.productPrice=p.priceName;
            newCart.goodNorm=p.goodNorm;
            newCart.idField = @"11111";
            [source addObject:newCart];
        }
        c.dataSource=source;
        [self.navigationController pushViewController:c animated:YES];
    }
    else{
    LogisticController* logi=[LogisticController new];
    [self.navigationController pushViewController:logi animated:YES ];
    }
}
-(void)delete:(UIButton*)sender
{
    OrderEntity* e=[_checkList objectAtIndex:sender.tag];

    NSDictionary *params = @{
                             @"id" : e.orderNo
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/goodsorder/delete"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"");
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section==0) {
    //        return 100;
    //    }else{
    return 144;
    //    }
}
//设置分区尾视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//设置分区头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
//设置分区的尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor = [UIColor greenColor];
    return view;
}
//设置分区的头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];

    return view;
}
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context,rect);
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//选中cell时调用的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSSettlementViewController1* confirmOrder=[[FSSettlementViewController1 alloc] initWithNibName:@"FSSettlementViewController1" bundle:nil];
    OrderEntity* e=[_checkList objectAtIndex:indexPath.row];
    confirmOrder.entity=e;
    NSMutableArray* source=[NSMutableArray new];
    for (productModel* p in e.productLists) {
        FSShopCartList *newCart = [FSShopCartList new];
        newCart.num = [NSString stringWithFormat:@"%ld", 1.0];
        newCart.logo = p.logo;
        newCart.name = p.name;
        newCart.productPrice=p.priceName;
        newCart.goodNorm=p.goodNorm;
        newCart.idField = @"11111";
        [source addObject:newCart];
    }
    
    confirmOrder.dataSource = source;
    confirmOrder.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:confirmOrder animated:YES];
}

@end
