//
//  VerifyViewController.m
//
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "VerifyViewController.h"
#import "SettingPWDViewController.h"
#import "AFNCommon.h"
#import "AFNetworking.h"
#import "CbyUserSingleton.h"


@interface VerifyViewController ()
{
//    NSString* _phone;
    NSString* _areaCode;
    NSMutableArray* _addressBookTemp;
    NSTimer* _timer1;
    NSTimer* _timer2;
    
    UIAlertView* _alert1;
    UIAlertView* _alert2;
    UIAlertView* _alert3;
    UIAlertView* _alert4;
    UIAlertView* _alert5;
    CbyUserSingleton *_userVerify;

}

@end

static int count = 0;

//最近新好友信息
static NSMutableArray* _userData2;

@implementation VerifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    //背景图片
    UIImage *img = [[UIImage imageNamed:@"login-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(470, 319, 470, 319) resizingMode:UIImageResizingModeStretch];
    
    
    self.view.layer.contents = (id) img.CGImage;
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    
    
    //设置返回的按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    UILabel* label=[[UILabel alloc] init];
    label.frame=CGRectMake(20, 53+statusBarHeight, 280, 21);
    label.text=[NSString stringWithFormat:@"验证的手机号为"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    [self.view addSubview:label];
    
    //手机号显示
    _telLabel=[[UILabel alloc] init];
    _telLabel.frame=CGRectMake(85, 82+statusBarHeight, 158, 21);
    _telLabel.textAlignment = NSTextAlignmentCenter;
    _telLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [self.view addSubview:_telLabel];
    self.telLabel.text= [NSString stringWithFormat:@"+86 %@",_phone];
    
    //验证码输入框
    _verifyCodeField=[[UITextField alloc] init];
    _verifyCodeField.frame=CGRectMake(85, 111+statusBarHeight, 158, 46);
    _verifyCodeField.borderStyle=UITextBorderStyleBezel;
    _verifyCodeField.textAlignment=NSTextAlignmentCenter;
    _verifyCodeField.placeholder=@"请输入验证码";
    _verifyCodeField.font=[UIFont fontWithName:@"Helvetica" size:18];
    _verifyCodeField.keyboardType=UIKeyboardTypePhonePad;
    _verifyCodeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:_verifyCodeField];
    
    _timeLabel=[[UILabel alloc] init];
    _timeLabel.frame=CGRectMake(64, 169+statusBarHeight, 200, 40);
    _timeLabel.numberOfLines = 0;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _timeLabel.text= @"倒计时";
    [self.view addSubview:_timeLabel];
    
    //重新获取验证码
    _repeatSMSBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    _repeatSMSBtn.frame=CGRectMake(96, 169+statusBarHeight, 137, 30);
    [_repeatSMSBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
    [_repeatSMSBtn addTarget:self action:@selector(CannotGetSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_repeatSMSBtn];
    
    _submitBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
    _submitBtn.frame=CGRectMake(20, 220+statusBarHeight, self.view.bounds.size.width-40, 42);
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    self.repeatSMSBtn.hidden=YES;
    
    [_timer2 invalidate];
    [_timer1 invalidate];
    
    count = 0;
    
    NSTimer* timer=[NSTimer scheduledTimerWithTimeInterval:60
                                                    target:self
                                                  selector:@selector(showRepeatButton)
                                                  userInfo:nil
                                                   repeats:YES];
    
    NSTimer* timer2=[NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(updateTime)
                                                   userInfo:nil
                                                    repeats:YES];
    _timer1=timer;
    _timer2=timer2;
    
   //user
    _userVerify = [CbyUserSingleton shareUserSingleton];
    
    //数据
    _goodsTemp = [NSMutableArray array];
    
}



-(void)setPhone:(NSString*)phone AndAreaCode:(NSString*)areaCode
{
    _phone=phone;
    _areaCode=areaCode;
}

-(void)submit
{
    //验证号码

    [self.view endEditing:YES];
    
    if(self.verifyCodeField.text.length!=6)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"验证码格式错误"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
         [self commitCodeWithPhone:_phone andCode:self.verifyCodeField.text];
        
        
        
    }
}

#pragma mark -- 重新获取验证码
-(void)CannotGetSMS
{
    NSString* str=[NSString stringWithFormat:@"%@:%@",@"重新获取验证码" ,_phone];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"手机号确认" message:str delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确定", nil];
    _alert1=alert;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==_alert1)
    {
        if (1==buttonIndex)
        {
            NSLog(@"重发验证码");

            [self getCodeAgain];
        }
        
    }
    
    if (alertView==_alert2) {
        if (0==buttonIndex)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [_timer2 invalidate];
                [_timer1 invalidate];
            }];
        }
    }
    
    if (alertView==_alert3)
    {
        if (self.comeFromFlag == 1) {
            
        [self requestOrderFromSever];
            
        }else if (self.comeFromFlag == 2){
            
        [self checkOrderCommit];
            
        }else if (self.comeFromFlag == 3){
            SettingPWDViewController *setPWDVC = [[SettingPWDViewController alloc]init];
            setPWDVC.loopSetting = @"reset";
            
            
            setPWDVC.phoneNum = _phone;
            [self presentViewController:setPWDVC animated:YES completion:^{
                //解决等待时间乱跳的问题
                [_timer2 invalidate];
                [_timer1 invalidate];
                
            }];

            
        }else{
            SettingPWDViewController *setPWDVC = [[SettingPWDViewController alloc]init];
        
            
            setPWDVC.phoneNum = _phone;
            [self presentViewController:setPWDVC animated:YES completion:^{
                //解决等待时间乱跳的问题
                [_timer2 invalidate];
                [_timer1 invalidate];
                
            }];

        }
       
    }
    if (alertView == _alert4) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    if (alertView == _alert5) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




-(void)updateTime
{
    count++;
    if (count>=60)
    {
        [_timer2 invalidate];
        return;
    }
    self.timeLabel.text=[NSString stringWithFormat:@"%@%i%@",@"还有",60-count,@"秒"];
    
}

-(void)showRepeatButton{
    self.timeLabel.hidden=YES;
    self.repeatSMSBtn.hidden=NO;
    
    [_timer1 invalidate];
    return;
}


#pragma mark -- 提交验证码

-(void)commitCodeWithPhone:(NSString *)mobileNum andCode:(NSString *)code
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = registerPhoneUrl;
    NSDictionary *parameter = @{@"mobile":mobileNum,
                                @"code":code,
                                @"from":@"APP",
                                @"action":@"check"
                                };
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"验证码提示" message:@"验证码发送成功"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"确定"
                                                                    otherButtonTitles:nil, nil];
            [alert show];
            _alert3=alert;

        }else{
            NSLog(@"验证失败");
            NSString* str=[NSString stringWithFormat:@"验证码信息错误"];
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"验证码提示"
                                                          message:str
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
            [alert show];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"verify failure: %@",error);
        
    }];
}


#pragma mark -- 提交订单
-(void)requestOrderFromSever
{
    if (_userVerify.addressName.length && _userVerify.addressPhoneNum.length&& _userVerify.city.length&& _userVerify.street.length&&_userVerify.serviceDate.length && _userVerify.hourTime.length) {
        
                //与服务器对接
                NSString *strUrl = kOrderUrl;
                AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
                NSDictionary *para = @{@"interfaceName":@"putOrderNoCart",
                                       @"user_id":_userVerify.userID,
                                       @"province":@"021",
                                       @"city":_userVerify.cityID,
                                       @"district":_userVerify.streetID,
                                       @"address":_userVerify.detailAddress,
                                       @"serviceDate":_userVerify.serviceDate,
                                       @"serviceTime":_userVerify.hourTime,
                                       @"consigneeName":_userVerify.addressName,//收货人姓名
                                       @"mobile":_userVerify.addressPhoneNum,
                                       @"shipping_id":@"1", //上门服务
                                       @"pay_id":@"5", //货到付款
                                       @"goods_info":self.goodsArrFromOrder
                                       };
        
                [manager POST:strUrl parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                  
                    if ([[responseObject  objectForKey:@"status"]isEqualToString:@"ok"]) {
        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: @"提交订单成功,订单编号为%@",[responseObject objectForKey:@"data"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        _alert4 = alert;
                        [alert show];
        
                    }
        
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"commit order error:%@",error);
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络不给力，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }];
        
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请完善信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }

}

//提交免费检测订单
-(void)checkOrderCommit
{
    [MBProgressHUD showMessage:@"正在提交。。。" toView:self.view];
    if (_userVerify.addressName.length && _userVerify.addressPhoneNum.length&& _userVerify.city.length&& _userVerify.street.length&&_userVerify.serviceDate.length && _userVerify.hourTime.length) {
        
        NSArray *arr = [NSArray array];
        arr = @[self.checkGoods];
    //与服务器对接
    NSString *strUrl = kOrderUrl;
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = @{@"interfaceName":@"putOrderNoCart",
                           @"user_id":_userVerify.userID,
                           @"province":@"021",
                           @"city":_userVerify.cityID,
                           @"district":_userVerify.streetID,
                           @"address":_userVerify.detailAddress,
                           @"serviceDate":_userVerify.serviceDate,
                           @"serviceTime":_userVerify.hourTime,
                           @"consigneeName":_userVerify.addressName,//收货人姓名
                           @"mobile":_userVerify.addressPhoneNum,
                           @"shipping_id":@"1", //上门服务
                           @"pay_id":@"5", //货到付款
                           @"goods_info":arr
                           };
    
    [manager POST:strUrl parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [MBProgressHUD hideHUDForView:self.view];
 
        if ([[responseObject  objectForKey:@"status"]isEqualToString:@"ok"]) {
          
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: @"提交订单成功,订单编号为%@",[responseObject objectForKey:@"data"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            _alert5 = alert;
            [alert show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [MBProgressHUD hideHUDForView:self.view];
        NSLog(@" check commit order error:%@",error);
        
    }];
     }else{
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请完善信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
         
     }

}


#pragma mark -- 重新获取验证码
-(void)getCodeAgain
{
    count = 0;
    NSTimer* timer=[NSTimer scheduledTimerWithTimeInterval:60
                                                    target:self
                                                  selector:@selector(showRepeatButton)
                                                  userInfo:nil
                                                   repeats:YES];
    
    NSTimer* timer2=[NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(updateTime)
                                                   userInfo:nil
                                                    repeats:YES];
    _timer1 = timer;
    _timer2 = timer2;

    
    self.timeLabel.hidden = NO;
    self.repeatSMSBtn.hidden = YES;
    //[self updateTime];
}

#pragma mark -- 返回按钮
-(void)backToLastView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
