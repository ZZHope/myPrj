//
//  DirectAddressViewController.m
//  51CBY
//
//  Created by SJB on 14/12/25.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "DirectAddressViewController.h"
#import "PersonInfoTableViewCell.h"
#import "AddressCell.h"
#import "HomeServiceCell.h"
#import "CbyUserSingleton.h"
#import "AFNetworking.h"
#import "AFNCommon.h"
#import "VerifyViewController.h"

typedef NS_ENUM(NSInteger, BUTTONTYPE) {

    BUTTONTYPEPROVINCE = 1001,
    BUTTONTYPECITY,
    BUTTONTYPESTREET,
    BUTTONTYPEDATE,
    BUTTONTYPETIME
};

#define kHeight  self.view.bounds.size.height
#define kWidth   self.view.bounds.size.width

#define kCity  @"city"
#define kDistribute   @"distribute"
#define kStreet   @"street"
@interface DirectAddressViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic)  UIButton *cityBtn;
@property (strong, nonatomic)  UIButton *distributeBtn;
@property (strong, nonatomic)  UIButton *streetBtn;

@property (strong, nonatomic)  UIButton *timePickBtn;



@property (strong, nonatomic)  UITextField *addressTextField;
@property (strong, nonatomic)  UITextField *serviceDateField;
@property (strong, nonatomic) UIView *pickBackgroundView;
@property (strong, nonatomic) UIPickerView *pickerView;

@property (strong, nonatomic) NSMutableArray *cityArr;
@property (strong, nonatomic) NSMutableArray *distributeArr;
@property (strong, nonatomic) NSMutableArray *streetArr;

@property (strong, nonatomic) NSMutableArray *timeArr;
@property (strong, nonatomic) NSMutableArray *dateArr;
@property (strong, nonatomic) NSArray  *tempArr;


//
@property(nonatomic, strong) NSArray *titleArr;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *btnArr;
@property(nonatomic, strong) NSMutableArray *labelArr;

//日期选择

@property(nonatomic, strong) UIButton *dateBtn;
@property(nonatomic, strong) UIButton *timeBtn;

//共用的button
@property(nonatomic, strong) UIButton *tempBtn;

//日期选择
@property(nonatomic, strong) UIPickerView *serviceDatePicker;
@property(nonatomic, strong) UIPickerView *regionPicker;

//单例
@property(nonatomic, strong) CbyUserSingleton *userInfo;

//解决复用销毁问题

@property(nonatomic, strong) NSArray *infoArr;

//提交参数
@property(nonatomic, strong)  NSMutableArray *goodsPara;



@end

int componentNum = 0;
NSInteger selectNum = 0;

@implementation DirectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //title
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"下订单";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;


  
    /*tableView*/
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];


    
    /*盛放pickerView的背景view*/
    _pickBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, 260)];
    self.pickBackgroundView.backgroundColor = [UIColor lightGrayColor];
    
    /*makeSure*/

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-100, 5, 80, 30)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(makeSureSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickBackgroundView addSubview:button];
    /*pickerView*/
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kWidth, 200)];
    self.pickerView.backgroundColor = [UIColor purpleColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self.pickBackgroundView addSubview:self.pickerView];

    [self.view addSubview:self.pickBackgroundView];
    
    
    /*数据源*/
  
    _cityArr = [NSMutableArray arrayWithArray:@[@{@"region_id":@"021",@"region_name":@"上海"}]];
    self.distributeArr = [NSMutableArray array];
    self.streetArr = [NSMutableArray array];
    
    
    // 请求地址数据
    [self getAddressCityAndDistribute];
    
    //日期和时间
    self.dateArr = [NSMutableArray array];
    self.timeArr = [NSMutableArray array];
    
    // 复用picker
    self.tempArr = [NSArray array];
    self.tempArr = self.cityArr;

    
    
    _titleArr = [NSArray array];
    self.titleArr = @[@"姓名*",@"手机*",@"收货地址*",@"详细地址*",@"服务日期*",@"服务时间*",@"服务方式",@"支付方式",@"使用红包",@"费用"];
    
    
    [self creatCellButton];
   
    
    //celllabel
    
    _labelArr = [NSMutableArray array];
    for (int i=0; i<6; i++) {
         UILabel *label =[self labelCreatWithTitle:self.titleArr[i+4]];
        if (i<2) {
            //红色的星号
            NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:label.text];
            [strAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(label.text.length-1, 1)];
            label.attributedText = strAttr;
        }
        [self.labelArr addObject:label];
    }
    
   
    
    //singleton
    
    _userInfo = [CbyUserSingleton shareUserSingleton];
    //填过数据的情况
    if (self.userInfo.streetID.length) {
        [self getServiceDateTime];
    }
    
    //数据
    _infoArr = [NSArray array];
    
    _goodsPara = [NSMutableArray array];
}

//创建button
-(void)creatCellButton
{
    UIButton *dateTime = [self buttonWithFrame:CGRectMake(100, 10, kWidth*0.4, 30) backImage:[UIImage imageNamed:@"pickButton"] image:nil title:@"请选择"];
    [dateTime addTarget:self action:@selector(selectServiceDate:) forControlEvents:UIControlEventTouchUpInside];
    dateTime.tag = BUTTONTYPEDATE;
    self.dateBtn = dateTime;
    
    
    UIButton *btnTime = [self buttonWithFrame:CGRectMake(100, 10, kWidth*0.4, 30) backImage:[UIImage imageNamed:@"pickButton"] image:nil title:@"请选择"];
    btnTime.tag = BUTTONTYPETIME;
    self.timePickBtn = btnTime;
    [btnTime addTarget:self action:@selector(selectServiceDate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnWay = [self buttonWithFrame:CGRectMake(100, 10, kWidth*0.25,30) backImage:nil image:[UIImage imageNamed:@"选中"] title:@"上门保养"];
    
    UIButton *btnPay  = [self buttonWithFrame:CGRectMake(100, 10, kWidth*0.25, 30) backImage:nil image:[UIImage imageNamed:@"选中"] title:@"货到付款"];
    
    UIButton *prideBtn =[self buttonWithFrame:CGRectMake(100, 10, kWidth*0.4, 30) backImage:[UIImage imageNamed:@"pickButton"] image:nil title:@"没有红包可使用"];
    UIButton *priceBtn;
    if (![self.fromPriceFlag isEqualToString:@"1"]) {
        priceBtn = [self buttonWithFrame:CGRectMake(100, 10, kWidth*0.4, 30) backImage:nil image:nil title:self.priceLabelText];
    }else{
        priceBtn = [self buttonWithFrame:CGRectMake(100, 10, kWidth*0.4, 30) backImage:nil image:nil title:self.priceFromCheck];
        
    }
    
    priceBtn.enabled = NO;
    
    
    self.btnArr = [NSArray array];
    self.btnArr = @[dateTime,btnTime,btnWay,btnPay,prideBtn,priceBtn];
 
}



#pragma mark -- textField的代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//textField 处于第一响应的时候pickView要隐藏

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    self.pickBackgroundView.frame = CGRectMake(0, kHeight, kWidth, 260);
    [UIView commitAnimations];
}
//记录填写的结果方便复用
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        self.userInfo.addressName = textField.text;
    }else if (textField.tag == 101){
     
        self.userInfo.addressPhoneNum = textField.text;
    }else{
        self.userInfo.detailAddress = textField.text;
    }
}


#pragma mark -- tableView delegate/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId1 = @"ID1";
    static NSString *cellId2 = @"ID2";
    static NSString *cellId3 = @"ID3";
    
    
    self.infoArr = @[self.userInfo.addressName,self.userInfo.addressPhoneNum,@[self.userInfo.province,self.userInfo.city,self.userInfo.street],self.userInfo.detailAddress];
    if (indexPath.row < 4 && indexPath.row != 2) {
       PersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (nil == cell) {
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"PersonInfoTableViewCell" owner:self options:nil];
            cell = cellArr[0];
    }
        
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row+100;
        cell.textField.text = self.infoArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = self.titleArr[indexPath.row];
        
        //红色的星号
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:cell.titleLabel.text];
        [strAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(cell.titleLabel.text.length-1, 1)];
        cell.titleLabel.attributedText = strAttr;

        return cell;
    }else if (indexPath.row == 2){
       
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (nil == cell) {
            NSArray *cellArr2 = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
            cell = cellArr2[0];
        }
        
        
        //显示真实数据
        [cell.provinceBtn setTitle:self.infoArr[indexPath.row][0] forState:UIControlStateNormal];
        [cell.cityBtn setTitle:self.infoArr[indexPath.row][1] forState:UIControlStateNormal];
        
   
        [cell.addressBtn setTitle:self.infoArr[indexPath.row][2] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //星标文字星号为红色
        cell.addressLabel.text = self.titleArr[indexPath.row];
        //红色的星号
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:cell.addressLabel.text];
        [strAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(cell.addressLabel.text.length-1, 1)];
        cell.addressLabel.attributedText = strAttr;
        
        
        [cell.provinceBtn addTarget:self action:@selector(showDistricPickerView:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cityBtn addTarget:self action:@selector(showDistricPickerView:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addressBtn addTarget:self action:@selector(showDistricPickerView:) forControlEvents:UIControlEventTouchUpInside];
        
        self.cityBtn = cell.provinceBtn;
        self.distributeBtn = cell.cityBtn;
        self.streetBtn = cell.addressBtn;
        self.cityBtn.tag = BUTTONTYPEPROVINCE;
        self.distributeBtn.tag = BUTTONTYPECITY;
        self.streetBtn.tag = BUTTONTYPESTREET;
        return cell;
       }else  {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId3] ;
        }
        
           [cell.contentView addSubview:self.labelArr[indexPath.row-4]];
           [cell.contentView addSubview:self.btnArr[indexPath.row-4]];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        return cell;
    }
    
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((kWidth-100)*0.5, 5, 100, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn addTarget:self action:@selector(commitBookService:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"提交订单" forState:UIControlStateNormal];
    [backView addSubview:btn];
    
    return backView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

#pragma mark -- target-action

// 显示pickerView

- (void)showDistricPickerView:(UIButton *)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//pickerView展示的时候键盘消失
    
    self.serviceDatePicker = nil;
    self.regionPicker = self.pickerView;
    self.tempBtn = nil;
    self.tempBtn = sender;
    if (sender.tag == BUTTONTYPEPROVINCE) {
        self.tempArr = self.cityArr;
    }else if (sender.tag == BUTTONTYPECITY){
        self.tempArr = self.distributeArr;
    }else{
        self.tempArr = self.streetArr;
    }
    
    [self.pickerView reloadAllComponents];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    self.pickBackgroundView.frame = CGRectMake(0, kHeight-260, kWidth, 260);
    
    [UIView commitAnimations];

    }

//日期选择事件
-(void )selectServiceDate:(UIButton *)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//pickerView展示的时候键盘消失
    self.serviceDatePicker = self.pickerView;
    self.tempBtn = sender;
    if (sender.tag == BUTTONTYPEDATE) {
        self.tempArr = self.dateArr;
    }if (sender.tag == BUTTONTYPETIME) {
        self.tempArr = self.timeArr;
    }
    
    [self.pickerView reloadAllComponents];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    self.pickBackgroundView.frame = CGRectMake(0, kHeight-260, kWidth, 260);
    
    [UIView commitAnimations];
    
}

//请求地址信息
-(void)getAddressCityAndDistribute
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *cityUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *paramterCity = @{@"interfaceName":@"getaddress",@"address_id":@"021"};
    [manager POST:cityUrl parameters:paramterCity success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
            
            
            [self.distributeArr addObject:dic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Province error:%@",error);
        
    }];
    

}


//请求街道信息和服务时间

-(void)makeSureSelect:(UIButton *)sender
{
    
    if (self.tempBtn.tag == BUTTONTYPEPROVINCE) {
        [self.cityBtn setTitle:[self.cityArr[selectNum] objectForKey:@"region_name"] forState:UIControlStateNormal] ;
        self.userInfo.province = [self.cityArr[selectNum] objectForKey:@"region_name"];
        
        
    }else if (self.tempBtn.tag == BUTTONTYPECITY){
        
        if (self.streetArr.count) {
        [self.streetArr removeAllObjects];
        }
        
        if (self.distributeArr.count) {
            
            [self.distributeBtn setTitle:[self.distributeArr[selectNum] objectForKey:@"region_name"] forState:UIControlStateNormal] ;
            self.userInfo.city = [self.distributeArr[selectNum] objectForKey:@"region_name"];
            self.userInfo.cityID = [self.distributeArr[selectNum] objectForKey:@"region_id"];
            
            //根据区域请求街道信息
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *cityUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
            NSDictionary *parameterCity = @{@"interfaceName":@"getaddress",@"address_id":[self.distributeArr[selectNum] objectForKey:@"region_id"]};
            [manager POST:cityUrl parameters:parameterCity success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                    [self.streetArr addObject:dic];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@" error:%@",error);
            }];

        }
       
        
        
    }else if(self.tempBtn.tag == BUTTONTYPESTREET){
        
        if (self.dateArr.count){
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dateArr];
            [arr  removeAllObjects];
            self.dateArr = arr;
        }
       
        if (self.streetArr.count) {
            [self.streetBtn setTitle:[self.streetArr[selectNum] objectForKey:@"region_name"] forState:UIControlStateNormal];
            self.userInfo.street = [self.streetArr[selectNum] objectForKey:@"region_name"];
            self.userInfo.streetID = [self.streetArr[selectNum] objectForKey:@"region_id"];
            
            [self getServiceDateTime];
        }
        
        //推送服务器请求服务日期
    }else if (self.tempBtn.tag == BUTTONTYPEDATE){
        if (self.timeArr.count) {
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.timeArr];
              [arr removeAllObjects];
            self.timeArr = arr;
        }
      
        
        if (self.dateArr.count) {
            [self.dateBtn setTitle:self.dateArr[selectNum] forState:UIControlStateNormal];
            self.userInfo.serviceDate = self.dateArr[selectNum];
            
            //请求服务时间
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *streetUrl  = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
            NSDictionary *parameter = @{@"interfaceName":@"getservicetime",@"province":@"021",@"city":self.userInfo.cityID,@"district":self.userInfo.streetID,@"date":self.userInfo.serviceDate};
            
            [manager POST:streetUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.timeArr = [responseObject objectForKey:@"data"];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@" error:%@",error);
            }];

            
        }
    }else {
        
        if (self.timeArr.count) {
            [self.timePickBtn setTitle:self.timeArr[selectNum] forState:UIControlStateNormal];
            self.userInfo.hourTime = self.timeArr[selectNum];
        }
    }
    
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    self.pickBackgroundView.frame = CGRectMake(0, kHeight, kWidth, 260);
    [UIView commitAnimations];
    selectNum = 0;
    
}

//获取服务日期
-(void)getServiceDateTime
{
    //根据地址信息获取服务日期
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *streetUrl  = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *parameter = @{@"interfaceName":@"getservicedate",@"province":@"021",@"city":self.userInfo.cityID,@"district":self.userInfo.streetID};
    
    [manager POST:streetUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dateArr = [responseObject objectForKey:@"data"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@" error:%@",error);
    }];

}

#pragma mark -- pickerView datasource / delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.tempArr.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.serviceDatePicker) {
        return self.tempArr[row];
    }else{
        
    return [self.tempArr[row] objectForKey:@"region_name"];
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    selectNum = row;
    

}

#pragma mark -- 提交订单
//提交订单
- (void)commitBookService:(UIButton *)sender {
    
    sender.enabled = NO;
    if (self.userInfo.streetID.length && self.userInfo.addressName.length && self.userInfo.addressPhoneNum && self.userInfo.serviceDate.length && self.userInfo.hourTime.length) {
        
    
    
    BOOL matchPhone = [self checkInputTextWithMobileStr:self.userInfo.addressPhoneNum];
   
    if (matchPhone) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *strUrl = registerPhoneUrl;
        NSDictionary *parameter = @{@"mobile":self.userInfo.addressPhoneNum,
                                    @"action":@"putOrder"};
        
        [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"我们已将验证码发送至您的手机，注意查收" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.tag = 5001;
                [alert show];
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"获取验证码失败:%@",error);
            
        }];

        
     }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请完善订单信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
        [alert show];
    }
    
}





#pragma mark -- customButton

-(UIButton *)buttonWithFrame:(CGRect)frame backImage:(UIImage *)backImg image:(UIImage *)image title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setBackgroundImage:backImg forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    return btn;
}


-(UILabel *)labelCreatWithTitle:(NSString *)str
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
    
    label.font = [UIFont systemFontOfSize:15.0f];
    label.text = str;
    return label;
}


#pragma mark -- alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5001) {
        
        VerifyViewController *verifyVC = [[VerifyViewController alloc] init];
        verifyVC.phone = self.userInfo.addressPhoneNum;
        NSMutableArray *tempGoods = [NSMutableArray array];
        for (NSDictionary *dic in self.commitGoods) {
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            [dicM setObject:[dic objectForKey:@"car_id"] forKey:@"car_id"];
            [dicM setObject:[dic objectForKey:@"goods_id"] forKey:@"goods_id"];
            [dicM setObject:[dic objectForKey:@"goods_number"] forKey:@"goods_number"];
            [tempGoods addObject:dicM];
        }
        
        verifyVC.goodsArrFromOrder = tempGoods;
        verifyVC.serviceArrFromOrder = self.commitService;
        verifyVC.carIDOrder = self.orderCarID;
        if ([self.fromPriceFlag isEqualToString:@"1"]) {
            verifyVC.comeFromFlag = 2;
            verifyVC.checkGoods = self.checkGoodsTemp;
        }else{
            verifyVC.comeFromFlag = 1;
        }
        [self presentViewController:verifyVC animated:YES completion:nil];

    }
    
    
}

#pragma mark -- 验证手机合法性

//验证输入框中的信息
- (BOOL)checkInputTextWithMobileStr:(NSString *)str
{
    NSString *tempNumberString = str;
    
    //验证手机号码
    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|7[6-8]|8[0-9])\\d{8}$";
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"self MATCHES %@", mobile];
    
    if ([regexMobile evaluateWithObject:tempNumberString]) {
        return YES;
    } else {
        UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
