//
//  LoginViewController.m
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "LoginViewController.h"
#import "SJBManager.h"
#import "RegViewController.h"
#import "CbyDataBaseManager.h"
#import "DBCommon.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import "AFNCommon.h"
#import "CbyUserSingleton.h"

#define width   self.view.bounds.size.width
#define height  self.view.bounds.size.height

@interface LoginViewController ()<UITextFieldDelegate>
@property (assign,nonatomic) BOOL success;
@property (weak, nonatomic) IBOutlet UITextField *user_id;

@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *getPwd;
@property (strong, nonatomic) UIImageView *backImgView;

@property (strong, nonatomic) CbyUserSingleton *userLoginInfo;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*修改界面上的细节*/
    self.backView.layer.cornerRadius = 5.0f;
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.registerBtn.layer.cornerRadius = 5.0f;
    UIImage *img = [[UIImage imageNamed:@"login-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(470, 319, 470, 319) resizingMode:UIImageResizingModeStretch];

    
    self.view.layer.contents = (id) img.CGImage;
    
   
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _user_id.text = [user objectForKey:@"userName"];
        _pwd.text = [user objectForKey:@"pwd"];
    

    
    
}


#pragma mark -- 登录并写入磁盘
- (IBAction)loginEvent:(UIButton *)sender {
    
    [self.pwd resignFirstResponder];
    [self.user_id resignFirstResponder];
    
    
    
    /*推送账号和密码*/
   
    if ([self.user_id.text isEqualToString:@""]||[self.pwd.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        
        //正则验证手机号码是否为手机号格式
        if ([self checkInputText]){
        //加密
        NSString *pwdStr = [self md5SecretePwd];
       
        [MBProgressHUD  showMessage:@"小保正在为您努力验证。。。" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameter = @{@"interfaceName":@"login",
                                    @"userName":self.user_id.text,
                                    @"password":pwdStr};
            NSString *loginUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_userinfo.php"];
        
        [manager POST:loginUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            sender.enabled = YES;
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
               
                //用单例记录全局的登录和用户ID
                [CbyUserSingleton shareUserSingleton].isLogin = YES;
                [CbyUserSingleton shareUserSingleton].userID = [[responseObject objectForKey:@"data"] objectForKey:@"user_id"];
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"user_real_name"] length]) {
                
                    [CbyUserSingleton shareUserSingleton].userName = [[responseObject objectForKey:@"data"] objectForKey:@"user_real_name"];
                }else{
                    [CbyUserSingleton shareUserSingleton].userName = [[responseObject objectForKey:@"data"] objectForKey:@"user_name"];
                }
                
                //存储数据
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:[CbyUserSingleton shareUserSingleton].userName forKey:@"userName"];
                [user setObject:self.pwd.text forKey:@"pwd"];
                [user setBool:YES forKey:@"remPwd"];
                [user setBool:YES forKey:@"autoLogin"];
                [user setBool:self.success forKey:@"successLogin"];
                [user setObject:[[responseObject objectForKey:@"data"] objectForKey:@"user_id"] forKey:@"userID"];
                
                //进行写入磁盘
                
                [user synchronize];

                if ([self.strFromSecret isEqualToString:@"goHome"]) {
                    [SJBManager prsentSJBControllerWithType:SJBControllerTypeMainView];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
                

                
            }else if([[responseObject objectForKey:@"status"] isEqualToString:@"noUser"]){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户不存在" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                
            }else{
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或者密码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            sender.enabled = YES;
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
            NSLog(@"%@",error);
            
        }];
        }
    }
    
   
   }

//注册
- (IBAction)registerUserID:(UIButton *)sender {
    
    RegViewController *regVC = [[RegViewController alloc]init];
    [self presentViewController:regVC animated:YES completion:nil];
}

//重置密码

- (IBAction)forgetPwd:(UIButton *)sender {
    
    RegViewController *regVC = [[RegViewController alloc]init];
    regVC.resetFlag = @"reset";
    [self presentViewController:regVC animated:YES completion:nil];
    
}

#pragma mark -- 跳出登录界面
- (IBAction)cancelLogin:(UIButton *)sender {
    
   [self dismissViewControllerAnimated:YES completion:nil];
   // [SJBManager prsentSJBControllerWithType:SJBControllerTypeMainView];
}



#pragma mark -- textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.user_id resignFirstResponder];
    [self.pwd resignFirstResponder];
}

#pragma mark -- MD5

//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];//以十六进制形式输出，不足两位的前面补零
    
    return result;
    
    
}

//返回一个加密后的密码
-(NSString *)md5SecretePwd
{
    NSString *pwdStr = self.pwd.text;
    //加盐的字符串与网站不一致，暂时去掉了
   // NSString *token = @"0aea668c94f86ce34cf55fb1f2509cbd";
   // NSString *token = @"51cby";
    //pwdStr = [pwdStr stringByAppendingString:token];
    pwdStr = [self getMd5_32Bit_String:pwdStr];
    return pwdStr;
}





#pragma mark - 正则表达式验证手机号

//验证输入框中的信息
- (BOOL)checkInputText
{
    NSString *tempNumberString = self.user_id.text;
    
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
    return YES;
}



@end
