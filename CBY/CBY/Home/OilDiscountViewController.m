//
//  OilDiscountViewController.m
//  51CBY
//
//  Created by SJB on 14/12/25.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "OilDiscountViewController.h"
#import "DiscountTableViewCell.h"
#import "HomeViewController.h"
#import "AFNetworking.h"
#import "AFNCommon.h"
#import "UIImageView+WebCache.h"
#import "CbyUserSingleton.h"
#import "LoginViewController.h"
#import "OilDetailInfoTableViewController.h"
#import "LoginViewController.h"


#define Width self.view.bounds.size.width
#define Height self.view.bounds.size.height

//返回数据的参数
#define kImgName      @"station_img"
#define kTitle        @"station_name"
#define kDetailTitle  @"promote_content"
#define kValidTime    @"promote_end"
#define kDistribute   @"city_name"
#define kprice        @"promote_money"//
#define promoteId     @"promote_id"
#define kFlag         @"focus_status"

//地址
#define kRegionName   @"region_name"
#define kRegionID     @"region_id"

typedef NS_ENUM(NSInteger, FILTERCONDITION) {
    
    DEFAULTCONDITION = 1,
  
    FOCUSCONDITION
   
};

@interface OilDiscountViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) UITableView  *tableView;
@property(nonatomic, strong) NSMutableArray *arr; //总的数据源
@property(nonatomic, strong) NSMutableArray *attentionArr;
@property(nonatomic, strong) UISegmentedControl *segment;

@property(nonatomic, strong) UIView *pickerBackViewOil;
@property(nonatomic, strong) UIPickerView  *pickerViewOil;
@property(nonatomic, strong) UIButton *cityBtnOil;
@property(nonatomic, strong) UIButton *plateBtnOil;
@property(nonatomic, strong) UIButton *streetBtnOil;
@property(nonatomic, strong) UIButton *oilStationBtnOil;
@property(nonatomic, strong) UIButton *totleBtnOil;//显示全部数据的按钮

@property(nonatomic,strong) NSArray *cityArrOil;
@property(nonatomic,strong) NSMutableArray *plateArrOil;
@property(nonatomic,strong) NSMutableArray *plateIDArr;
@property(nonatomic,strong) NSMutableArray *streetArrOil;
@property(nonatomic,strong) NSMutableArray *streetIDarr;
@property(nonatomic,strong) NSMutableArray *stationArrOil;
@property(nonatomic,strong) NSMutableArray *stationIDArr;
@property(nonatomic,copy)   NSString *plateID;
@property(nonatomic,copy)   NSString *regionID;
@property(nonatomic, assign) int stationType;



//用户信息
@property(nonatomic,strong) CbyUserSingleton *userOilInfo;

//请求下来的数据
@property(nonatomic,strong) NSMutableArray  *dataArrM;//默认列表，价格排序
@property(nonatomic,strong) NSMutableArray  *distributeArrM;//板块排序
@property(nonatomic,strong) NSMutableArray  *focusArrM;//关注

@end
BOOL isShow = NO;
BOOL isSelect = NO;
NSInteger oilFilterFlag;
static NSString *identifier = @"cellID";
@implementation OilDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*navigation*/
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"加油优惠";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
    
    /*右视图*/
    UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [selectButton setTitle:@"筛选" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectDistribute:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:selectButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    //userInfo
    _userOilInfo = [CbyUserSingleton shareUserSingleton];
    
    
    /*数据源*/
       _arr = [NSMutableArray array];
       _dataArrM = [NSMutableArray array];//接收存放的数据
    _distributeArrM = [NSMutableArray array];
    _focusArrM = [NSMutableArray array];
 
    
    self.attentionArr = [NSMutableArray array];
    
    
    /*筛选数据*/
    
    _cityArrOil = [NSArray array];
    _plateArrOil = [NSMutableArray array];
    _plateIDArr = [NSMutableArray array];
    _streetArrOil = [NSMutableArray array];
    _streetIDarr = [NSMutableArray array];
    _stationArrOil = [NSMutableArray array];
    _stationIDArr = [NSMutableArray array];
    
    //初始化字符串
    self.plateID = [[NSString alloc]init];
    self.regionID = [[NSString alloc]init];
    
    //请求地址数据
    self.cityArrOil = @[@"上海"];
    [self obtainRegionInfo];
    
    //请求加油站信息
    [self obtainOilStation];
    
    //获取加油优惠列表
    [self obtainOilDiscountDataList];

    /*tableView*/
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    
    //segment
    _segment = [[UISegmentedControl alloc]initWithItems:@[@"列表",@"关注"]];
    self.segment.tintColor = [UIColor whiteColor];
     [self.segment addTarget:self action:@selector(selectInfo:) forControlEvents:UIControlEventValueChanged];
   // self.segment.momentary = YES;//显示一会后颜色消
    self.segment.selectedSegmentIndex=0;
    
    [self.segment setBackgroundImage:[UIImage imageNamed:@"浅蓝.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segment setBackgroundImage:[UIImage imageNamed:@"深蓝.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    NSDictionary *selectedAtt  = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    
    [self.segment setTitleTextAttributes:selectedAtt forState:UIControlStateSelected];
    
    //筛选view
    _pickerBackViewOil = [[UIView alloc]init];
    self.pickerBackViewOil.frame = CGRectMake(0, -Height, Width, Height);
    self.pickerBackViewOil.backgroundColor = [UIColor cyanColor];
    [self pickBackViewCreat];
    [self.view addSubview:self.pickerBackViewOil];
    
    oilFilterFlag = DEFAULTCONDITION;
    
    //上下拉刷新
    //上拉刷新
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(refreshMoreDataOilInfo)];

    self.tableView.footer.stateHidden = YES;
    self.tableView.footer.automaticallyRefresh = NO;
    // 设置文字
    [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"加载更多 ..." forState:MJRefreshFooterStateRefreshing];
    
    // 设置字体
    self.tableView.footer.font = [UIFont systemFontOfSize:17];
   
    
}





//创建筛选的视图
-(void)pickBackViewCreat
{
    /*pickerView的背景试图和pickerview*/
    
    
    CGFloat kMargin = Width*0.02;
    
    
    _cityBtnOil = [self buttonWithFrame:CGRectMake(5, 20, Width*0.18, 40) title:@"上海" backImage:@"pickButton"];
    
    
    _plateBtnOil = [self buttonWithFrame:CGRectMake(CGRectGetMaxX(self.cityBtnOil.frame)+kMargin, CGRectGetMinY(self.cityBtnOil.frame),Width*0.18, 40) title:@"区域" backImage:@"pickButton"];
    
    
    _streetBtnOil = [self buttonWithFrame:CGRectMake(CGRectGetMaxX(self.plateBtnOil.frame)+kMargin,  CGRectGetMinY(self.cityBtnOil.frame), Width*0.18, 40)  title:@"板块" backImage:@"pickButton"];
    
    _oilStationBtnOil = [self buttonWithFrame:CGRectMake(CGRectGetMaxX(self.streetBtnOil.frame)+kMargin, CGRectGetMinY(self.cityBtnOil.frame), Width*0.18, 40) title:@"加油站" backImage:@"pickButton"];
    _totleBtnOil = [self buttonWithFrame:CGRectMake(CGRectGetMaxX(self.oilStationBtnOil.frame)+kMargin, CGRectGetMinY(self.cityBtnOil.frame), Width*0.18, 40) title:@"全部" backImage:@"pickButton"];
    [self.totleBtnOil addTarget:self action:@selector(filterCondition:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.cityBtnOil.frame)+kMargin, Width*0.18, 40)];
    label.text = @"油类";
    label.textColor = [UIColor darkGrayColor];
    [self.pickerBackViewOil addSubview:label];
    
    UIButton *btn92 = [self buttonWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMinY(label.frame), Width*0.18, 40) title:@"92#" backImage:@"bg"];//这个背景需要换
    btn92.tag = 92;
    [btn92 addTarget:self action:@selector(differentOilFilter:) forControlEvents:UIControlEventTouchDown];
    UIButton *btn95 = [self buttonWithFrame:CGRectMake(CGRectGetMaxX(btn92.frame)+kMargin, CGRectGetMinY(label.frame), Width*0.18, 40) title:@"95#" backImage:@"bg"];
    btn95.tag = 95;
    [btn95 addTarget:self action:@selector(differentOilFilter:) forControlEvents:UIControlEventTouchDown];
    UIButton *btn = [self buttonWithFrame:CGRectMake(CGRectGetMaxX(btn95.frame)+kMargin, CGRectGetMinY(label.frame), Width*0.18, 40) title:@"柴油" backImage:@"bg"];
    btn.tag = 98;
    [btn addTarget:self action:@selector(differentOilFilter:) forControlEvents:UIControlEventTouchDown];
    UIButton *makeSureBtn = [self buttonWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+kMargin, CGRectGetMinY(label.frame), Width*0.18, 40) title:@"确定" backImage:@"bg"];
    [makeSureBtn addTarget:self action:@selector(makeSureCommit:) forControlEvents:UIControlEventTouchUpInside];
    
    //pickerView
    _pickerViewOil = [[UIPickerView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(btn.frame)+20, Width-80,60)];
    self.pickerViewOil.delegate = self;
    self.pickerViewOil.dataSource = self;
    [self.pickerBackViewOil addSubview:self.pickerViewOil];
    
    
    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"DiscountTableViewCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        
    }
    NSString *imgStr = [NSString stringWithFormat:@"%@",[self.arr[indexPath.row] objectForKey:kImgName]];
    
    NSURL *imgUrl = [NSURL URLWithString:imgStr];
    [cell.leftImgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
    cell.titleLabel.text = [self.arr[indexPath.row] objectForKey:kTitle];
    cell.detailTitleLabel.text = [self.arr[indexPath.row] objectForKey:kDetailTitle];
    
    cell.validTime.text = [NSString stringWithFormat:@"%@截止",[self.arr[indexPath.row]objectForKey:kValidTime]];
    [cell.distributeBtn setTitle:[self.arr[indexPath.row] objectForKey:kDistribute] forState:UIControlStateNormal];
    
    NSString *titleStr = [NSString stringWithFormat:@"￥%@",[self.arr[indexPath.row] objectForKey:kprice]];
        [cell.priceBtn setTitle:titleStr forState:UIControlStateNormal] ;

        [cell.focusBtn addTarget:self action:@selector(payAttention:) forControlEvents:UIControlEventTouchUpInside];
        cell.focusBtn.tag = indexPath.row;
    
    if ([[self.arr[indexPath.row] valueForKey:kFlag] isEqualToString:@"0"]) {
        [cell.focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    }else{
        [cell.focusBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc]init];
    backView.frame = CGRectMake(0, 0, Width, 40);
    backView.backgroundColor = [UIColor whiteColor];
    self.segment.frame = CGRectMake(0, 0, Width, 40);
    
    [backView addSubview:self.segment];

    return backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OilDetailInfoTableViewController *detailOilVC = [[OilDetailInfoTableViewController alloc]init];
    detailOilVC.promte = [self.arr[indexPath.row] objectForKey:@"promote_id"];
    detailOilVC.loopFlag = @"1";
    /*navigation*/
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = [self.arr[indexPath.row] objectForKey:kTitle];
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    detailOilVC.navigationItem.titleView = textlabel;
    
    detailOilVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailOilVC animated:YES];
}

#pragma mark -- pick delegate/datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.cityArrOil.count;
    }else if (component == 1){
        return self.plateArrOil.count;
    }else if (component == 2){
        return self.streetArrOil.count;
    }else{
        return self.stationArrOil.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        
        return self.cityArrOil[row];
    }else if (component == 1){
        return  self.plateArrOil[row];
    }else if (component == 2){
        return self.streetArrOil[row];
    }else{
        
        return self.stationArrOil[row];
    }
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0) {
        [self.cityBtnOil setTitle:self.cityArrOil[row] forState:UIControlStateNormal];
        
    }else if (component == 1){
        [self.plateBtnOil setTitle:self.plateArrOil[row] forState:UIControlStateNormal];
        self.regionID = self.plateIDArr[row];
        [self obtainPlateInfoWithRow:row];
    }else if (component == 2){
        [self.streetBtnOil setTitle:self.streetArrOil[row] forState:UIControlStateNormal];
        self.plateID = self.streetIDarr[row];
    }else{
        
        [self.oilStationBtnOil setTitle:self.stationArrOil[row] forState:UIControlStateNormal];
    }
}


//设置pickview的字体
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (!label) {
        if (component == 2) {
            label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.pickerViewOil.bounds.size.width*0.3, 30)];
            label.font = [UIFont systemFontOfSize:12.0f];
        }else{
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.pickerViewOil.bounds.size.width*0.2, 30)];
            label.font = [UIFont systemFontOfSize:13.0f];
        }
        
        
        label.text = [self pickerView:self.pickerViewOil titleForRow:row forComponent:component];
    }
    
    
    return label;
}



#pragma mark -- target - action
-(void)selectDistribute:(UIButton *)sender
{
    isSelect = !isSelect;
    if (isSelect) {
        self.pickerBackViewOil.frame = CGRectMake(0, 50, Width, Height);
    }else{
        
        self.pickerBackViewOil.frame = CGRectMake(0, -Height, Width, Height);
    }
    

}

-(void)makeSureCommit:(UIButton *)sender
{
    //提交服务器，并请求数据
    [MBProgressHUD showMessage:@"正在加载。。。" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
    NSDictionary *parameter = @{kInterfaceName:@"filter",
                                @"infoNumber":@"0",
                                @"province_id":@"021",
                                @"city_id":self.regionID,
                                @"plate_id":self.plateID,
                                @"user_id":self.self.userOilInfo.userID};
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.arr removeAllObjects];
            [self.dataArrM removeAllObjects];
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                [self.arr removeAllObjects];
                for (NSDictionary *dic in [responseObject objectForKey:@"data"] ) {
                    [self.dataArrM addObject:dic];
                }
                
                self.arr = self.dataArrM;
                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }

            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    //隐藏pickerViewBack
    self.pickerBackViewOil.frame = CGRectMake(0, -Height, Width, Height);
}

//按下全部那个按钮时请求数据
-(void)filterCondition:(UIButton *)sender
{
    oilFilterFlag = DEFAULTCONDITION;
    [self obtainOilDiscountDataList];
    self.segment.selectedSegmentIndex = 0;
    self.pickerBackViewOil.frame = CGRectMake(0, -Height, Width, Height);
}

#pragma mark - 获取加油优惠列表,请求数据
-(void)obtainOilDiscountDataList
{
    
    
    //获取加油默认列表
    AFHTTPRequestOperationManager *oilManager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{kInterfaceName : @"getList",
                                @"infoNumber":@"0",
                                @"user_id":self.userOilInfo.userID};
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
    
    [oilManager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            [self.arr removeAllObjects];
            [self.dataArrM removeAllObjects];
            self.userOilInfo.oilHistoryTime = [responseObject objectForKey:@"historyTime"];
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                [self.dataArrM addObject:dic];
            }
            
            self.arr = self.dataArrM;
            [self.tableView reloadData];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"oil list error:%@",error);
    }];
    
    
    
    
}



#pragma mark - 筛选
//筛选板块信息
-(void)obtainDistributeInfoList
{
    AFHTTPRequestOperationManager *oilManager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{kInterfaceName : @"getList",
                                @"lastInfo":@"0"};
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
    
    [oilManager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        for (NSDictionary *dic in [responseObject objectForKey:@"data"] ) {
            [self.distributeArrM addObject:dic];
        }
        
        self.arr = self.distributeArrM;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

//关注与取消关注
-(void)payAttention:(UIButton *)sender
{
    
   
    if (self.userOilInfo.isLogin) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.arr[sender.tag] ]; //不可变的字典初始化后不可修改，所以用一个可变字典接收一下再做修改

               if ([[dict objectForKey:kFlag] isEqualToString:@"1"]) {
            
            [dict setObject:@"0" forKey:kFlag];
            self.arr[sender.tag] = dict;
            //取消关注
            [self cancelFocusOilInfoWithNum:sender.tag];
           
        }else{
            
            [dict setObject:@"1" forKey:kFlag];
            self.arr[sender.tag] = dict;
           
            //关注
            [self focusOilInfoWithNum:sender.tag];
            
        }
        
        [self.tableView reloadData];
    }else{
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    
}

//关注加油信息
-(void)focusOilInfoWithNum:(NSInteger)num
{

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameter;
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
        
        parameter = @{kInterfaceName:@"focus",
                      @"promote_id":[self.arr[num] objectForKey:@"promote_id"],
                      @"user_id":self.userOilInfo.userID};
        
        [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.arr[num]];
                [dic setObject:[[responseObject objectForKey:@"data"] objectForKey:@"focus_id"] forKey:@"focus_id"];
                [dic setObject:@"1" forKey:@"focus_status"];
                self.arr[num] = dic;
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"promoteerror:%@",error);
        }];

        
   
}

//取消关注

-(void)cancelFocusOilInfoWithNum:(NSInteger)num
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
    NSDictionary *parameter = @{kInterfaceName:@"cancelFocus",
                                @"focus_id":[self.arr[num] objectForKey:@"focus_id"],
                                @"user_id":self.userOilInfo.userID};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.arr[num]];
                  //  [dic setObject:[[responseObject objectForKey:@"data"] objectForKey:@"focus_id"] forKey:@"focus_id"];
            [dic setObject:@"0" forKey:@"focus_status"];
            self.arr[num] = dic;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"cancel error:%@",error);
    }];
    
}


//请求关注的信息列表
-(void)obtainFocusInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getFocus",
                                @"user_id":self.userOilInfo.userID,
                                @"infoNumber":[NSString stringWithFormat:@"%d",0]};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                [self.focusArrM addObject:dic];
            }
            self.arr = self.focusArrM;
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"focus error:%@",error);
    }];
 
}

//请求区域信息
-(void)obtainRegionInfo
{
    //请求区域数据
    AFHTTPRequestOperationManager *regionManager = [AFHTTPRequestOperationManager manager];
    NSString *regionUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *regionDic = @{kInterfaceName:@"getaddress",
                                @"address_id":@"021"};
    
    [regionManager POST:regionUrl parameters:regionDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject  objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                
                [self.plateArrOil  addObject:[dic objectForKey:kRegionName]];
                [self.plateIDArr addObject:[dic objectForKey:kRegionID]];
                
            }
            
            [self.pickerViewOil reloadAllComponents];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
 
}

//请求板块数据
-(void)obtainPlateInfoWithRow:(NSInteger)row
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{kInterfaceName:@"getaddress",
                                @"address_id":self.plateIDArr[row]
                                };
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.streetIDarr removeAllObjects];
            [self.streetArrOil removeAllObjects];
            
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                [self.streetArrOil addObject:[dic objectForKey:kRegionName]];
                [self.streetIDarr addObject:[dic objectForKey:kRegionID]];
            }
            [self.pickerViewOil reloadAllComponents];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

//获得加油站类型
-(void)obtainOilStation
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getStationType"};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.stationIDArr removeAllObjects];
            [self.stationArrOil removeAllObjects];
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                [self.stationArrOil addObject:[dic objectForKey:@"oil_type_name"]];
                [self.stationIDArr addObject:@"station_type"];
            }
        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//筛选油类
-(void)differentOilFilter:(UIButton *)sender
{
    //提交服务器，并请求数据
    [MBProgressHUD showMessage:@"正在加载。。。" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
    NSDictionary *parameter;
//    if (self.regionID.length && self.plateID.length) {
    
    if (sender.tag == 92) {
        
        parameter = @{kInterfaceName:@"filter",
                      @"infoNumber":@"0",
                      @"province_id":@"021",
                      @"city_id":self.regionID,
                      @"plate_id":self.plateID,
                      @"oil_type":@"92",
                      @"user_id":self.userOilInfo.userID};
    }else if(sender.tag == 95){
        parameter = @{kInterfaceName:@"filter",
                      @"infoNumber":@"0",
                      @"province_id":@"021",
                      @"city_id":self.regionID,
                      @"plate_id":self.plateID,
                      @"oil_type":@"93",
                      @"user_id":self.userOilInfo.userID};
    }else{
        parameter = @{kInterfaceName:@"filter",
                      @"infoNumber":@"0",
                      @"province_id":@"021",
                      @"city_id":self.regionID,
                      @"plate_id":self.plateID,
                      @"oil_type":@"10",
                      @"user_id":self.userOilInfo.userID};
    }
   
   
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.arr removeAllObjects];
            
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                [self.arr removeAllObjects];
                for (NSDictionary *dic in [responseObject objectForKey:@"data"] ) {
                    [self.dataArrM addObject:dic];
                }
                
                self.arr = self.dataArrM;
                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    //隐藏pickerViewBack
    self.pickerBackViewOil.frame = CGRectMake(0, -Height, Width, Height);

}

#pragma mark --  segment切换数据源

-(void)selectInfo:(UISegmentedControl *)sender
{
    [self.arr removeAllObjects];
    switch (sender.selectedSegmentIndex) {
        case 0:
        {

            oilFilterFlag = DEFAULTCONDITION;
            [self obtainOilDiscountDataList];
            
        }
            break;
        case 1:
        {
            if (self.userOilInfo.isLogin) {
                oilFilterFlag = FOCUSCONDITION;
                [self obtainFocusInfo];
            }else{
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            
            
        }
            break;
            
            
        default:
            break;
    }


}


#pragma mark -- 刷新

//上拉刷新

-(void)refreshMoreDataOilInfo
{
    switch (oilFilterFlag) {
        case DEFAULTCONDITION:
        {
            //获取更多加油默认列表
            AFHTTPRequestOperationManager *oilManager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameter = @{kInterfaceName : @"getList",
                                        @"infoNumber":[NSString stringWithFormat:@"%d",self.arr.count],
                                        @"user_id":self.userOilInfo.userID};
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
            
            [oilManager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self.tableView.footer endRefreshing];
                
                if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                    
                    for (NSDictionary *dic in [responseObject objectForKey:@"data"]){
                        [self.dataArrM addObject:dic];
                    }
                    
                    self.arr = self.dataArrM;
                    [self.tableView reloadData];
                    
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.tableView.footer endRefreshing];
                NSLog(@"oil list error:%@",error);
            }];

        }
            break;
            
        //更多关注信息
        case FOCUSCONDITION:
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
            NSDictionary *parameter = @{kInterfaceName:@"getFocus",
                                        @"user_id":self.userOilInfo.userID,
                                        @"infoNumber":[NSString stringWithFormat:@"%d",self.arr.count]};
            [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                 [self.tableView.footer endRefreshing];
                
                if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                    
                    for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                        [self.focusArrM addObject:dic];
                    }
                    self.arr = self.focusArrM;
                    [self.tableView reloadData];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                 [self.tableView.footer endRefreshing];
                NSLog(@"focus error:%@",error);
            }];
        }
            break;
            

            
        default:
            break;
    }
}

#pragma mark -- customBtn

-(UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title backImage:(NSString *)imgName
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    
    [btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.pickerBackViewOil addSubview:btn];
    return btn;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    HomeViewController *rootVC = (HomeViewController *) self.navigationController.viewControllers[0];
    rootVC.oilBadge.titleLabel.text = @"0";
    [rootVC.oilBadge removeFromSuperview];

}

@end
