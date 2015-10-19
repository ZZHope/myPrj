//
//  BookCheckViewController.m
//  51CBY
//
//  Created by SJB on 14/12/30.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "CheckViewController.h"
#import "HomeServiceCell.h"
#import "PersonInfoTableViewCell.h"
#import "RegViewController.h"
#import "DirectAddressViewController.h"
#import "CbyUserSingleton.h"
#import "AFNetworking.h"
#import "AFNCommon.h"

#import "CbyDataBaseManager.h"
#import "DBCommon.h"
#import "UIImageView+WebCache.h"

#define kImage @"image"
#define kText @"text"

typedef NS_ENUM(NSInteger, DATATYPE) {
    DATATYPE_PINPAITYPE = 1,
    DATATYPE_CHEXINGTYPE,
    DATATYPE_PAILIANGTYPE,
    DATATYPE_NIANFENTYPE
};
#define Width  self.view.frame.size.width
#define Height  self.view.frame.size.height
#define kWindowHeight   [[UIApplication sharedApplication].delegate window].bounds.size.height
//
@interface CheckViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *placeHolderArr;
@property (strong, nonatomic) NSArray *autoArr;
@property (strong, nonatomic) UIButton *brandBtn;
@property (nonatomic, assign) DATATYPE dataType;
@property (nonatomic, strong) UIButton *tempButton;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *backgroundView;
@property (copy, nonatomic) NSString *brandStr;
@property (copy, nonatomic) NSString *modelStr;
@property (copy, nonatomic) NSString *dischargeStr;
@property (copy, nonatomic) NSString *yearStr;
//存放数据
@property (strong, nonatomic) NSMutableArray *brandArr;
@property (strong, nonatomic) NSMutableArray *brandBackI;
@property (strong, nonatomic) NSMutableArray *modelArr;
@property (strong, nonatomic) NSMutableArray *modelBackI;
@property (strong, nonatomic) NSMutableArray *disChargeArr;
@property (strong, nonatomic) NSMutableArray *disChargeBackI;
@property (strong, nonatomic) NSMutableArray *yearArr;
@property (strong, nonatomic) NSMutableArray *yearBackID;

@property (strong, nonatomic) NSArray *totleArr;
@property (strong, nonatomic) NSArray *btnTitleArr;
@property (strong, nonatomic) NSArray *titleArr;

//图片名字
@property (copy, nonatomic) NSString *imageName;
//图片数组
@property (strong, nonatomic) NSMutableArray *imageArr;

//单例
@property (strong, nonatomic) CbyUserSingleton *carCheckInfo;
@property (strong, nonatomic) NSArray *carCheckInfoArr;

@property (copy, nonatomic) NSString *priceFree;
@property (strong , nonatomic) NSDictionary *goods;


@end

BOOL isLogin = NO;
static NSString *cellIdentifier = @"homeCell";
static NSString *personCellIdentifier = @"personInfoCell";
NSInteger flagNum =0;

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*navigation*/
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"预约检测";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
    
    
    /*tableView*/
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
    /*pickerView*/
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, Height+200, Width, 260)] ;
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(Width-100, 5, 80, 40)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [btn addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(100, 50, Width-200, 180)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.backgroundView addSubview:btn];
    [self.backgroundView addSubview:self.pickerView];
    [self.view addSubview:self.backgroundView];
    
    //数据源
    self.modelArr = [NSMutableArray array];
    [self.modelArr addObject:@"车型"];
    self.modelBackI = [NSMutableArray array];
    [self.modelBackI addObject:@"车型id"];
    self.disChargeArr = [NSMutableArray array];
    [self.disChargeArr addObject:@"排量"];
    self.disChargeBackI = [NSMutableArray array];
    [self.disChargeBackI addObject:@"排量id"];
    self.yearArr = [NSMutableArray array];
    [self.yearArr addObject:@"年份"];
    self.yearBackID = [NSMutableArray array];
    [self.yearBackID addObject:@"年份 car_id"];
    self.priceFree = @"";
    
    self.placeHolderArr = [NSArray array];
    self.placeHolderArr = @[@"\t品牌",@"\t车型",@"\t排量",@"\t年份"];
    /*选择车型*/
    self.autoArr = [NSArray array];
    self.btnTitleArr = [NSArray array];
    
    self.brandArr = [NSMutableArray array];
    [self.brandArr addObject:@"品牌"];
    self.brandBackI = [NSMutableArray array];
    [self.brandBackI addObject:@"品牌id"];
    self.imageArr = [NSMutableArray array];
    [self.imageArr addObject:@"图片"];
    CbyDataBaseManager *manager = [CbyDataBaseManager shareInstance];

    NSArray *tempArr  = [NSArray array];
    tempArr = [manager carBrandQueryFromDB:kCarTable];
    for (NSDictionary *dic in tempArr) {
        
        [self.brandArr addObject: [dic objectForKey:@"n"]];
        [self.brandBackI addObject:[dic objectForKey:@"i"]];
        [self.imageArr addObject:[dic objectForKey:@"img"]];
    }

    
    /*右视图*/
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [rightBtn addTarget:self action:@selector(registerApp) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    //单例
    _carCheckInfo = [CbyUserSingleton shareUserSingleton];
    _carCheckInfoArr = [NSArray array];
    
    //获得免费检测的次数
    
    //if (self.carCheckInfo.isLogin) {
        
        //提示还有几次免费机会
        AFHTTPRequestOperationManager *managerAF = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameter = @{@"user_id":self.carCheckInfo.userID};
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_car_free_check.php"];
        [managerAF POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
              if (self.carCheckInfo.isLogin) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat: @"还有%@次免费检测机会",[[responseObject objectForKey:@"data"] objectForKey:@"number"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
              }
                
                self.priceFree = [[[responseObject objectForKey:@"data"] objectForKey:@"goods_info"] objectForKey:@"shop_price"];
                self.goods = [[responseObject objectForKey:@"data"] objectForKey:@"goods_info"];
                [self.tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"免费检测： error: %@",error);
            
        }];
        

    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark -- tableView delegate/datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return self.placeHolderArr.count;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    self.carCheckInfoArr = @[self.carCheckInfo.brand,self.carCheckInfo.model,self.carCheckInfo.discharge,self.carCheckInfo.boughtYear];
         HomeServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (nil == cell) {
            NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:@"HomeServiceCell" owner:self options:nil] ;
            cell = [cellArr objectAtIndex:0];
        }
        

        cell.nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        cell.nameLabel.text = self.placeHolderArr[indexPath.row];
    
    if ([self.carCheckInfoArr[indexPath.row] length]) {
        [cell.selectButton setTitle:self.carCheckInfoArr[indexPath.row] forState:UIControlStateNormal];
    }
        cell.selectButton.tag = indexPath.row+1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.selectButton addTarget:self action:@selector(pickerShow:) forControlEvents:UIControlEventTouchUpInside];
         return cell;
       
   
    
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((Width-80)/2.0, 10, 80, 40)] ;
    //预约检测不固定
        label.text = [NSString stringWithFormat: @"注册送免费检测2次/年\n若未注册或已用完两次优惠，可享受付费检测,%@元/次",self.priceFree];
        label.textColor = [UIColor blackColor];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:label.text];
        [attrString addAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:NSMakeRange(3, 2)];
        [attrString addAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:NSMakeRange(7, 2)];
        label.attributedText = attrString;
    
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.backgroundColor = [UIColor whiteColor];
        return label;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
   
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((Width-160)/2.0, 10, 160, 30)];
        [btn setTitle:@"立即预约" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:246/255.0 green:29/255.0 blue:35/255.0 alpha:1.0f]];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        btn.layer.cornerRadius = 10.0f;
        [btn addTarget:self action:@selector(makeSureCare:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        bgView.backgroundColor = [UIColor whiteColor];
        return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
         return 60.0f;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}




#pragma mark --pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.autoArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    flagNum = row;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.autoArr[row];
}


#pragma mark -- target-action

//确认预约保养

-(void)makeSureCare:(UIButton *)sender
{
    self.backgroundView.frame = CGRectMake(0, Height+200, Width, 260) ;

    self.brandStr = self.carCheckInfo.brand;
    self.modelStr = self.carCheckInfo.model;
    self.dischargeStr = self.carCheckInfo.discharge;
    self.yearStr = self.carCheckInfo.boughtYear;
    
     if (self.brandStr.length>0 &&self.modelStr.length > 0&&self.dischargeStr.length>0&&self.yearStr.length>0) {
         
         
    DirectAddressViewController *orderVC = [[DirectAddressViewController alloc]init];
         orderVC.fromPriceFlag = @"1";
         orderVC.priceFromCheck = self.priceFree;
         NSMutableDictionary *transitGoods = [NSMutableDictionary dictionary];
         [transitGoods setObject:[self.goods objectForKey:@"goods_id"] forKey:@"goods_id"];
         [transitGoods setObject:@"1" forKey:@"goods_number"];
         [transitGoods setObject:self.carCheckInfo.carID forKey:@"car_id"];
         orderVC.checkGoodsTemp = transitGoods;
         
    [self.navigationController pushViewController:orderVC animated:YES];
     
 //返回按钮,要在父界面写
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
         
    
    }else{
         
         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善车型数据" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         alertView.delegate = self;
         [alertView show];
     }


}

//展示pickerView，点击更改数据源
-(void)pickerShow:(UIButton *)sender
{
    flagNum = 0;
    self.totleArr = @[self.brandArr,self.modelArr,self.disChargeArr,self.yearArr];
    self.tempButton = sender;//！！！！添加的代码，否则不可以正常执行
    self.autoArr = self.totleArr[sender.tag-1];
    self.dataType = sender.tag;
    _backgroundView.frame = CGRectMake(0, Height-200, Width, 260);
    
    [self.pickerView reloadAllComponents];
    
}



#pragma mark-- target - action

-(void)hiddenView:(UIButton *)sender
{
    
    
    switch (self.dataType) {
        case DATATYPE_PINPAITYPE:
        {
           
            
            [self.tempButton setTitle:self.autoArr[flagNum] forState:UIControlStateNormal];
            self.carCheckInfo.brand = self.autoArr[flagNum];
            
            
            self.brandStr = self.autoArr[flagNum];
            self.imageName = self.imageArr[flagNum];
            
            //取车型数据
            if (self.brandBackI[flagNum]) {
                
               [self.modelArr removeAllObjects];
                [self.modelArr addObject:@"车型"];
                [self.modelBackI removeAllObjects];
                [self.modelBackI addObject:@"车型id"];
                CbyDataBaseManager *manager = [CbyDataBaseManager shareInstance];
                NSArray *modelArr = [NSArray array];
                modelArr = [manager carModelQueryFromDB:kCarTable withPID:self.brandBackI[flagNum]];
                for (NSDictionary *dic in modelArr) {
                    [self.modelArr addObject:[dic objectForKey:@"n"]];
                    [self.modelBackI addObject:[dic objectForKey:@"i"]];
                }
                
                [self.pickerView reloadAllComponents];
                
            }
            
        }
            break;
        case DATATYPE_CHEXINGTYPE:
        {
            [self.tempButton setTitle:self.autoArr[flagNum] forState:UIControlStateNormal];
            self.modelStr = self.autoArr[flagNum];
            self.carCheckInfo.model = self.autoArr[flagNum];
            
            //取排量数据
            if (self.modelBackI[flagNum]) {
                
                [self.disChargeArr removeAllObjects];
                [self.disChargeArr addObject:@"排量"];
                [self.disChargeBackI removeAllObjects];
                [self.disChargeBackI addObject:@"排量id"];
                
                CbyDataBaseManager *manager = [CbyDataBaseManager shareInstance];
                NSArray *disChargeTemp = [NSArray array];
                disChargeTemp = [manager carDisChargeQueryFromDB:kCarTable withPID:self.modelBackI[flagNum]];
                for (NSDictionary *dic in disChargeTemp) {
                    [self.disChargeArr addObject:[dic objectForKey:@"n"]];
                    [self.disChargeBackI addObject:[dic objectForKey:@"i"]];
                }
                
                [self.pickerView reloadAllComponents];
                
            }
            
        }
            
            break;
        case DATATYPE_PAILIANGTYPE:
        {
            [self.tempButton setTitle:self.autoArr[flagNum] forState:UIControlStateNormal];
            
            self.dischargeStr = self.autoArr[flagNum];
            self.carCheckInfo.discharge = self.autoArr[flagNum];
            
            
            //取出年份的数据
            if (self.disChargeBackI[flagNum]) {
                
              [self.yearArr removeAllObjects];
                [self.yearArr addObject:@"年份"];
                [self.yearBackID removeAllObjects];
                [self.yearBackID addObject:@"年份 car_id"];
                CbyDataBaseManager *manager = [CbyDataBaseManager shareInstance];
                NSArray *yearArr = [NSArray array];
                yearArr = [manager carYearQueryFromDB:kCarTable withPID:self.disChargeBackI[flagNum]];
                for (NSDictionary *dic in yearArr) {
                    [self.yearArr addObject:[dic objectForKey:@"n"]];
                    [self.yearBackID addObject:[dic objectForKey:@"car_id"]];
                }
                [self.pickerView selectRow:0 inComponent:0 animated:YES];
                [self.pickerView reloadAllComponents];
                
            }
            
            
        }
            
            break;
        case DATATYPE_NIANFENTYPE:
        {
            [self.tempButton setTitle:self.autoArr[flagNum] forState:UIControlStateNormal];
            self.yearStr = self.autoArr[flagNum];
            self.carCheckInfo.boughtYear = self.autoArr[flagNum];
            self.carCheckInfo.carID = self.yearBackID[flagNum];
            
        }
            
            break;
            
        default:
            break;
    }
    
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    _backgroundView.frame = CGRectMake(0, kWindowHeight, Width, 216);
    
}


#pragma mark-- textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)registerApp
{
    RegViewController *regVC = [[RegViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
    regVC.title = @"注册";
    
}


#pragma mark --alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    CbyDataBaseManager *manager = [CbyDataBaseManager shareInstance];
    
    
    NSArray *tempArr  = [NSArray array];
    tempArr = [manager carBrandQueryFromDB:kCarTable];
    for (NSDictionary *dic in tempArr) {
        
        [self.brandArr addObject: [dic objectForKey:@"n"]];
        [self.brandBackI addObject:[dic objectForKey:@"i"]];
        [self.imageArr addObject:[dic objectForKey:@"img"]];
    }
    self.autoArr = self.brandArr;
    [self.pickerView reloadAllComponents];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
