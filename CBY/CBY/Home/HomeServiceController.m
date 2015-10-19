//
//  HomeServiceController.m
//  51CBY
//
//  Created by SJB on 14/12/24.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "HomeServiceController.h"
#import "HomeServiceCell.h"
#import "SchemeViewController.h"
#import "CbyDataBaseManager.h"
#import "DBCommon.h"
#import "UIImageView+WebCache.h"
#import "CbyUserSingleton.h"
#import "AFNetworking.h"
#import "AFNCommon.h"

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
#define kWindowHeight  self.view.window.frame.size.height

@interface HomeServiceController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *placeHolderArr;
@property (strong, nonatomic) NSArray *autoArr;
@property (nonatomic, assign) DATATYPE dataType;
@property (nonatomic, strong) UIButton *tempButton;
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
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) CbyUserSingleton *carSeleInfo;
@property (strong, nonatomic) NSArray *carInfoArr;

//图片名字
@property (copy, nonatomic) NSString *imageName;
//图片数组
@property (strong, nonatomic) NSMutableArray *imageArr;



@end
static NSString *cellIdentifier = @"serviceCell";
NSInteger flag =0;

@implementation HomeServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //单例
    _carSeleInfo = [CbyUserSingleton shareUserSingleton];
    
    _carInfoArr = [NSArray array];
    
    /*tableView*/
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
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
    
    self.placeHolderArr = [NSArray array];
    self.placeHolderArr = @[@"品牌",@"车型",@"排量",@"年份"];
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
    
    
   
   
    
   }



#pragma mark -- tableView delegate/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.carInfoArr = @[self.carSeleInfo.brand,self.carSeleInfo.model,self.carSeleInfo.discharge,self.carSeleInfo.boughtYear];
    HomeServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:@"HomeServiceCell" owner:self options:nil] ;
        cell = [cellArr objectAtIndex:0];
    }
    cell.nameLabel.text = self.placeHolderArr[indexPath.row];
    if ([self.carInfoArr[indexPath.row] length]) {
        [cell.selectButton setTitle:self.carInfoArr[indexPath.row] forState:UIControlStateNormal];
    }
    cell.selectButton.tag = indexPath.row+1;
  
    
    /*更改过。注意！！！*/
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
    label.text = @"省时 省心 省钱";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.textColor = [UIColor blackColor];
    
    return label;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((Width-120)/2.0, 10, 120, 30)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((Width-120)/2.0, 10, 120, 30)];
    
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
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
    
    flag = row;
  
    
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

    self.brandStr = self.carSeleInfo.brand;
    self.modelStr = self.carSeleInfo.model;
    self.dischargeStr = self.carSeleInfo.discharge;
    self.yearStr = self.carSeleInfo.boughtYear;
    self.imageName = self.carSeleInfo.imageName;

    if (self.brandStr.length>0 &&self.modelStr.length > 0&&self.dischargeStr.length>0&&self.yearStr.length>0) {
        
    if ([self.labelText isEqualToString: @"添加车型"]) {
        
         NSString *returnText = [NSString stringWithFormat:@"%@ %@ %@ %@",self.brandStr,self.modelStr,self.dischargeStr,self.yearStr];
            NSDictionary *dic = [NSDictionary dictionary];
            dic = @{kImage:[UIImage imageNamed:self.imageName],kText :returnText,@"car_id":self.carSeleInfo.carID};
            if (self.myBlock != nil) {
                self.myBlock(dic);
            }
      

        
        
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
            NSDictionary *parameter = @{kInterfaceName:@"manageusercar",
                                        kUserID:self.carSeleInfo.userID,
                                        @"operation":@"add",
                                        @"car_id":self.carSeleInfo.carID,
                                        @"carPhoto":self.imageName};
            [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                  
                }
            
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"add car error:%@",error);
            }];

        
        
        
       
        
        
    }else{
        
    SchemeViewController *smallCareVC = [[SchemeViewController alloc]init];
       
        smallCareVC.title = @"保养服务";

        smallCareVC.loopFlag = 1;

        
        //返回按钮
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        smallCareVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:smallCareVC animated:YES];
        

    
    }
        
        

    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善车型数据" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        [alertView show];
    }
    
}

//展示pickerView，点击更改数据源
-(void)pickerShow:(UIButton *)sender
{
    flag = 0;
    self.totleArr = @[self.brandArr,self.modelArr,self.disChargeArr,self.yearArr];
    self.tempButton = sender;//！！！！添加的代码，否则不可以正常执行
    self.autoArr = self.totleArr[sender.tag-1];
    self.dataType = sender.tag;
    _backgroundView.frame = CGRectMake(0, Height-200, Width, 260);
    
    [self.pickerView reloadAllComponents];
    
    
  }

-(void)selectCarInfo
{
    switch (self.dataType) {
        case DATATYPE_PINPAITYPE:
        {
           
            
            
            [self.tempButton setTitle:self.autoArr[flag] forState:UIControlStateNormal];
            self.carSeleInfo.brand = self.autoArr[flag];
            
            self.brandStr = self.autoArr[flag];
            self.imageName = self.imageArr[flag];
            self.carSeleInfo.imageName = self.imageArr[flag];
            self.carSeleInfo.brandID = self.brandBackI[flag];
            
            //取车型数据
            if (self.carSeleInfo.brandID) {
                
                [self.modelArr removeAllObjects];
                [self.modelArr addObject:@"车型"];
                [self.modelBackI removeAllObjects];
                [self.modelBackI addObject:@"车型id"];
                CbyDataBaseManager *manager = [CbyDataBaseManager shareInstance];
                NSArray *modelArr = [NSArray array];
                modelArr = [manager carModelQueryFromDB:kCarTable withPID:self.brandBackI[flag]];
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
            [self.tempButton setTitle:self.autoArr[flag] forState:UIControlStateNormal];
            self.carSeleInfo.model = self.autoArr[flag];
            self.carSeleInfo.modelID = self.modelBackI[flag];
            self.modelStr = self.autoArr[flag];
            
            //取排量数据
            if (self.carSeleInfo.modelID) {
                
               [self.disChargeArr removeAllObjects];
                [self.disChargeArr addObject:@"排量"];
                [self.disChargeBackI removeAllObjects];
                [self.disChargeBackI addObject:@"排量id"];
                
                CbyDataBaseManager *manager = [CbyDataBaseManager shareInstance];
                NSArray *disChargeTemp = [NSArray array];
                disChargeTemp = [manager carDisChargeQueryFromDB:kCarTable withPID:self.modelBackI[flag]];
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
            [self.tempButton setTitle:self.autoArr[flag] forState:UIControlStateNormal];
            self.carSeleInfo.discharge = self.autoArr[flag];
            self.dischargeStr = self.autoArr[flag];
            self.carSeleInfo.dischargeID = self.disChargeBackI[flag];
            
            //取出年份的数据
            if (self.carSeleInfo.dischargeID) {
                
               [self.yearArr removeAllObjects];
                [self.yearArr addObject:@"年份"];
                [self.yearBackID removeAllObjects];
                [self.yearBackID addObject:@"年份 car_id"];
                CbyDataBaseManager *manager = [CbyDataBaseManager shareInstance];
                NSArray *yearArr = [NSArray array];
                yearArr = [manager carYearQueryFromDB:kCarTable withPID:self.disChargeBackI[flag]];
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
            [self.tempButton setTitle:self.autoArr[flag] forState:UIControlStateNormal];
            self.carSeleInfo.boughtYear = self.autoArr[flag];
            self.yearStr = self.autoArr[flag];
            
            self.carSeleInfo.carID = self.yearBackID[flag];
            
        }
            
            break;
            
        default:
            break;
    }

}

#pragma mark-- target - action
-(void)hiddenView:(UIButton *)sender
{
    


    [self selectCarInfo];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
   _backgroundView.frame = CGRectMake(0, kWindowHeight, Width, 216);

}




#pragma mark -- bolck传值

-(void)returnCarModelData:(MyReturnBlock)myBlock
{
    self.myBlock = myBlock;
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

@end
