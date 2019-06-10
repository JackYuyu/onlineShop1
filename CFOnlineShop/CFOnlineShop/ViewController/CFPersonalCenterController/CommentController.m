//
//  CommentController.m
//  CFOnlineShop
//
//  Created by app on 2019/6/6.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "CommentController.h"
#import "checkModel.h"
#import "FSShopCartList.h"
#import "StarView.h"
#import "commModel.h"
@interface CommentController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic,strong) NSMutableArray* checkList;
@property (nonatomic,strong) UITableView* tableView;
@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, self.view.bounds.size.width, self.view.bounds.size.height-40) style:UITableViewStyleGrouped];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    //    tableView.editing=YES;
    _tableView=tableView;
    
//    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 104)];
//    v.backgroundColor=RGBCOLOR(241, 151, 54);
//    UIImageView* img=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
//    [img setImage:[UIImage imageNamed:@"logistic"]];
//    [v addSubview:img];
//    UILabel* orderno= [[UILabel alloc] initWithFrame:CGRectMake(100, 50, Main_Screen_Width-110, 40)];
//    [orderno setTextColor:[UIColor whiteColor]];
//    orderno.font=[UIFont systemFontOfSize:16];
//    orderno.text=[NSString stringWithFormat:@"运单号:%@",_orderNo];
//    [v addSubview:orderno];
//    _tableView.tableHeaderView=v;
    
    
    [self.view addSubview:tableView];
    self.navigationBgView.backgroundColor = kWhiteColor;
    self.navigationBgView.alpha = 1;
    [self showLeftBackButton];
    _segmentTitles = @[@"全部订单",@"待支付",@"待发货",@"已完成"];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-80, self.view.frame.size.width, 80)];
    view.backgroundColor = [UIColor clearColor];
    UIButton* add=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width-20, 60)];
    [add setBackgroundColor:[UIColor greenColor]];
    [add setTitle:@"发表" forState:(UIControlStateNormal)];
    [add setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [add addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [add.titleLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:add];
    _tableView.tableFooterView=view;
}
-(void)addAction
{
    [self postUI];
}
-(void)postUI
{
    NSMutableArray* comm=[NSMutableArray new];
    for (FSShopCartList* newCart in self.dataSource) {
        commList* c=[commList new];
        c.goodsId=newCart.goodsId;
        c.content=@"ppp";
        c.star=@"3";
        c.status=@"1";

        [comm addObject:c];
    }
    commModel* m=[commModel new];
    m.list=[comm copy];
    NSString* a=m.mj_JSONString;
//    NSDictionary *params = @{
//                             @"list" : [comm mj_JSONString]
//                             };
    NSData *data =   [a dataUsingEncoding:NSUTF8StringEncoding];
    [HttpTool postWithUrl:[NSString stringWithFormat:@"renren-fast/mall/goodscomment/save"] body:data showLoading:false success:^(NSDictionary *response) {
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
    return [self.dataSource count];
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

//        cell.textLabel.text = [NSString stringWithFormat:@"第%d分区",indexPath.section];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"第%d行",indexPath.row];
        //    cell.imageView.image= [UIImage imageNamed:@"image"];
        //    cell.backgroundColor = [UIColor greenColor];
        //    cell.showsReorderControl=YES;
        //    cell.shouldIndentWhileEditing=YES;
        //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //
    FSShopCartList* fc=[self.dataSource objectAtIndex:indexPath.row];
        UILabel* label=[UILabel new];
            label.text=fc.name;
        label.font=[UIFont systemFontOfSize:20];
//        label.textColor=[UIColor orangeColor];
        [label sizeToFit];
        label.frame=CGRectMake(10, 5, label.frame.size.width, label.frame.size.height);
        [cell.contentView addSubview:label];
    UILabel* label1=[UILabel new];
    label1.text=@"评分:";
    label1.font=[UIFont systemFontOfSize:20];
//    label1.textColor=[UIColor orangeColor];
    [label1 sizeToFit];
    label1.frame=CGRectMake(10, 35, label1.frame.size.width, label1.frame.size.height);
    [cell.contentView addSubview:label1];
    //
    StarView* star=[[StarView alloc] initWithFrame:CGRectMake(label1.frame.size.width+30, 35, Main_Screen_Width- label1.frame.size.width-20, label1.frame.size.height)];
    star.font_size = 16;
    star.show_star = 40;
    star.canSelected = YES;
    [cell.contentView addSubview:star];
    
    UILabel* label2=[UILabel new];
    label2.text=@"内容:";
    label2.font=[UIFont systemFontOfSize:20];
//    label2.textColor=[UIColor orangeColor];
    [label2 sizeToFit];
    label2.frame=CGRectMake(10, 65, label2.frame.size.width, label2.frame.size.height);
    [cell.contentView addSubview:label2];
    UITextView* tx=[UITextView new];
    tx.text=@"请输入评价内容";
    tx.font=[UIFont systemFontOfSize:16];
    tx.frame=CGRectMake(label2.frame.size.width+30, 65, Main_Screen_Width-label2.frame.size.width-40, 90);
    tx.layer.borderColor = [KGrayTextColor CGColor];
    tx.layer.borderWidth = 0.5;
    [tx.layer setMasksToBounds:YES];
    [cell.contentView addSubview:tx];
        //    cell.detailTextLabel.text=c.signTime;
        //    cell.

    return cell;
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section==0) {
    //        return 100;
    //    }else{
    return 164;
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
