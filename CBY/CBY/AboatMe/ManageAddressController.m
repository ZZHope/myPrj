//
//  ManageAddressController.m
//  51CBY
//
//  Created by SJB on 15/1/27.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "ManageAddressController.h"
#import "NewAddressCell.h"
#import "AddressViewController.h"
#import "AFNCommon.h"
#import "AFNetworking.h"
#import "CbyUserSingleton.h"


#define kSelFlag  @"flag"
#define kOwnerName  @"consignee"
#define kPhoneNum   @"mobile"
#define kAddressDetail  @"address"
#define kProvince   @"province_name"
#define kCity       @"city_name"
#define kDistric    @"district_name"
#define kAddressID  @"address_id"

#define kWidth   self.view.bounds.size.width
#define kHeight  self.view.bounds.size.height

@interface ManageAddressController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataListArr;
@property(nonatomic, strong) NSDictionary *tempDic;
@property(nonatomic, strong) CbyUserSingleton *addressManagerInfo;
@property(nonatomic, copy) NSString *addressID;

@property(nonatomic,strong) NSMutableDictionary *dicReturn;



@end

int indexNum = 0;

@implementation ManageAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*右视图*/

    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [settingBtn setTitle:@"添加" forState:UIControlStateNormal];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    /*navigation*/
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    if (self.changeFlag == 1) {
        textlabel.text = @"选择新地址";
    }else{
      textlabel.text = @"地址管理";
    }
    
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //info
    self.addressManagerInfo = [CbyUserSingleton shareUserSingleton];
    
    /*tableView*/
    

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-100) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview: self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*数据源*/
  
    _dataListArr = [NSMutableArray array];
    _dicReturn = [NSMutableDictionary dictionary];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取收货地址(不在didLoad中写因为上面的界面pop出去后再进来不会走那个方法)
    [self getAdressInfo];
}



#pragma mark -- tableView datasource/delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.dataListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID = @"cellID";
    NewAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"NewAddressCell" owner:self options:nil];
        cell = arr[0];
    }
    
    cell.nameLabel.text = [self.dataListArr[indexPath.row] objectForKey:kOwnerName];
    cell.phoneLabel.text = [self.dataListArr[indexPath.row] objectForKey:kPhoneNum];
    cell.detailAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",@"上海",[self.dataListArr[indexPath.row] objectForKey:kCity],[self.dataListArr[indexPath.row] objectForKey:kDistric],[self.dataListArr[indexPath.row] objectForKey:kAddressDetail]];
    
    [cell.editBtn addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = indexPath.row+1000;
    [cell.deleteBtn addTarget:self action:@selector(deleteAddressInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = indexPath.row + 2000;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell.selBtn setSelFlag:[[self.dataListArr[indexPath.row] objectForKey:kSelFlag]boolValue] andImg:@"不选中" highLightImg:@"选中"];
    [cell.selBtn addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchUpInside];
    cell.selBtn.tag = indexPath.row+3000;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, kWidth, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((kWidth-160)*0.5, 10, 160, 30)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"设置为默认地址" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
   
    [btn addTarget:self action:@selector(settingDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    [backView  addSubview:btn];
    
    return backView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.changeFlag == 1) {
        
        [self.dicReturn setObject:[self.dataListArr[indexPath.row] objectForKey:kOwnerName] forKey:@"consignee"];
        [self.dicReturn setObject:[self.dataListArr[indexPath.row] objectForKey:kPhoneNum] forKey:@"mobile"];
        [self.dicReturn setObject:[self.dataListArr[indexPath.row] objectForKey:kProvince] forKey:@"province_name"];
        [self.dicReturn setObject:[self.dataListArr[indexPath.row] objectForKey:kCity] forKey:@"city_name"];
        [self.dicReturn setObject:[self.dataListArr[indexPath.row] objectForKey:kDistric] forKey:@"district_name"];
        [self.dicReturn setObject:[self.dataListArr[indexPath.row] objectForKey:@"city"] forKey:@"city"];
        [self.dicReturn setObject:[self.dataListArr[indexPath.row] objectForKey:@"district"] forKey:@"district"];
        [self.dicReturn setObject:[self.dataListArr[indexPath.row] objectForKey:@"address"] forKey:@"address"];

        
        
        if (self.myAddressReturn != nil) {
            self.myAddressReturn(self.dicReturn);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark -- return address

-(void)returnMyNewAddress:(MyReturnBlock)myReturn
{
    self.myAddressReturn = myReturn;
}

#pragma mark -- target - action


-(void)deleteAddressInfo:(UIButton *)sender
{
    //删除信息
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确认删除该地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    indexNum = (int)(sender.tag-2000);
    [alert show];
    
}


#pragma mark -- alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {

            [self deleteAddressService];
        }
            
            break;
            
        default:
            break;
    }
}

//选择
-(void)selectAddress:(UIButton *)sender
{
    self.addressID =  [self.dataListArr[sender.tag-3000] objectForKey:kAddressID];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.dataListArr[sender.tag-3000]];
    for (int i =0 ;i<self.dataListArr.count;i++) {
    
        NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:self.dataListArr[i]];
        [dicM setObject:@NO forKey:kSelFlag];
        [self.dataListArr replaceObjectAtIndex:i  withObject:dicM];
    }
    
        [tempDic setObject:@YES forKey:kSelFlag];
        [self.dataListArr replaceObjectAtIndex:(sender.tag-3000) withObject:tempDic];
        [self.tableView reloadData];
    

    
    
}

//编辑地址
-(void)editAddress:(UIButton *)sender
{
    
    AddressViewController *addressVC = [[AddressViewController alloc]init];
    addressVC.title = @"编辑地址";
    addressVC.modifyAddressID = [self.dataListArr[sender.tag-1000] objectForKey:kAddressID];
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM addObject:[self.dataListArr[sender.tag-1000] objectForKey:kOwnerName]];
    [arrM addObject:[self.dataListArr[sender.tag-1000] objectForKey:kPhoneNum]];
    [arrM addObject:[NSString stringWithFormat:@"%@%@%@",@"上海",[self.dataListArr[sender.tag-1000] objectForKey:kCity],[self.dataListArr[sender.tag-1000] objectForKey:kDistric]]];
    [arrM addObject:[self.dataListArr[sender.tag-1000] objectForKey:kAddressDetail]];
    addressVC.existArr = arrM;
    //将地址id给下个界面
    self.addressManagerInfo.cityID = [self.dataListArr[sender.tag-1000] objectForKey:@"city"];
    self.addressManagerInfo.streetID = [self.dataListArr[sender.tag-1000] objectForKey:@"district"];
        
    [self.navigationController pushViewController:addressVC animated:YES];

    
}


//添加地址
-(void)addAddress:(UIButton *)sender
{
    AddressViewController *addressVC = [[AddressViewController alloc]init];
    addressVC.title = @"添加地址";
    
    [self.navigationController pushViewController:addressVC animated:YES];
}


#pragma mark - 数据请求

//获取地址信息
-(void)getAdressInfo
{
    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getconsigneeinfo",
                                @"operation":@"get",
                                @"user_id":self.addressManagerInfo.userID};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject  objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            [self.dataListArr removeAllObjects];
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                [self.dataListArr  addObject:dic];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取地址信息失败 :%@",error);
          [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//删除收货地址
-(void)deleteAddressService
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getconsigneeinfo",
                                @"operation":@"delete",
                                @"address_id":[self.dataListArr[indexNum] objectForKey:kAddressID],
                                @"user_id":self.addressManagerInfo.userID};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            [self.dataListArr removeObjectAtIndex:indexNum];
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"删除地址信息失败 :%@",error);

    }];
    
}

//设置默认地址
-(void)settingDefaultAddress:(UIButton *)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getconsigneeinfo",
                                @"operation":@"setDefault",
                                @"address_id":self.addressID,
                                kUserID:self.addressManagerInfo.userID};
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"status"] isEqualToString:@"ok"]) {
             NSLog(@"设置默认地址成功");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设置默认地址成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"default error:%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
