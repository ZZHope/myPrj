

#import "RegViewController.h"
#import "VerifyViewController.h"
#import "AFNetworking.h"
#import "AFNCommon.h"

@interface RegViewController ()
{
    NSString* _str;
    NSMutableData* _data;
    int _state;
    NSString* _localPhoneNumber;
    
    NSString* _localZoneNumber;
    NSString* _appKey;
    NSString* _duid;
    NSString* _token;
    NSString* _appSecret;
    
    NSMutableArray* _areaArray;
    NSString* _defaultCode;
    NSString* _defaultCountryName;
    NSString* _tipStr;
    UIAlertView *_senderAlert;
}
@property(nonatomic, strong) UIButton* nextBtn;
@property(nonatomic, copy) NSString *phoneNumRegister;
@property(nonatomic, copy) NSString *phoneCodeRegister;


@end

@implementation RegViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIImage *img = [[UIImage imageNamed:@"login-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(470, 319, 470, 319) resizingMode:UIImageResizingModeStretch];
    
    
    self.view.layer.contents = (id) img.CGImage;
    //返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    
    //区域码
    UITextField* areaCodeField=[[UITextField alloc] init];
    areaCodeField.frame=CGRectMake((self.view.bounds.size.width-265)*0.5, 155+statusBarHeight, 60, 35+statusBarHeight/4);
    areaCodeField.borderStyle=UITextBorderStyleBezel;
    areaCodeField.text=[NSString stringWithFormat:@"+86"];
    areaCodeField.textAlignment=NSTextAlignmentCenter;
    areaCodeField.font=[UIFont fontWithName:@"Helvetica" size:18];
    areaCodeField.keyboardType=UIKeyboardTypePhonePad;
    [self.view addSubview:areaCodeField];
    
    //输入手机号码的框
    UITextField* telField=[[UITextField alloc] init];
    telField.frame=CGRectMake(CGRectGetMaxX(areaCodeField.frame)+5, 155+statusBarHeight, 200, 35+statusBarHeight/4);
    telField.borderStyle=UITextBorderStyleBezel;
    telField.placeholder=@"手机号码";
    telField.keyboardType=UIKeyboardTypePhonePad;
    telField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:telField];
    
    //验证
    _nextBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
    self.nextBtn.frame=CGRectMake((self.view.bounds.size.width-265)*0.5, 220+statusBarHeight, 265, 42);
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    _telField = telField;
    _areaCodeField = areaCodeField;
    
    self.areaCodeField.delegate=self;
    self.telField.delegate=self;

}



-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        _window.hidden=YES;
    }];
}

#pragma mark -- 国家代码，需要改动
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //不允许用户输入 国家码
    if (textField ==_areaCodeField)
    {
        [self.view endEditing:YES];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(void)nextStep
{
    
    [MBProgressHUD showMessage:@"正在验证..." toView:self.view];
    
    int compareResult = 0;
    
        compareResult=1;
           // NSString* rule1=[dict1 valueForKey:@"rule"];// rule = "^\\d+"
            NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^1(3[0-9]|4[57]|5[0-35-9]|7[6-8]|8[0-9])\\d{8}$"];
            BOOL isMatch=[pred evaluateWithObject:self.telField.text];
            /*是否注册过*/
            //验证手机号码是否已经注册
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameter = @{@"interfaceName":@"verify",
                                        @"userName":self.telField.text
                                        };
          //  NSString *regUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_userinfo.php"];
            NSString *regUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_userinfo.php"];

            
            [manager POST:regUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
               
                self.nextBtn.enabled = YES;
                
                if ([[responseObject objectForKey:@"status"] isEqualToString:@"userRegisted"]) {
                    if (![self.resetFlag isEqualToString:@"reset"]) {
                        
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机号已注册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"直接登录", nil];
                    alert.tag = 2001;
                    alert.delegate = self;
                    [alert show];
                }else{
                    
                    VerifyViewController* verify=[[VerifyViewController alloc] init];
                    [verify setPhone:self.telField.text AndAreaCode:@"86"];
                    verify.comeFromFlag = 3;
                    
                    [self registerPhoneNum:self.telField.text toController:verify];
                    
                }
            }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    _str=[NSString stringWithFormat:@"%@",self.telField.text];
                    if(_str.length){
                    
                   
                
                    //确认手机号
                        //提示框
                        _tipStr=[NSString stringWithFormat:@"%@:%@ %@",@"验证码将发送至",self.areaCodeField.text,self.telField.text];
                        _senderAlert=[[UIAlertView alloc] initWithTitle:@"手机号确认" message:_tipStr delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确定", nil];
                        _senderAlert.tag = 1001;
                   
                        [_senderAlert show];
                    }                    
                    
                    
                    
                }
                
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSLog(@"error:%@",error);
                 self.nextBtn.enabled = YES;
                
            }];
            
            if (!isMatch)
            {
                //手机号码不正确
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                              message:@"手机号码错误"
                                                             delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
    
    if (!compareResult)
    {
        if (self.telField.text.length!=11)
        {
            //手机号码不正确
           UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"手机号码错误"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
        if (alertView.tag == 2001) { //手机号码已经注册 2001
            
            if (1==buttonIndex) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }else{
            if (1==buttonIndex)
            {
                
                VerifyViewController* verify=[[VerifyViewController alloc] init];
                [verify setPhone:self.telField.text AndAreaCode:@"86"];
//                if ([self.resetFlag isEqualToString:@"reset"]) {
//                    verify.comeFromFlag = 3;
//                }
                
                
                [self registerPhoneNum:self.telField.text toController:verify];
                
            }
            if (0==buttonIndex){}
        }

    }
    

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



#pragma mark -- 注册手机号
-(void)registerPhoneNum:(NSString *)phoneNum toController:(UIViewController *)controller
{
    [MBProgressHUD showMessage:@"正在注册" toView:self.view];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = registerPhoneUrl;
    NSDictionary *parameter;
    if ([self.resetFlag isEqualToString:@"reset"]) {
        parameter = @{@"mobile":phoneNum,
                      @"action":@"resetPassword"};

    }else{
        
        parameter = @{@"mobile":phoneNum,
                      @"action":@"register"};

    }
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            self.phoneNumRegister = [responseObject objectForKey:@"mobile"];
            self.phoneCodeRegister = [responseObject objectForKey:@"code"];
            [self presentViewController:controller animated:YES completion:nil];
           
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"注册失败:%@",error);
        
    }];
    
}

#pragma mark -- 返回上一页
-(void)backToLastView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
