//
//  ConfirmationOrderController.m
//  51CBY
//
//  Created by SJB on 15/1/27.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "ConfirmationOrderController.h"
#import "SchemeCell.h"
#import "GoodsCell.h"
#import "ServiceCell.h"
#import "CheckoutController.h"
#import "AddressViewController.h"

#import "ManageAddressController.h"

#import "CbyUserSingleton.h"
#import "AFNetworking.h"
#import "AFNCommon.h"
#import "UIImageView+WebCache.h"

#define Width self.view.bounds.size.width
#define Height self.view.bounds.size.height

@interface ConfirmationOrderController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UIView *pkView;//弹出显示的picker试图
@property(strong, nonatomic) UIPickerView* picker;

@property (strong, nonatomic) UIButton *date;//选择日期按钮
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) UIButton *times;//选择时间按钮
@property (strong, nonatomic) NSArray *time;

@property (copy, nonatomic) NSString *dateString;
@property (copy, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSArray *dateTimeArray;

//数据源
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSMutableArray *allGoods;
@property (strong, nonatomic) NSMutableArray *numberArr;

@property (strong, nonatomic) CbyUserSingleton *dateInfo;

@property (strong, nonatomic) UIButton *tempbtn;
@property (nonatomic, copy) NSString *priceTotal;

@end

NSInteger dateTimeRow = 0;

@implementation ConfirmationOrderController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Navigation
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"提交订单";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

    [self showPicker];
    [self goodsinfo];
    [MBProgressHUD showMessage:@"请求数据中..." toView:self.view];
    
    _dateInfo = [CbyUserSingleton shareUserSingleton];
    
    //数据源
    _addressInfo = [NSMutableDictionary dictionary];
    _dates = [NSArray array];
    _time = [NSArray array];
    _dateTimeArray = [NSArray array];
    _dateString = [NSString string];
    _timeString = [NSString string];
    _keys = [NSArray array];
    _allGoods = [NSMutableArray array];
    _numberArr = [NSMutableArray array];
    
    
    NSString *strUrl = kShareUrl;
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"interfaceName":@"getconsigneeinfo",
                                @"user_id":self.dateInfo.userID,
                                @"operation":@"default"
                                };
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.addressInfo setObject:[responseObject objectForKey:@"data"] forKey:@"data"];
            [self personalInformation];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
#pragma mark - 商品总价
  

    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < self.shopCartlist.count; i++) {
        for (NSDictionary *dic in [self.shopCartlist[i] objectForKey:@"goods"]) {
            [arr addObject:[dic objectForKey:@"goods_price"]];
        }
        for (NSDictionary *dic in [self.shopCartlist[i] objectForKey:@"services"]) {
            [arr addObject:[dic objectForKey:@"goods_price"]];
        }
    }
    
    float num;
    for (int i = 0; i < arr.count; i++) {
        num += [arr[i] floatValue];
    }

    self.price.text = [NSString stringWithFormat:@"¥%.2f",num];
    self.priceTotal = [NSString stringWithFormat:@"%.2f",num];
}
#pragma mark - 弹出的地区选择器 pickerViewDelegate

-(void)showPicker
{
    //创建用于放置picker选择器的View视图
    self.pkView = [[UIView alloc]initWithFrame:CGRectMake(0, Height+250, Width, 250)];
    self.pkView.backgroundColor = [UIColor whiteColor];
    
    //创建picker选择器并设置其代理以及位置和大小
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, Width, 190)];
    
    //代理
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor whiteColor];
    
    //建立一个button并设置其样式
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //设置其位置和大小
    btn.frame = CGRectMake(Width-65, 5, 60, 40);
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pkView addSubview:btn];
    
    [self.pkView addSubview:self.picker];
    
    [self.view addSubview:self.pkView];
}

#pragma mark - 请求服务的日期
-(void)personalInformation
{
    if ([[self.addressInfo objectForKey:@"data"]count]) {
        [MBProgressHUD showMessage:@"请求数据中..." toView:self.view];
        NSString *strUrl = kShareUrl;
        NSString *province = @"021";
        NSString *city = [[self.addressInfo objectForKey:@"data"] objectForKey:@"city"];
        NSString *district = [[self.addressInfo objectForKey:@"data"] objectForKey:@"district"];
        //请求服务时间
        AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameter = @{@"interfaceName":@"getservicedate",
                                    @"province":province,
                                    @"city":city,
                                    @"district":district
                                    };
        
        [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                self.dates = [responseObject objectForKey:@"data"];
                
                [self.tableView reloadData];
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"error %@",error);
            
        }];

        
    }else{
        return;
    }
    
}

#pragma mark - Table view data source

int count1;
int count2;
int num;//累加用
-(void)goodsinfo
{
    count2 = 0;
    
    for (int i = 0; i < self.shopCartlist.count; i++) {
        count1 = 0;
        
        for (NSDictionary *dic in [self.shopCartlist[i] objectForKey:@"services"]) {
            
            [self.allGoods addObject:dic];
            count1++;
        }
        
        for (NSDictionary *dic in [self.shopCartlist[i] objectForKey:@"goods"]) {
            
            [self.allGoods addObject:dic];
            count1++;
        }
        
        count2 = count1;
        
        [self.numberArr addObject:[NSNumber numberWithInt:count2]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.shopCartlist.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return ([[self.shopCartlist[section] objectForKey:@"services"] count] + [[self.shopCartlist[section] objectForKey:@"goods"] count]);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"SchemeCell";
    static NSString *identify = @"GoodsCell";
    static NSString *ident = @"ServiceCell";
    
    
    
    if (indexPath.row < [[self.shopCartlist[indexPath.section] objectForKey:@"services"] count]) {
        if (indexPath.row == 0) {//第0个带有服务字样的label
            ServiceCell *cell = (ServiceCell*)[tableView dequeueReusableCellWithIdentifier:ident];
            
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ServiceCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kImageUrl,[[self.shopCartlist[indexPath.section] objectForKey:@"services"][0] objectForKey:@"original_img"]]];
            [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
            
            cell.name.text = [[self.shopCartlist[indexPath.section] objectForKey:@"services"][0] objectForKey:@"goods_name"];
            cell.name.font = [UIFont systemFontOfSize: 15.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else {//之后的不带服务字样的服务内容
            SchemeCell *cell = (SchemeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
            
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SchemeCell" owner:self options:nil];//加载自定义cell的xib文件
                cell = [array objectAtIndex:0];
            }
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kImageUrl,[[self.shopCartlist[indexPath.section] objectForKey:@"services"][indexPath.row] objectForKey:@"original_img"]]];
            [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
            
            cell.name.text = [[self.shopCartlist[indexPath.section] objectForKey:@"services"][indexPath.row] objectForKey:@"goods_name"];
            

              cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (indexPath.row == [[self.shopCartlist[indexPath.section] objectForKey:@"services"] count]) {//商品的第一个cell
        
        GoodsCell *cell = (GoodsCell*)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GoodsCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kImageUrl,[[self.shopCartlist[indexPath.section] objectForKey:@"goods"][0] objectForKey:@"original_img"]]];
        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
        
        cell.name.text = [NSString stringWithFormat:@"%@(%@个)" ,[[self.shopCartlist[indexPath.section] objectForKey:@"goods"][0] objectForKey:@"goods_name"],[[self.shopCartlist[indexPath.section] objectForKey:@"goods"][0] objectForKey:@"goods_name"] ];
        

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        
        SchemeCell *cell = (SchemeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
        
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SchemeCell" owner:self options:nil];//加载自定义cell的xib文件
            cell = [array objectAtIndex:0];
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kImageUrl,[[self.shopCartlist[indexPath.section] objectForKey:@"goods"][indexPath.row-[[self.shopCartlist[indexPath.section] objectForKey:@"services"] count]] objectForKey:@"original_img"]]];
        
        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
        
        cell.name.text = [NSString stringWithFormat:@"%@(%@个)" ,[[self.shopCartlist[indexPath.section] objectForKey:@"goods"][indexPath.row-[[self.shopCartlist[indexPath.section] objectForKey:@"services"] count]] objectForKey:@"goods_name"],[[self.shopCartlist[indexPath.section] objectForKey:@"goods"][indexPath.row-[[self.shopCartlist[indexPath.section] objectForKey:@"services"] count]] objectForKey:@"goods_number"]];   // ！！！这里取值的序数，[indexPath.row-[[self.ShopCartlist[indexPath.section] objectForKey:@"services"] count]]，要用好。解决了由于写死而显示不正常的问题
        
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
}

//设置Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *serviceArr = [NSMutableArray array];
    
    for (NSDictionary *dic in [self.shopCartlist[indexPath.section] objectForKey:@"services"]) {
        [serviceArr addObject:dic];
    }
    
    if (indexPath.row == 0) {
        return 130;
    }
    if (indexPath.row == (int)serviceArr.count) {
        return 130;
    }
    return 88;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *information = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 70, 20)];
        information.text = @"收货信息";
        information.font = [UIFont systemFontOfSize:16.0];
        [view addSubview:information];
        
        UILabel *consignee = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(information.frame)+10, 50, 15)];
        consignee.text = @"收货人: ";
        consignee.textColor = [UIColor grayColor];
        consignee.font = [UIFont systemFontOfSize:14.0];
        [view addSubview:consignee];
        
        UILabel *deliveryAddress = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(consignee.frame)+10, 65, 15)];
        deliveryAddress.text = @"收货地址: ";
        deliveryAddress.textColor = [UIColor grayColor];
        deliveryAddress.font = [UIFont systemFontOfSize:14.0];
        [view addSubview:deliveryAddress];
        
        UIButton *address = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(deliveryAddress.frame)+15, 100, 30)];
        [address setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [address setTitle:@"+使用新地址" forState:UIControlStateNormal];
        [address addTarget:self action:@selector(address) forControlEvents:UIControlEventTouchUpInside];
        
        address.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [view addSubview:address];

//        UILabel *serviceTime = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(address.frame)+10, 120, 20)];
//        serviceTime.text = @"上门服务时间: ";
//        serviceTime.font = [UIFont systemFontOfSize:16.0];
//        serviceTime.textColor = [UIColor orangeColor];
//        [view addSubview:serviceTime];
        
#pragma mark - 显示收货人的信息
     
        NSString *nameStr = [NSString stringWithFormat:@"%@  %@",[[self.addressInfo objectForKey:@"data"] objectForKey:@"consignee"],[[self.addressInfo objectForKey:@"data"] objectForKey:@"mobile"]];
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(consignee.frame)+10, CGRectGetMaxY(information.frame)+10, 200, 15)];
        name.textColor = [UIColor grayColor];
        name.font = [UIFont systemFontOfSize:14.0];
        name.text = nameStr;
        [view addSubview:name];

        NSString *cityStr = [NSString stringWithFormat:@"%@ %@ %@ %@",[[self.addressInfo objectForKey:@"data"] objectForKey:@"province_name"],[[self.addressInfo objectForKey:@"data"] objectForKey:@"city_name"],[[self.addressInfo objectForKey:@"data"] objectForKey:@"district_name"],[[self.addressInfo objectForKey:@"data"] objectForKey:@"address"]];
        UILabel *city = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(deliveryAddress.frame), CGRectGetMaxY(consignee.frame)+10, 300, 15)];
        city.text = cityStr;
        city.textColor = [UIColor grayColor];
        city.font = [UIFont systemFontOfSize:14.0];
        [view addSubview:city];
        
#pragma mark - 选择上门服务时间
        _date = [[UIButton alloc]initWithFrame:CGRectMake((self.tableView.frame.size.width-250)*0.5, CGRectGetMaxY(address.frame)+5, 120, 30)];
        self.date.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.date.backgroundColor = [UIColor grayColor];
        self.date.tag = 10;
        
        [self.date addTarget:self action:@selector(hiddens:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.dateInfo.serviceDate.length > 0) {
            [self.date setTitle:self.dateInfo.serviceDate forState:UIControlStateNormal];
        }else {
            NSString *string = @"请选择服务日期";
            [self.date setTitle:string forState:UIControlStateNormal];
        }
        
        [view addSubview:self.date];
        
        _times = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.date.frame)+10, CGRectGetMaxY(address.frame)+5, 120, 30)];
        self.times.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.times.backgroundColor = [UIColor grayColor];
        self.times.tag = 20;
        
        [self.times addTarget:self action:@selector(hiddens:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.dateInfo.hourTime.length > 0) {
            [self.times setTitle:self.dateInfo.hourTime forState:UIControlStateNormal];
        }else {
             NSString *str1 = @"请选择服务时间";
            [self.times setTitle:str1 forState:UIControlStateNormal];
        }
       
        
        [view addSubview:self.times];

        UIView *carView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.date.frame)+5, self.view.frame.size.width, 40)];
        carView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
        [view addSubview:carView];
        
        UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.date.frame)+10, 195, 30)];
        //车型名称
        carName.text = [NSString stringWithFormat:@"%@ %@ %@ %@",[[self.shopCartlist[0] objectForKey:@"carinfo"] objectForKey:@"brand_name"],[[self.shopCartlist[0] objectForKey:@"carinfo"] objectForKey:@"type_name"],[[self.shopCartlist[0] objectForKey:@"carinfo"] objectForKey:@"engines"],[[self.shopCartlist[0] objectForKey:@"carinfo"] objectForKey:@"builddate"]];
                
        carName.font = [UIFont systemFontOfSize:15.0];
        carName.textColor = [UIColor blackColor];
        [view addSubview:carName];
     
        return view;
        
    }else {

        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
        
        UIView *carView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
        carView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
                
        [headerView addSubview:carView];
                
        
        //车型名称

        UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 195, 30)];
        carName.text = [NSString stringWithFormat:@"%@ %@ %@ %@",[[self.shopCartlist[section] objectForKey:@"carinfo"] objectForKey:@"brand_name"],[[self.shopCartlist[section] objectForKey:@"carinfo"] objectForKey:@"type_name"],[[self.shopCartlist[section] objectForKey:@"carinfo"] objectForKey:@"engines"],[[self.shopCartlist[section] objectForKey:@"carinfo"] objectForKey:@"builddate"]];
        carName.font = [UIFont systemFontOfSize:15.0];
        carName.textColor = [UIColor blackColor];
        [headerView addSubview:carName];

        return headerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 205;
    }
    return 40;
}


#pragma mark =====取消选中Cell的高亮状态
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - 使用新地址
-(void)address
{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    if (![self.dateInfo.userID isEqualToString:@"0"]) {
        
        ManageAddressController *addressManager = [[ManageAddressController alloc]init];
        addressManager.changeFlag = 1;
        [addressManager returnMyNewAddress:^(NSDictionary *newAddress) {
            
            
            [self.addressInfo setObject:newAddress forKey:@"data"];
            [self personalInformation];
            [self.tableView reloadData];
        }];
        
        [self.navigationController pushViewController:addressManager animated:YES];
    }else{
        
        AddressViewController *addressVC = [[AddressViewController alloc]init];
        addressVC.title = @"添加地址";
//        if (self.dateInfo.isLogin) {
//            [addressVC returnNewAddressInfo:^(NSDictionary *dic) {
//                
//                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[self.addressInfo objectForKey:@"data"]];
//                [tempDic setObject:dic forKey:@"data"];
//                [self.tableView reloadData];
//                
//            }];
//        }else{
            [addressVC returnNewAddressInfo:^(NSDictionary *dic) {
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.addressInfo];
                [tempDic setObject:dic forKey:@"data"];
                self.addressInfo = tempDic;
                [self.tableView reloadData];
                [self personalInformation];// 请求服务日期
            }];
        
        [self.navigationController pushViewController:addressVC animated:YES];
        //}
        
    
        
    }
    
    
    
    
}

#pragma  mark - 选择日期和选择时间的事件
-(void)hiddens:(UIButton *)sender
{

    self.tempbtn = sender;
    if (sender.tag == 10) {
        
        self.dateTimeArray = self.dates;
        [self.picker reloadAllComponents];
        self.pkView.frame = CGRectMake(0, Height-250, Width, 250);
    }else{
        
        self.dateTimeArray = self.time;
        [self.picker reloadAllComponents];
        self.pkView.frame = CGRectMake(0, Height-250, Width, 250);
        
    }
    
}

//picker选择好后 确认，把pickerView坐标改变
-(void)hidden
{
    self.pkView.frame = CGRectMake(0, Height+100, Width, 250);
    
    if (self.tempbtn.tag == 10) {
        if (self.dates.count) {
            [self.date setTitle:self.dates[dateTimeRow] forState:UIControlStateNormal];
            self.dateInfo.serviceDate = self.dates[dateTimeRow];
            [MBProgressHUD showMessage:@"请求数据中..." toView:self.view];
            NSString *strUrl = kShareUrl;
            NSString *province = @"021";
            NSString *city = [[self.addressInfo objectForKey:@"data"] objectForKey:@"city"];
            NSString *district = [[self.addressInfo objectForKey:@"data"] objectForKey:@"district"];
            NSString *date = self.dates[dateTimeRow];
            //请求服务时间
            AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameter = @{@"interfaceName":@"getservicetime",
                                        @"province":province,
                                        @"city":city,
                                        @"district":district,
                                        @"date":date
                                        };
            [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    self.time = [responseObject objectForKey:@"data"];;
                    
                    [self.picker reloadAllComponents];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"error %@",error);
                
            }];
            
        }
    }else {
        if (self.time.count) {
            [self.times setTitle:self.time[dateTimeRow] forState:UIControlStateNormal];
            self.dateInfo.hourTime = self.time[dateTimeRow];
        }
        
        
    }

    
}
#pragma mark ==============选择器代理方法==============
//设置有几列picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//设置行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return [self.dateTimeArray count];

}
//设置picker列里面显示的数据源
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.dateTimeArray objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    dateTimeRow = row;
}

//#pragma mark - 删除该车型全部信息
//- (void)deletesGoods:(UIButton *)sender {
//    
//    [self.shopCartlist removeObject:self.shopCartlist[sender.tag]];
//    [self.tableView reloadData];
//}



#pragma mark - 提交订单
- (IBAction)SubmitOrders:(id)sender {

    
    
    NSMutableArray *allGoods = [NSMutableArray array];
    
    if (![self.date.titleLabel.text  isEqual: @"请选择服务日期"] && ![self.times.titleLabel.text  isEqual: @"请选择服务时间"]) {
        
        [MBProgressHUD showMessage
         :@"正在提交订单,请稍后..." toView:self.view];
        
        for (NSDictionary *dic in self.shopCartlist) {
            
            NSDictionary *goods = [NSDictionary dictionary];
            
            for (NSDictionary *good in [dic objectForKey:@"goods"]) {
                
                goods = @{@"goods_id":[good objectForKey:@"goods_id"],
                         @"goods_number":[good objectForKey:@"goods_number"],
                         @"car_id":[good objectForKey:@"car_id"]};
                
                [allGoods addObject:goods];

            }
            
            for (NSDictionary *good in [dic objectForKey:@"services"]) {
                
                goods = @{@"goods_id":[good objectForKey:@"goods_id"],
                          @"goods_number":[good objectForKey:@"goods_number"],
                          @"car_id":[good objectForKey:@"car_id"]};
                
                [allGoods addObject:goods];
            }
        }
        
        NSString*strUrl = kOrderUrl;
        AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameter = @{@"interfaceName":@"putOrderNoCart",
                                    @"user_id":self.dateInfo.userID,
                                    @"province":@"021",
                                    @"city":[[self.addressInfo objectForKey:@"data"] objectForKey:@"city"],
                                    @"district":[[self.addressInfo objectForKey:@"data"] objectForKey:@"district"],
                                    @"address":[[self.addressInfo objectForKey:@"data"] objectForKey:@"address"],
                                    @"serviceDate":self.dateInfo.serviceDate,
                                    @"serviceTime":self.dateInfo.hourTime,
                                    @"consigneeName":[[self.addressInfo objectForKey:@"data"] objectForKey:@"consignee"],
                                    @"mobile":[[self.addressInfo objectForKey:@"data"] objectForKey:@"mobile"],
                                    @"shipping_id":@"1",
                                    @"goods_info":allGoods};
        
        [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                
                
                
                
                CheckoutController *checkoutVC = [[CheckoutController alloc] init];
                checkoutVC.orderCode = [responseObject objectForKey:@"order_id"];
                checkoutVC.orderDescription = [NSString stringWithFormat:@"%@ %@ %@ %@",[[self.shopCartlist[0] objectForKey:@"carinfo"] objectForKey:@"brand_name"],[[self.shopCartlist[0] objectForKey:@"carinfo"] objectForKey:@"type_name"],[[self.shopCartlist[0] objectForKey:@"carinfo"] objectForKey:@"engines"],[[self.shopCartlist[0] objectForKey:@"carinfo"] objectForKey:@"builddate"]];
                [self.navigationController pushViewController:checkoutVC animated:YES];
                checkoutVC.finalPrice = self.priceTotal;
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"恭喜您，订单提交成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];

            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单提交未成功！请稍候再试！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"error %@",error);
            
        }];

        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示～" message:@"请您先选择服务日期和时间后再试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

@end
