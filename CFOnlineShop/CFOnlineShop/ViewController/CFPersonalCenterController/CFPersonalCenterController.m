//
//  CFPersonalCenterController.m
//  CFOnlineShop
//
//  Created by 俞渊华 on 2018/7/18.
//  Copyright © 2018年 俞渊华. All rights reserved.
//

#import "CFPersonalCenterController.h"
#import "DCLoginViewController.h"
#import "OrderController.h"
#import "MyPointController.h"
#import "MyFavController.h"
#import "MyFootController.h"
#import "MySettingController.h"
#import "MMZCViewController.h"
@interface CFPersonalCenterController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *bgImageView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *myTitles;
@property (nonatomic, strong) NSArray *myIcons;

@end

@implementation CFPersonalCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"我的"];
    _myTitles = @[@"绑定手机号",@"全部订单",@"我的积分",@"我的足迹",@"我的收藏",@"我的消息",@"设置",@"退出"];
    _myIcons = @[@"icon_my_01",@"icon_my_02",@"icon_my_03",@"icon_my_04",@"icon_my_05",@"icon_my_06",@"icon_my_07",@"icon_my_07"];

    self.navigationView.backgroundColor = kWhiteColor;
    [self setUI];
}

- (void)setUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height - TopHeight - TabbarHeight)];
    _tableView.backgroundColor = kWhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);//使table上面空出200空白
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,-200, Main_Screen_Width, 200)];

    //bgImageView.contentMode = UIViewContentModeScaleAspectFill;//添加了这个属性表示等比例缩放，否则只缩放高度
    bgImageView.image = [self createImageWithColor:RGBCOLOR(250, 107, 69)];
    [_tableView addSubview:bgImageView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-30, -130, 60, 60)];
    imageView.image = [UIImage imageNamed:@"user_image"];
    imageView.backgroundColor = kWhiteColor;
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped)];
    [imageView addGestureRecognizer:tapGesture];
    imageView.userInteractionEnabled=YES;
    [_tableView addSubview:imageView];
    
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 30;
    imageView.layer.borderColor = KLineGrayColor.CGColor;
    imageView.layer.borderWidth = 1;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-50, -40, 100, 20)];
    label.backgroundColor = kWhiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = KDarkTextColor;
    label.font = SYSTEMFONT(16);
    label.text = @"黄金脆皮鱼";
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if ([userd objectForKey:@"phone"]) {
        label.text=[userd objectForKey:@"phone"];
    }
    [_tableView addSubview:label];
    
}
-(void)menuTapped
{
//    DCLoginViewController* login=[DCLoginViewController new];
    MMZCViewController *login=[[MMZCViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark -- UITableViewDelegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    else
    {
    return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0&&indexPath.section==0) {
        return 80;
    }
    else
    {
    return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell.imageView setImage:[UIImage imageNamed:[_myIcons objectAtIndex:indexPath.row]]];
    cell.textLabel.font = SYSTEMFONT(18);
    cell.textLabel.textColor = KDarkTextColor;
    cell.textLabel.text = [_myTitles objectAtIndex:indexPath.row];
    if (indexPath.section==1) {
        cell.textLabel.text = [_myTitles objectAtIndex:indexPath.row+5];
        [cell.imageView setImage:[UIImage imageNamed:[_myIcons objectAtIndex:indexPath.row+5]]];
    }
    if (indexPath.row==0&&indexPath.section==0) {
        cell.detailTextLabel.text=@"绑定手机号可更好的让我们服务好您!";
        cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    }
    //调整cell.imageView大小
    CGSize itemSize = CGSizeMake(25, 25);//希望显示的大小
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}
//设置分区头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
//设置分区的头视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {

    if (indexPath.row==1) {
        OrderController* o=[OrderController new];
        [self.navigationController pushViewController:o animated:YES];
    }
    if (indexPath.row==2) {
        MyPointController* o=[MyPointController new];
        [self.navigationController pushViewController:o animated:YES];
    }
    if (indexPath.row==3) {
        MyFootController* o=[MyFootController new];
        [self.navigationController pushViewController:o animated:YES];
    }
    if (indexPath.row==4) {
        MyFavController* o=[MyFavController new];
        [self.navigationController pushViewController:o animated:YES];
    }
    }
    if (indexPath.section==1&&indexPath.row==1) {
        MySettingController* o=[MySettingController new];
        [self.navigationController pushViewController:o animated:YES];
    }
    if (indexPath.section==1&&indexPath.row==2) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:@"openid"];
        [user synchronize];
        [MySingleton sharedMySingleton].openId=nil;
        [self.tabBarController setSelectedIndex:0];

    }
}

#pragma mark - UIScrollViewDelegate

//scrollView的方法视图滑动时 实时调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"%lf",offset.y);
    //偏移从-200开始
    if (offset.y < -200) {
        bgImageView.mj_y = offset.y;
        bgImageView.mj_h = ABS(offset.y);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//UIColor 转UIImage（UIImage+YYAdd.m也是这种实现）
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
