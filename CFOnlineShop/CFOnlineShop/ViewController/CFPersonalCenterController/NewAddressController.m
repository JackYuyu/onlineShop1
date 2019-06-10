//
//  NewAddressController.m
//  CFOnlineShop
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import "NewAddressController.h"
#import "JYAddressPicker.h"
@interface NewAddressController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) UITableView* tableView;


@end

@implementation NewAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, self.view.bounds.size.width, self.view.bounds.size.height-40) style:UITableViewStyleGrouped];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    //    tableView.editing=YE
    _tableView=tableView;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-80, self.view.frame.size.width, 80)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton* add=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width-20, 60)];
    [add setBackgroundColor:[UIColor redColor]];
    [add setTitle:@"完成" forState:(UIControlStateNormal)];
    [add setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [add addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [add.titleLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:add];
    _tableView.tableFooterView=view;
    
    [self.view addSubview:tableView];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    _checkList = @[@"收货人姓名:",@"联系电话:",@"所在地区:",@"详细地址:",@"设置默认地址:"];
}
-(void)addAction
{
    if (!_province&&!_city&&!_area&&!_input3&&!_input1&&!_input) {
        return;
    }
    [self postUI];
}
-(void)postUI
{
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"receiptAddress" : @"1",
                             @"province" : @"1",
                             @"provinceName" : _province,
                             @"city" : @"1",
                             @"cityName" : _city,
                             @"area" : @"1",
                             @"areaName" : _area,
                             @"street" : _input3,
                             @"receiptTelphone" : _input1,
                             @"defaultFlag" : @"1",
                             @"receiptName" : _input,
                             @"postCode" : @"1",
                             @"status" : @"1",
                             @"remarks" : @"1",
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/useraddress/save"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        
        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
        [userd setObject:_input forKey:@"nickname"];
        [userd setObject:[NSString stringWithFormat:@"%@-%@-%@",_province,_city,_area] forKey:@"address"];
        [userd setObject:_input3 forKey:@"street"];

        [userd synchronize];
        [self.navigationController popViewControllerAnimated:YES];
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
            //            checkModel* t=[checkModel mj_objectWithKeyValues:products];
            NSLog(@"");
            //            [_topicList addObject:t];
            //            [_checkList addObject:t];
        }
        //        weakself.segmentedControl.tapIndex=2;
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int b=textField.tag;
    if (b==0) {
        _input=[textField.text stringByAppendingString:string];
    }
    else if (b==1)
    {
        _input1=[textField.text stringByAppendingString:string];
    }
    else if (b==3)
    {
        _input3=[textField.text stringByAppendingString:string];
    }
    NSLog(@"结束编辑");
    return YES;
}
//设置表格视图有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (section==0) {
    return 5;
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_checkList objectAtIndex:indexPath.row];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%d行",indexPath.row];
    if (indexPath.row==2) {
        cell.detailTextLabel.text = @"省-市-区";
        if (self.addressInfo) {
            cell.detailTextLabel.text = self.addressInfo;
        }
        if (_province) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@-%@",_province,_city,_area];
        }
    }
    else
    {
        if (indexPath.row<4) {

        UITextField* input=[[UITextField alloc] initWithFrame:CGRectMake(120, 5, Main_Screen_Width-130, 50)];
        input.tag=indexPath.row;
        input.delegate=self;
        [cell.contentView addSubview: input];
            if (_input) {
                if (indexPath.row==0) {
                    input.text=_input;
                }
                if (indexPath.row==1) {
                    input.text=_input1;
                }
                if (indexPath.row==3) {
                    input.text=_input3;
                }
            }
        }
        if (indexPath.row==4) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        
    }
    //    cell.imageView.image= [UIImage imageNamed:@"image"];
    //    cell.backgroundColor = [UIColor greenColor];
    //    cell.showsReorderControl=YES;
    //    cell.shouldIndentWhileEditing=YES;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    checkModel* c=[_checkList objectAtIndex:indexPath.row];
    //    cell.detailTextLabel.text=c.signTime;
    //    cell.
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
    if (indexPath.row==2) {
        JYAddressPicker *addressPicker = [JYAddressPicker jy_showAt:self];
        addressPicker.selectedItemBlock = ^(NSArray *addressArr) {
            
            NSString *province = [addressArr objectAtIndex:0][@"text"];
            NSString *city = [addressArr objectAtIndex:1][@"text"];
            NSString *county = [addressArr objectAtIndex:2][@"text"];
            
            self.addressInfo = [NSString stringWithFormat:@"%@-%@-%@",province,city,county];
            _province=province;
            _city=city;
            _area=county;
            [_tableView reloadData];
        };
    }
}

@end
