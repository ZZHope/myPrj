//
//  SettingPWDViewController.m
//  51CBY
//
//  Created by SJB on 15/1/30.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "SettingPWDViewController.h"
#import "AFNCommon.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "SJBManager.h"
#import "CbyUserSingleton.h"
#import "LoginViewController.h"

@interface SettingPWDViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *setPwd; //设置密码
@property (weak, nonatomic) IBOutlet UITextField *surePwd;//确认密码
@end

@implementation SettingPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景图片
    UIImage *img = [[UIImage imageNamed:@"login-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(470, 319, 470, 319) resizingMode:UIImageResizingModeStretch];
 
    self.view.layer.contents = (id) img.CGImage;

    
    
}
- (IBAction)makeSureCommitPWD:(UIButton *)sender {
    
    [self.setPwd resignFirstResponder];
    [self.surePwd resignFirstResponder];
    
    if (self.setPwd.text.length && [self.surePwd.text isEqualToString:self.setPwd.text]) {
        
        if ([self checkInputPWDText]) {
  
            NSString *pwdMD5 = [self md5SecretePwd];
            [MBProgressHUD showMessage:@"正在帮您注册。。。" toView:self.view];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *registerUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_userinfo.php"];
            NSDictionary *paramter;
            if ([self.loopSetting isEqualToString:@"reset"]) {
                paramter = @{@"interfaceName":@"resetPassword",
                             @"userName":self.phoneNum,
                             @"password":pwdMD5};

            }else{
                
                paramter = @{@"interfaceName":@"register",
                             @"userName":self.phoneNum,
                             @"password":pwdMD5};
            }
            
            
            
            [manager POST:registerUrl parameters:paramter success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                    if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
                        LoginViewController *loginVC = [[LoginViewController alloc] init];
                        loginVC.strFromSecret = @"goHome";
                        [self presentViewController:loginVC animated:YES completion:nil];
                        
                    }
 
                    
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"setting error: %@",error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误提示" message:@"网络不给力" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                
            }];
            
        }
        
    }
}


#pragma mark -- textField delegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.setPwd resignFirstResponder];
    [self.surePwd resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backToLastView:(UIButton *)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 密码用正则过滤
//验证输入框中的信息
- (BOOL)checkInputPWDText
{
    NSString *tempKeyString  = self.setPwd.text;
    
    //正则匹配
   // NSString *checkText = @"[A-z0-9]{6,12}";
    NSString *checkText = @"^(?:(?!\\s).){6,12}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self MATCHES %@", checkText];
    if ([predicate evaluateWithObject:tempKeyString]) {
        return YES;
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"密码格式有误" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
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
    NSString *pwdStr = self.setPwd.text;
    //暂时去掉了加盐
   // NSString *token = @"0aea668c94f86ce34cf55fb1f2509cbd";
    //pwdStr = [pwdStr stringByAppendingString:token];
    pwdStr = [self getMd5_32Bit_String:pwdStr];
    return pwdStr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
