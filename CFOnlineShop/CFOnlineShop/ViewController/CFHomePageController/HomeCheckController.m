//
//  HomeCheckController.m
//  CFOnlineShop
//
//  Created by app on 2019/5/24.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "HomeCheckController.h"
#import "ZWProgressPointBtn.h"
#import "math.h"
#import "CFSegmentedControl.h"
#import "checkModel.h"
#define COLOR1 [UIColor colorWithRed:1.0 green:0.2 blue:0.31 alpha:1.0]

@interface HomeCheckController ()<UITableViewDataSource,UITableViewDelegate,CFSegmentedControlDataSource,CFSegmentedControlDelegate>
@property (nonatomic, weak) ZWProgressPointBtn *progressView1;
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) CFSegmentedControl *segmentedControl;
@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,assign) NSInteger current;
@end

@implementation HomeCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    UIView* uv=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 260)];
    [uv setBackgroundColor:RGBCOLOR(250, 121, 113)];
    ZWProgressPointBtn *progressView1 = [[ZWProgressPointBtn alloc]initWithFrame:CGRectMake((uv.frame.size.width - 120)/2, uv.frame.size.height/2-60, 120  , 120)];
    progressView1.indexCount=0;
    [self.view addSubview:progressView1];
    progressView1.progressLineWidth = 5;
    progressView1.progressRadianSpacing = 0.02;
    progressView1.totalCount = 1;
    progressView1.progressCount = 1;
    progressView1.pointColor = RGBCOLOR(238, 188, 90);
    [progressView1.centerBtn setImage:[self createImageWithColor:[UIColor whiteColor]] forState:0];
    [progressView1.centerBtn addTarget:self action:@selector(clickToDo:) forControlEvents:UIControlEventTouchUpInside];
    
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 1.0f ;
    solidLine.strokeColor = [UIColor blueColor].CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(2.30f,  2.0f, 100.0f, 100.0f));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [progressView1.centerBtn.layer addSublayer:solidLine];
    
    self.progressView1 = progressView1;

    [uv addSubview:progressView1];
    
    tableView.tableHeaderView=uv;
    tableView.delegate=self;
    tableView.dataSource=self;
    //    tableView.editing=YES;
    _tableView=tableView;
    [self.view addSubview:tableView];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    _segmentTitles = @[@"积分规则",@"获得记录"];
    _current=0;
    
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
        dispatch_async(dispatch_get_main_queue(), ^{

            self.progressView1.check.text=@"已签到";
            [self.progressView1 reload];
        });
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
    if (index==1&&_current==0) {
        [self postRecordUI];
    }
    else if (index==0&&_current==1){
        [_tableView reloadData];
    }
    _current=index;
    NSLog(@"");
    //    [_bgScrollView setContentOffset:CGPointMake(Main_Screen_Width * index, 0) animated:YES];
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
        [_tableView reloadData];
        if (_current==1) {
            dispatch_async(dispatch_get_main_queue(),^{
                
                [_segmentedControl didSelectIndex:1];

            });
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
//设置表格视图有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_segmentedControl.tapIndex==0) {
        return 1;
    }
    else
        return [_checkList count];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置每行的UITableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [UITableViewCell new];
//    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
        
//    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%d分区",indexPath.section];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%d行",indexPath.row];
    //    cell.imageView.image= [UIImage imageNamed:@"image"];
//    cell.backgroundColor = [UIColor greenColor];
    //    cell.showsReorderControl=YES;
    //    cell.shouldIndentWhileEditing=YES;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    checkModel* c=[_checkList objectAtIndex:indexPath.row];
    cell.textLabel.text=@"每日签到获得";
    cell.detailTextLabel.text=c.createdDt;
    //
    UILabel* label=[UILabel new];
    label.text=[NSString stringWithFormat:@"+%@",c.todayScore];
    label.font=[UIFont systemFontOfSize:20];
    label.textColor=[UIColor orangeColor];
    [label sizeToFit];
    label.frame=CGRectMake(Main_Screen_Width-label.frame.size.width-15, 17, label.frame.size.width, label.frame.size.height);
    [cell.contentView addSubview:label];
    
    if (_segmentedControl.tapIndex==0) {
        UITextView* t=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 160)];
        t.text=@"            云邻积分规则\n\n1.签到积分规则\n亲，每天签到送积分啦！\n2.积分使用规则\n亲，签到的积分可以享受满立减，下单更优惠！";
        [t setFont:[UIFont systemFontOfSize:16]];
        [cell.contentView addSubview:t];
        return cell;
    }
//    cell.
    return cell;
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segmentedControl.tapIndex==0) {
        return 160;
    }
    else
        return 64;
}
//设置分区尾视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//设置分区头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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
    view.backgroundColor = [UIColor whiteColor];
    _segmentedControl = [[CFSegmentedControl alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - (160 * [_segmentTitles count])/2, 0, 160 * [_segmentTitles count], 40)];
    _segmentedControl.delegate = self;
    _segmentedControl.dataSource = self;
    _segmentedControl.alpha = 1;
    [view addSubview:_segmentedControl];

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
-(void)clickToDo:(ZWProgressCenterBtn *)sender
{
            self.progressView1.progressCount++;
            if (self.progressView1.progressCount>6) {
                self.progressView1.progressCount =0;
            }
            [self.progressView1 reload];
    [self postUI];
}
//选中cell时调用的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
////设置cell的编辑模式类型
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        return UITableViewCellEditingStyleInsert;
//    }else{
//        return UITableViewCellEditingStyleDelete;
//    }
//}
////设置删除按钮的标题
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
////设置cell是否支持位置移动
//-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
////位置移动后回调的方法
//-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//
//}
////提交编辑操作时触发的方法
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}
//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return @[@"one",@"two"];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
