//
//  MyCoinController.m
//  CFOnlineShop
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import "MyPointController.h"
#import "checkModel.h"
@interface MyPointController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) UITableView* tableView;
@end

@implementation MyPointController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, self.view.bounds.size.width, self.view.bounds.size.height-40) style:UITableViewStyleGrouped];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    //    tableView.editing=YES;
    _tableView=tableView;
    [self.view addSubview:tableView];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    _segmentTitles = @[@"全部订单",@"待支付",@"待发货",@"已完成"];
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

-(void)postRecordUI
{
    if (![MySingleton sharedMySingleton].openId) {
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
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%d分区",indexPath.section];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%d行",indexPath.row];
    //    cell.imageView.image= [UIImage imageNamed:@"image"];
    //    cell.backgroundColor = [UIColor greenColor];
    //    cell.showsReorderControl=YES;
    //    cell.shouldIndentWhileEditing=YES;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        checkModel* c=[_checkList objectAtIndex:indexPath.row];
    cell.textLabel.text=@"每日签到获得";
    cell.detailTextLabel.text=c.signTime;
    //
    UILabel* label=[UILabel new];
    label.text=[NSString stringWithFormat:@"+%@",c.score];
    label.font=[UIFont systemFontOfSize:20];
    label.textColor=[UIColor orangeColor];
    [label sizeToFit];
    label.frame=CGRectMake(Main_Screen_Width-label.frame.size.width-15, 17, label.frame.size.width, label.frame.size.height);
    [cell.contentView addSubview:label];
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
    
}

@end
