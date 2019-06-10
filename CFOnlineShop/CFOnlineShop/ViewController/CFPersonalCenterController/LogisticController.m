//
//  LogisticController.m
//  CFOnlineShop
//
//  Created by app on 2019/6/5.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "LogisticController.h"
#import "checkModel.h"
#import "PeTimeLine.h"
#import "logisticModel.h"
@interface LogisticController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) UITableView* tableView;
@end

@implementation LogisticController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderNo=@"1136150822208565250";
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, self.view.bounds.size.width, self.view.bounds.size.height-40) style:UITableViewStyleGrouped];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    //    tableView.editing=YES;
    _tableView=tableView;
    
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 104)];
    v.backgroundColor=RGBCOLOR(241, 151, 54);
    UIImageView* img=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    [img setImage:[UIImage imageNamed:@"logistic"]];
    [v addSubview:img];
    UILabel* orderno= [[UILabel alloc] initWithFrame:CGRectMake(100, 50, Main_Screen_Width-110, 40)];
    [orderno setTextColor:[UIColor whiteColor]];
    orderno.font=[UIFont systemFontOfSize:16];
    orderno.text=[NSString stringWithFormat:@"运单号:%@",_orderNo];
    [v addSubview:orderno];
    _tableView.tableHeaderView=v;
    
    
    [self.view addSubview:tableView];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    _segmentTitles = @[@"全部订单",@"待支付",@"待发货",@"已完成"];
    [self postUI];
}
-(void)postUI
{
    NSDictionary *params = @{
                             @"openId" : [MySingleton sharedMySingleton].openId,
                             @"orderId" : _orderNo
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/sysexpressconfig/getExpressUser"] body:data showLoading:false success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"");
        NSString* a=jsonDict[@"kd"];
        NSDictionary *retDict = nil;
        NSData *jsonData = [a dataUsingEncoding:NSUTF8StringEncoding];
        retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];

        _checkList=[[NSMutableArray alloc] init];
        //
        for (NSDictionary* products in retDict[@"data"]) {
            logisticModel* l=[logisticModel mj_objectWithKeyValues:products];
            NSLog(@"");
            //            [_topicList addObject:t];
            [_checkList addObject:l];
        }
        //        weakself.segmentedControl.tapIndex=2;
        [_tableView reloadData];
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
                             @"orderId" : @"1136150822208565250"
                             };
    WeakSelf(self)
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/sysexpressconfig/getExpressUser"] params:params success:^(id responseObj) {
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
    return [_checkList count]+1;
    //    }else{
    //        return 10;
    //    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置每行的UITableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[UITableViewCell new];;
//    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
        
//    }
    if (indexPath.row==0) {
        PeTimeLine *time = [[PeTimeLine alloc]initWithFrame:CGRectMake(20, 20, 300, 100)];
        NSArray *array  = [NSArray arrayWithObjects:@"未发货",@"已发货",@"已签收",nil];
        time.allSteps = array;
        time.nowStep=2;
        [cell.contentView addSubview:time];
        return cell;
    }
    else{
    cell.textLabel.text = [NSString stringWithFormat:@"第%d分区",indexPath.section];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%d行",indexPath.row];
    //    cell.imageView.image= [UIImage imageNamed:@"image"];
    //    cell.backgroundColor = [UIColor greenColor];
    //    cell.showsReorderControl=YES;
    //    cell.shouldIndentWhileEditing=YES;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    logisticModel* c=[_checkList objectAtIndex:indexPath.row-1];
    cell.textLabel.text=c.context;
    cell.detailTextLabel.text=c.time;
    //
    UILabel* label=[UILabel new];
//    label.text=[NSString stringWithFormat:@"+%i",indexPath.row];
    label.font=[UIFont systemFontOfSize:20];
    label.textColor=[UIColor orangeColor];
    [label sizeToFit];
    label.frame=CGRectMake(Main_Screen_Width-label.frame.size.width-15, 17, label.frame.size.width, label.frame.size.height);
    [cell.contentView addSubview:label];
    //    cell.detailTextLabel.text=c.signTime;
    //    cell.
        return cell;
    }
    return cell;
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section==0) {
    //        return 100;
    //    }else{
    return 104;
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
