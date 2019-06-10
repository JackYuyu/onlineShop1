//
//  AddressListController.m
//  CFOnlineShop
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import "AddressListController.h"
#import "NewAddressController.h"
#import "addressModel.h"
@interface AddressListController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic,strong) NSString* province;
@property (nonatomic,strong) NSString* city;
@property (nonatomic,strong) NSString* area;
@property (nonatomic,strong) NSString* addressInfo;

@property (nonatomic,strong) NSString* input;
@property (nonatomic,strong) NSString* input1;
@property (nonatomic,strong) NSString* input3;
@end

@implementation AddressListController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, self.view.bounds.size.width, self.view.bounds.size.height-40) style:UITableViewStyleGrouped];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    //    tableView.editing=YE
    _tableView=tableView;
    [self.view addSubview:tableView];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-80, self.view.frame.size.width, 80)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton* add=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width-20, 60)];
    [add setBackgroundColor:[UIColor redColor]];
    [add setTitle:@"新增地址" forState:(UIControlStateNormal)];
    [add setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [add addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [add.titleLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:add];
    [self.view addSubview:view];
    
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    [self postRecordUI];
}
-(void)addAction
{
    NewAddressController* n=[NewAddressController new];
    [self.navigationController pushViewController:n animated:YES];
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

-(void)postRecordUI
{
    if (![MySingleton sharedMySingleton].openId) {
        return;
    }
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId
                             };
    WeakSelf(self)
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/useraddress/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        _checkList=[[NSMutableArray alloc] init];
        //
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
                        addressModel* t=[addressModel mj_objectWithKeyValues:products];
            NSLog(@"");
            //            [_topicList addObject:t];
                        [_checkList addObject:t];
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    addressModel* a=[_checkList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",a.receiptName,a.receiptTelphone];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@%@",a.provinceName,a.cityName,a.areaName,a.street];


    return cell;
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section==0) {
    //        return 100;
    //    }else{
    return 64;
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
    addressModel* a=[_checkList objectAtIndex:indexPath.row];
    _province=a.provinceName;
    _city=a.cityName;
    _area=a.areaName;
    _input=a.receiptName;
    _input1=a.receiptTelphone;
    _input3=a.street;
    NewAddressController* n=[NewAddressController new];
    n.province=   _province;
    n.city=_city;
    n.area= _area;;
    n.input=_input;
    n.input1=_input1;
    n.input3=_input3;
    [self.navigationController pushViewController:n animated:YES];
}

@end
