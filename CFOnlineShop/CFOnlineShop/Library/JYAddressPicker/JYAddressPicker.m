//
//  JYAddressPicker.m
//  LakalaClient
//
//  Created by flying on 2018/8/17.
//  Copyright © 2018年 LR. All rights reserved.
//

#import "JYAddressPicker.h"

#define PickerHeight 180
#define PickerToolBarHeight 44

@interface JYAddressPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

//picker控件数据源
@property(nonatomic,strong)NSMutableArray *showAddressArr;
//picker控件默认展示的元素下标
@property(nonatomic,strong)NSMutableArray *showIndexs;

@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation JYAddressPicker


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];

    [self initUI];
    
    for (NSInteger index = 0; index < [self.showIndexs count]; index ++) {
        
        [self.pickerView selectRow:[[self.showIndexs objectAtIndex:index] integerValue] inComponent:index animated:NO];
    }
}

-(void)initUI{
    
    self.pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - (PickerHeight + PickerToolBarHeight), [UIScreen mainScreen].bounds.size.width, PickerHeight + PickerToolBarHeight)];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, PickerToolBarHeight)];
    toolBar.barTintColor = [UIColor whiteColor];

    UIBarButtonItem *noSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    noSpace.width=10;

    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];;
    doneBtn.tintColor = [UIColor grayColor];

    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    cancelBtn.tintColor = [UIColor grayColor];

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:noSpace,cancelBtn,flexSpace,doneBtn,noSpace, nil]];
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(0, 0, 200, PickerToolBarHeight);
    titleLabel.center = toolBar.center;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.text = @"省市区选择";
    [toolBar addSubview:titleLabel];

    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, PickerToolBarHeight, [UIScreen mainScreen].bounds.size.width, PickerHeight)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.backgroundColor = [UIColor whiteColor];

    [self.pickerContainerView addSubview:toolBar];
    [self.pickerContainerView addSubview:self.pickerView];
    [self.view addSubview:self.pickerContainerView];
}

#pragma mark-- UIPickerViewDataSource
//列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.showIndexs count];
}

//每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self.showAddressArr objectAtIndex:component] count];
}


#pragma mark-- UIPickerViewDelegate
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (id)view;
    if (!label)
    {
        label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        NSDictionary *dic = [[self.showAddressArr objectAtIndex:component] objectAtIndex:row];
        label.text = dic[@"text"];
    }
    return label;
}

//点击选择
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *columnItems = [self.showAddressArr objectAtIndex:component];
    NSDictionary *selectedItem = [columnItems objectAtIndex:row];
    
    if ([selectedItem[@"childrens"] count] == 0) {
        //此时为最后一列可能就一列或多列的最后一列
        [self.showIndexs replaceObjectAtIndex:component withObject:@(row)];
    }else{
        
        NSUInteger replaceIdx = component;
        BOOL next = true;
        while (next) {
            if (component == replaceIdx) {
                [self.showIndexs replaceObjectAtIndex:replaceIdx withObject:@(row)];
            }else{
                
                if (replaceIdx < [self.showIndexs count]) {
                    
                    [self.showAddressArr replaceObjectAtIndex:replaceIdx withObject:selectedItem[@"childrens"]];
                    [self.showIndexs replaceObjectAtIndex:replaceIdx withObject:@(0)];
                    selectedItem = [selectedItem[@"childrens"] firstObject];
                }else{
                    next = false;
                }
            }
            
            replaceIdx ++;
        }
        
    }
    [pickerView reloadAllComponents];
    //实时更新选择数据及联数据
    for (NSInteger index = 0; index < [self.showIndexs count]; index ++) {
        
        [self.pickerView selectRow:[[self.showIndexs objectAtIndex:index] integerValue] inComponent:index animated:NO];
    }
}


-(instancetype)initWith:(NSArray *)defaultValues{
    
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        self.showIndexs = [NSMutableArray array];
        self.showAddressArr = [NSMutableArray array];
        //加载本地json数据
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"citys" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:jsonPath];
        NSError *error = nil;
        NSArray *citysArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //初始化源数据
        [self defaultShowValue:[NSMutableArray arrayWithArray:defaultValues] items:citysArr];
        
    }
    return self;
}

+(JYAddressPicker *)jy_showAt:(UIViewController *)vc{
    
    JYAddressPicker *addressPicker = [[JYAddressPicker alloc] initWith:@[@"",@"",@""]];
    [vc presentViewController:addressPicker animated:YES completion:^{
        
    }];
    return addressPicker;
}

+(JYAddressPicker *)jy_showAt:(UIViewController *)vc defaultShow:(NSArray *)values{
    
    NSParameterAssert(values);
    JYAddressPicker *addressPicker = [[JYAddressPicker alloc] initWith:values];
    [vc presentViewController:addressPicker animated:YES completion:^{
        
    }];
    return addressPicker;
}

-(void)defaultShowValue:(NSMutableArray *)values items:(NSArray *)items
{
    [items enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([@"" isEqualToString:[values firstObject]])
        {
            //values中没有默认值的时候values中的元素目前为@""空字符
            [self.showIndexs addObject:@(0)];
            [values removeObjectAtIndex:0];
            [self.showAddressArr addObject:items];
            [self defaultShowValue:values items:obj[@"childrens"]];
            
        }
        else if ([obj[@"text"] isEqualToString:[values firstObject]])
        {
            [self.showIndexs addObject:@(idx)];
            [values removeObjectAtIndex:0];
            [self.showAddressArr addObject:items];
            [self defaultShowValue:values items:obj[@"childrens"]];
        }
    }];
}

#pragma mark--确定
-(void)done:(id)sender{

    if (self.selectedItemBlock) {
        NSMutableArray *resultArr = [NSMutableArray array];
        [self.showAddressArr enumerateObjectsUsingBlock:^(NSArray *objArr, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *selectedItem = [objArr objectAtIndex:[[self.showIndexs objectAtIndex:idx] integerValue]];
            [resultArr addObject:selectedItem];
        }];
        self.selectedItemBlock(resultArr);
    }
    [self hide];
}

#pragma mark--取消
-(void)cancel:(id)sender{

    [self hide];
}

-(void)hide{

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
