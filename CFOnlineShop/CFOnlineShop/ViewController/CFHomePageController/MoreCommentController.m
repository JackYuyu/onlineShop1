//
//  MoreCommentController.m
//  CFOnlineShop
//
//  Created by mac on 2019/6/9.
//  Copyright © 2019 chenfeng. All rights reserved.
//

#import "MoreCommentController.h"
#import "checkModel.h"
#import "CommentModel.h"
#import "StarView.h"
@interface MoreCommentController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) UITableView* tableView;
@end

@implementation MoreCommentController

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
        [self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];

        return;
    }
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"goodsId" : _productId,
                             @"page" : @"1",
                             @"limits": @"10"
                             };
    [HttpTool get:[NSString stringWithFormat:@"renren-fast/mall/goodscomment/list"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"page"][@"list"];
        _checkList =[NSMutableArray new];
        for (NSDictionary* products in responseObj[@"page"][@"list"]) {
            CommentModel* p=[CommentModel mj_objectWithKeyValues:products];
            //            p.productName=[products objectForKey:@"description"];
            //            p.productId=[products objectForKey:@"id"];
            NSLog(@"");
            [_checkList addObject:p];
        }
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
    
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 80)];
    UILabel*comName=[UILabel new];
    StarView* star=[StarView new];
    UILabel* date=[UILabel new];
    UILabel* comm=[UILabel new];
    CommentModel* c=[_checkList objectAtIndex:indexPath.row];
    comName.text=c.nickname;
    star.font_size = 16;
    star.show_star = 40;
    star.canSelected = YES;
    date.text=c.time;
    comm.text=c.content;
    [v addSubview:comName];
    [v addSubview:star];
    [v addSubview:date];
    [v addSubview:comm];
    [cell.contentView addSubview:v];
    
    [comName mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(cell.contentView)setOffset:10];
        [make.top.mas_equalTo(cell.contentView)setOffset:5];
        make.size.mas_equalTo(CGSizeMake(100, 40));
        
    }];
    [star mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(comName.mas_right)setOffset:10];
        [make.top.mas_equalTo(cell.contentView)setOffset:15];
        make.size.mas_equalTo(CGSizeMake(80, 100));
    }];
    [date mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(cell.contentView)setOffset:-10];
        [make.top.mas_equalTo(cell.contentView)setOffset:5];
        make.size.mas_equalTo(CGSizeMake(180, 40));
    }];
    [comm mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(cell.contentView)setOffset:10];
        [make.top.mas_equalTo(comName.mas_bottom)setOffset:0];
        make.size.mas_equalTo(CGSizeMake(Main_Screen_Width-20,40));
    }];
    //    cell.detailTextLabel.text=c.signTime;
    //    cell.
    return cell;
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section==0) {
    //        return 100;
    //    }else{
    return 80;
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
