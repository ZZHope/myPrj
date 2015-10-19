//
//  AddressViewController.m
//  51CBY
//
//  Created by SJB on 15/1/27.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "AddressViewController.h"
#import "PersonInfoTableViewCell.h"
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

#define kHeight  self.view.bounds.size.height
#define kWidth  self.view.bounds.size.width

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *detailArr;
@property(nonatomic,strong) NSMutableArray *regionArr;
@property(nonatomic,strong) NSMutableArray *streetArr;
@property(nonatomic,strong) UITextField *tempTextField;
@property(nonatomic,copy)  NSMutableString *stringM;
@property(nonatomic,strong) NSArray *defaultDataM;


//选择器
@property(nonatomic,strong) UIPickerView *addressPickView;
@property(nonatomic,strong) UIView *pickerBack;

@property(nonatomic, strong) CbyUserSingleton *addressInfo;

@end


@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*tableView*/
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
    //title
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = self.title;
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;

    
    //右视图
    UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeEdit:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //addressInfo
    self.addressInfo = [CbyUserSingleton shareUserSingleton];
    
    /*数据源*/
    
    
    
    //数据显示
    _detailArr = [NSArray array];
    self.detailArr = @[@"收货姓名",@"手机号码",@"省市区   ",@"详细地址"];
    self.regionArr = [NSMutableArray array];
    self.streetArr = [NSMutableArray array];
    self.defaultDataM = [NSArray array];
    self.defaultDataM = @[self.addressInfo.addressName,self.addressInfo.addressPhoneNum,[NSString stringWithFormat:@"%@%@%@",self.addressInfo.province,self.addressInfo.city,self.addressInfo.street],self.addressInfo.detailAddress];
    
    
    // 获取地址信息
    [self getOrigin];
    
    //picker
    self.pickerBack = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, 260)];
    self.addressPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(10, 40, kWidth-20, 210)];
    self.addressPickView.delegate = self;
    self.addressPickView.dataSource = self;
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-50, 5, 40, 30)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(selectAndHide:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBack addSubview:self.addressPickView];
    [self.pickerBack addSubview:okBtn];
    self.pickerBack.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pickerBack];
    

}

//获取区域信息
-(void)getOrigin
{
    //请求区域数据
    AFHTTPRequestOperationManager *regionManager = [AFHTTPRequestOperationManager manager];
    NSString *regionUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *regionDic = @{kInterfaceName:@"getaddress",
                                @"address_id":@"021"};
    
    [regionManager POST:regionUrl parameters:regionDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject  objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                
                [self.regionArr addObject:dic];
                
                
            }
    
            [self.addressPickView reloadAllComponents];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取街道信息
-(void)getStreetInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{kInterfaceName:@"getaddress",
                                @"address_id":self.addressInfo.cityID
                                };
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.streetArr removeAllObjects];

            for (NSDictionary *dic in [responseObject objectForKey:@"data"] ) {
                [self.streetArr addObject:dic];
            }
            [self.addressPickView reloadAllComponents];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark -- pickerView
-(void)pickViewCreat
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    self.pickerBack.frame = CGRectMake(0, kHeight-260, kWidth, 260);
    [UIView commitAnimations];
    
    
}

#pragma mark -- tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    PersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (nil == cell) {
        NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:@"PersonInfoTableViewCell" owner:self options:nil];
        cell = cellArr[0];
    }
    
    if (self.existArr.count >0 &&indexPath.row <4) {
        cell.textField.text = self.existArr[indexPath.row];
    }else if (self.addressInfo.addressName.length && self.addressInfo.addressPhoneNum.length && self.addressInfo.detailAddress.length){
        cell.textField.text = self.defaultDataM[indexPath.row];
    }
   
    
    //设置键盘
    if (indexPath.row == 1) {
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
    }
    if (indexPath.row == 2){
        
        [cell.textField resignFirstResponder];
    }
    
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row +4000;
    cell.titleLabel.text = self.detailArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

#pragma mark -- textField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag-4000 == 2) {
        self.tempTextField = textField;
        [textField resignFirstResponder];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self pickViewCreat];
        return NO;
        
    }else if (textField.tag-4000 == 1) {

        return YES;
    }else{
       
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.pickerBack.frame = CGRectMake(0, kHeight, kWidth, 260);
    switch (textField.tag -4000) {
        case 0:
        {
            if ([self.title isEqualToString:@"编辑地址"]) {
                [self.existArr replaceObjectAtIndex:0 withObject:textField.text];
            }else{
                self.addressInfo.addressName = textField.text;
            }
            
        }
            break;
            
        case 1:
        {
            
            if ([self.title isEqualToString:@"编辑地址"]) {
                [self.existArr replaceObjectAtIndex:1 withObject:textField.text];
            }else{
                self.addressInfo.addressPhoneNum = textField.text;

            }
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;

        case 3:
       
        {
            if ([self.title isEqualToString:@"编辑地址"]) {
                [self.existArr replaceObjectAtIndex:3 withObject:textField.text];
            }else{
                self.addressInfo.detailAddress = textField.text;
            }
        }
            
            break;
        default:
            break;
    }
    
    
}


#pragma mark - target-action

-(void)completeEdit:(UIButton *)sender
{

    if ([self.title isEqualToString:@"编辑地址"]) {
        self.addressInfo.addressName = self.existArr[0];
        self.addressInfo.addressPhoneNum = self.existArr[1];
        self.addressInfo.detailAddress = self.existArr[3];
        self.addressInfo.provinceID = @"021";
    }
    
    if (self.addressInfo.addressName.length && self.addressInfo.addressPhoneNum.length && self.addressInfo.detailAddress.length ){
        
        if ([self.title isEqualToString:@"添加地址"]) {
            
            if ([self.addressInfo.userID isEqualToString:@"0"]) {
                
                NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
                
                
                [dicM setObject:self.addressInfo.addressName forKey:kOwnerName];
                [dicM setObject:self.addressInfo.province forKey:kProvince];
                [dicM setObject:self.addressInfo.city forKey:kCity];
                [dicM setObject:self.addressInfo.street forKey:kDistric];
                [dicM setObject:self.addressInfo.streetID forKey:kAddressID];
                [dicM setObject:self.addressInfo.provinceID forKey:@"province"];
                [dicM setObject:self.addressInfo.cityID forKey:@"city"];
                [dicM setObject:self.addressInfo.streetID forKey:@"district"];
                [dicM setObject:self.addressInfo.detailAddress forKey:@"address"];
                [dicM setObject:self.addressInfo.addressPhoneNum forKey:@"mobile"];
                if (self.myAddressBlock) {
                    self.myAddressBlock(dicM);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [self pushAddressData];
            }
            
            
        }else{
            
            [self editAddressDataToService];
        }
        
        
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不能为空，若放弃当前编辑，请直接返回" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView  show];
    }
}

#pragma mark -- returnBlock data
-(void)returnNewAddressInfo:(ReturnTextBlock)myAddressBlock
{
    self.myAddressBlock = myAddressBlock;
}




#pragma mark - pick delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 1;
    }else if(component == 1){
        return self.regionArr.count;
    }else{
        return self.streetArr.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return @"上海";
    }else if(component == 1){
        return [self.regionArr[row]  objectForKey:@"region_name"];
    }else{
        return [self.streetArr[row] objectForKey:@"region_name"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.addressInfo.province = @"上海";
        self.addressInfo.provinceID = @"021";
    }else if (component == 1) {
        
        
        self.addressInfo.city = [self.regionArr[row] objectForKey:@"region_name"];
        self.addressInfo.cityID = [self.regionArr[row] objectForKey:@"region_id"];
        [self getStreetInfo];
        

    }else {
        self.addressInfo.street = [self.streetArr[row] objectForKey:@"region_name"];
        self.addressInfo.streetID = [self.streetArr[row] objectForKey:@"region_id"];
    }
    

}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.addressPickView.bounds.size.width*0.3, 30)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    if (component == 0) {
        label.text = [self pickerView:pickerView titleForRow:row forComponent:0];
    }else if(component == 1){
        label.text = [self pickerView:pickerView titleForRow:row forComponent:1];
    }else{
        label.text = [self pickerView:pickerView titleForRow:row forComponent:2];
    }
    
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

#pragma mark --- target
-(void)selectAndHide:(UIButton *)sender
{
    if (self.streetArr.count) {
        self.tempTextField.text = [NSString stringWithFormat:@"上海%@%@",self.addressInfo.city,self.addressInfo.street];
    }else{
        self.tempTextField.text = [NSString stringWithFormat:@"上海%@",self.addressInfo.city];
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    self.pickerBack.frame = CGRectMake(0, kHeight, kWidth, 260);
    [UIView commitAnimations];
}

#pragma mark -- 数据

-(void)pushAddressData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getconsigneeinfo",
                                @"operation":@"add",
                                kUserID:self.addressInfo.userID,
                                @"consignee":self.addressInfo.addressName, //收货人姓名
                                @"province":self.addressInfo.provinceID,
                                @"city":self.addressInfo.cityID,
                                @"district":self.addressInfo.streetID,
                                @"address":self.addressInfo.detailAddress,
                                @"mobile":self.addressInfo.addressPhoneNum
                                };
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"add address error:%@",error);
    }];
}
//编辑地址
-(void)editAddressDataToService
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getconsigneeinfo",
                                @"operation":@"modify",
                                kUserID:self.addressInfo.userID,
                                @"consignee":self.addressInfo.addressName, //收货人姓名
                                @"province":self.addressInfo.provinceID,
                                @"city":self.addressInfo.cityID,
                                @"district":self.addressInfo.streetID,
                                @"address":self.addressInfo.detailAddress,
                                @"mobile":self.addressInfo.addressPhoneNum,
                                kAddressID:self.modifyAddressID
                                };
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
         NSLog(@"modify address:%@",error);
    }];

}

@end
