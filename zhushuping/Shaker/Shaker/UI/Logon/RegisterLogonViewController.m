//
//  RegisterLogonViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/5/7.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "RegisterLogonViewController.h"
#import "ColorHandler.h"
#import "HomeViewController.h"
#import "UserInfoViewController.h"
#import "ForgetPasswordViewController.h"
#import "Contants.h"
#import "ImageControl.h"

@interface RegisterLogonViewController ()

@end

@implementation RegisterLogonViewController {
    NavigationBar *navigationBar;
    UITextField *accountTextField;
    UITextField *passwordTextField;
    UITextField *confirmPasswordTextField;
    NSString *userType;
    UITapGestureRecognizer *tap;
}

- (void)viewWillAppear:(BOOL)animated {
    [ShareEngine sharedInstance].delegate = self;
    [self buildNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [ShareEngine sharedInstance].delegate = nil;
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    if (navigationBar) {
        [navigationBar removeFromSuperview];
        navigationBar = nil;
    }
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    
    [navigationBar setLeftBtnWithString:@"返回" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:_flag==LOGON?@"登录":@"注册"];
    [title addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#2a2a2a"] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
    [navigationBar setTitleTextView:title];

    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    [self buildView];
}

- (void)buildView {
    if (_flag == LOGON) {
        [self buildLogonView];
    } else if (_flag == REGISTER) {
        [self buildRegisterView];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册/登录" message:@"注册或登录出错，请重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = 1;
        [alert show];
    }
}

- (void)buildLogonView {
    UILabel *paddingLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    UILabel *paddingLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(26, 77, viewWidth-26*2, 40)];
    accountTextField.tag = 1;
    accountTextField.delegate = self;
    accountTextField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    accountTextField.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的邮箱" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#2a2a2a"],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    accountTextField.font = [UIFont systemFontOfSize:12];
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTextField.leftView = paddingLabel1;
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:accountTextField];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(26, 142, viewWidth-26*2, 40)];
    passwordTextField.tag = 2;
    passwordTextField.delegate = self;
    passwordTextField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    passwordTextField.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#2a2a2a"],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    passwordTextField.font = [UIFont systemFontOfSize:12];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.leftView = paddingLabel2;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:passwordTextField];
    
    UIImage *forgotPasswordImage = [UIImage imageNamed:@"forgetpassword"];
    UIImageView *forgotPasswordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(passwordTextField.frame.origin.x+passwordTextField.bounds.size.width-forgotPasswordImage.size.width, passwordTextField.frame.origin.y+passwordTextField.bounds.size.height+15, forgotPasswordImage.size.width, forgotPasswordImage.size.height)];
    forgotPasswordImageView.image = forgotPasswordImage;
    [self.view addSubview:forgotPasswordImageView];
    
    UIControl *forgotPasswordCtl = [[UIControl alloc] initWithFrame:CGRectMake(forgotPasswordImageView.frame.origin.x-20, forgotPasswordImageView.frame.origin.y-10, forgotPasswordImageView.bounds.size.width+30, forgotPasswordImageView.bounds.size.height+20)];
    [forgotPasswordCtl addTarget:self action:@selector(gotoForgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPasswordCtl];
    
    UIButton *logonBtn = [[UIButton alloc] initWithFrame:CGRectMake(26, 234, viewWidth-26*2, 40)];
    logonBtn.backgroundColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    [logonBtn setTitle:@"立即加入" forState:UIControlStateNormal];
    logonBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [logonBtn addTarget:self action:@selector(logon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logonBtn];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(26, 329, viewWidth-26*2, 1)];
    line.backgroundColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    [self.view addSubview:line];
    
    UILabel *otherLogonLabel = [self buildLabel:@"使用第三方登录" :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:12]];
    [otherLogonLabel setFrame:CGRectMake((viewWidth-otherLogonLabel.bounds.size.width)/2, 389, otherLogonLabel.bounds.size.width, otherLogonLabel.bounds.size.height)];
    [self.view addSubview:otherLogonLabel];
    
    UIImage *wechatImage = [UIImage imageNamed:@"wechat_logon_icon"];
    UIImageView *wechatImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth/2-wechatImage.size.width)/2, 438, wechatImage.size.width, wechatImage.size.height)];
    wechatImageView.image = wechatImage;
    UIControl *wechatCtl = [[UIControl alloc] initWithFrame:CGRectMake(wechatImageView.frame.origin.x-10, wechatImageView.frame.origin.y-10, wechatImageView.bounds.size.width+20, wechatImageView.bounds.size.height+20)];
    [wechatCtl addTarget:self action:@selector(wechatLogon) forControlEvents:UIControlEventTouchUpInside];
    if ([WXApi isWXAppInstalled]) {
        [self.view addSubview:wechatImageView];
        [self.view addSubview:wechatCtl];
    }
    

    UIImage *weiboImage = [UIImage imageNamed:@"weibo_logon_icon"];
    UIImageView *weiboImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth/2-wechatImage.size.width)/2+viewWidth/2, 438, weiboImage.size.width, weiboImage.size.height)];
    weiboImageView.image = weiboImage;
    UIControl *weiboCtl = [[UIControl alloc] initWithFrame:CGRectMake(weiboImageView.frame.origin.x-10, weiboImageView.frame.origin.y-10, weiboImageView.bounds.size.width, weiboImageView.bounds.size.height)];
    [weiboCtl addTarget:self action:@selector(weiboLogon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboImageView];
    [self.view addSubview:weiboCtl];
    
}

- (void)buildRegisterView {
    UILabel *paddingLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    UILabel *paddingLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    UILabel *paddingLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(26, 77, viewWidth-26*2, 40)];
    accountTextField.tag = 1;
    accountTextField.delegate = self;
    accountTextField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    accountTextField.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的邮箱" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#2a2a2a"],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    accountTextField.font = [UIFont systemFontOfSize:12];
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTextField.leftView = paddingLabel1;
    accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:accountTextField];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(26, 132, viewWidth-26*2, 40)];
    passwordTextField.tag = 2;
    passwordTextField.delegate = self;
    passwordTextField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    passwordTextField.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#2a2a2a"],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    passwordTextField.font = [UIFont systemFontOfSize:12];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.leftView = paddingLabel2;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:passwordTextField];
    
    confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(26, 187, viewWidth-26*2, 40)];
    confirmPasswordTextField.tag = 3;
    confirmPasswordTextField.delegate = self;
    confirmPasswordTextField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    confirmPasswordTextField.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入您的密码" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#2a2a2a"],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    confirmPasswordTextField.font = [UIFont systemFontOfSize:12];
    confirmPasswordTextField.secureTextEntry = YES;
    confirmPasswordTextField.leftView = paddingLabel3;
    confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:confirmPasswordTextField];
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(26, 290, viewWidth-26*2, 40)];
    registerBtn.backgroundColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerBtn addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (void)registerAccount {
    userType = @"mail";
    if (![self isValidEmail:accountTextField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册" message:@"请输入正确的邮箱" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    if (![self verifyPassword]) {
        UIAlertView *passwordAlertView = [[UIAlertView alloc] initWithTitle:@"设置密码" message:@"密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [passwordAlertView show];
        return;
    }
    if (![self confirmPassword]) {
        UIAlertView *confirmPasswordAlertView = [[UIAlertView alloc] initWithTitle:@"设置密码" message:@"密码不一致，请重新输入密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [confirmPasswordAlertView show];
        return;
    }
    //register on server
    NSString *registerService = @"/services/user/";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,registerService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:accountTextField.text forKey:@"username"];
    [dic setValue:passwordTextField.text forKey:@"password"];
    [dic setValue:_deviceToken?_deviceToken:@"" forKey:@"deviceToken"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];

    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success register on phone
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            UserInfo * user = [UserInfo new];
            user.userID = accountTextField.text;
            user.password = passwordTextField.text;
            user.ID = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            [self createAccount:user];
        } else if ([[dataDic valueForKey:@"data"] isEqualToString:@"USER_ALREADY_EXIST"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册账号" message:@"邮箱已被注册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册账号" message:@"服务器出现问题，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }];
    
    [sessionDataTask resume];
    //TODO HUD
}

- (void)registerOther:(UserInfo *)user {
    NSString *registerService = @"/services/user/";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,registerService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:user.userID forKey:@"username"];
    [dic setValue:otherLogonPassword forKey:@"password"];
    [dic setValue:user.deviceToken forKey:@"deviceToken"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];

    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success register on phone
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            user.ID = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            [self createAccount:user];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录" message:@"系统繁忙，请稍后尝试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }];
    
    [sessionDataTask resume];
    
}

- (void)logon {
    if (![self isValidEmail:accountTextField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录" message:@"请输入正确的邮箱" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    if (![self verifyPassword]) {
        UIAlertView *passwordAlertView = [[UIAlertView alloc] initWithTitle:@"设置密码" message:@"密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [passwordAlertView show];
        return;
    }
    
    NSString *loginService = @"/services/user/login";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,loginService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:accountTextField.text forKey:@"username"];
    [dic setValue:passwordTextField.text forKey:@"password"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            UserInfo *user = [UserInfo new];
            user.userID = accountTextField.text;
            user.password = passwordTextField.text;
            user.ID = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            user.name = [[dataDic objectForKey:@"data"] objectForKey:@"nickname"] ;//? @"" : [[dataDic objectForKey:@"data"] objectForKey:@"nickname"];20150610
            user.photo = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST_4,[[dataDic objectForKey:@"data"] objectForKey:@"profile"]]]];//20150610
            [self loginApp:user];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"邮箱或密码不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)logon:(UserInfo *)user {
    NSString *loginService = @"/services/user/login";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,loginService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:user.userID forKey:@"username"];
    [dic setValue:user.password forKey:@"password"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            user.ID = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            [self loginApp:user];
        }
    }];
    [sessionDataTask resume];
}

- (void)wechatLogon {
    userType = @"WX";
    [[ShareEngine sharedInstance] sendAuthRequest];
}

- (void)weiboLogon {
    userType = @"WB";
    [[ShareEngine sharedInstance] sendSSOAuthRequest];
}

- (void)didLogon:(NSString *)logonType :(NSDictionary *)userDic {
    if ([logonType isEqualToString:@"WX"]) {
        UserInfo *user = [UserInfo new];
        user.userID = [[NSString alloc] initWithFormat:@"WX-%@",[userDic valueForKey:@"unionid"]];
        user.name = [userDic valueForKey:@"nickname"];
        user.password = otherLogonPassword;
        user.photo = [self getUserPic:[userDic valueForKey:@"headimgurl"]];
        if (_deviceToken) {
            user.deviceToken = _deviceToken;
        } else {
            user.deviceToken = @"";
        }
        //check whether user exists on server. if yes, login app; if no, register on server
        [self checkAccount:user];
        
        
    } else if ([logonType isEqualToString:@"WB"]) {
        UserInfo *user = [UserInfo new];
        user.userID = [[NSString alloc] initWithFormat:@"SinaWB-%@",[userDic valueForKey:@"idstr"]];
        user.name = [userDic valueForKey:@"name"];
        user.password = otherLogonPassword;
        if ([[userDic valueForKey:@"gender"] isEqualToString:@"m"]) {
            user.gender = @"男";
        } else {
            user.gender = @"女";
        }
        user.photo = [self getUserPic:[userDic valueForKey:@"profile_image_url"]];
        if (_deviceToken) {
            user.deviceToken = _deviceToken;
        } else {
            user.deviceToken = @"";
        }
        [self checkAccount:user];

    }
}

- (NSData *)getUserPic:(NSString *)URLString {
    NSData *picData;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    picData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return picData;
}

- (void)checkAccount:(UserInfo *)user {
    NSString *verifyService = @"/services/user/check/username";
    NSString *param = [[NSString alloc] initWithFormat:@"/%@",user.userID];
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST_4,verifyService,param];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"data"] intValue] == 0) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self registerOther:user];// register on server
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            //login
            [self logon:user];
        }
        
    }];
    
    [sessionDataTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)gotoForgotPassword {
    ForgetPasswordViewController *forgot = [ForgetPasswordViewController new];
    [self.navigationController pushViewController:forgot animated:YES];
}

- (void)createAccount:(UserInfo *)user {
   // UINavigationController *navigationController;
    if (_deviceToken) {
        user.deviceToken = _deviceToken;
    } else {
        user.deviceToken = @"";
    }
    
    // fix the bug -- will jump to logon view when choose pic.
    if ([_database setUser:user]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [_database setLastUesdUser:user];
        if ([userType isEqualToString:@"mail"]) {
            UserInfoViewController *setUserViewController = [UserInfoViewController new];
            setUserViewController.database = _database;
            setUserViewController.user = user;
            [self.navigationController pushViewController:setUserViewController animated:YES];
            [defaults setBool:YES forKey:@"everLaunched"];
            [defaults setBool:YES forKey:@"isLogin"];
            return;
            
        } else if ([userType isEqualToString:@"WX"]) {
            HomeViewController *homeViewController = [HomeViewController new];
            homeViewController.database = _database;
            homeViewController.user = user;
            [self.navigationController pushViewController:homeViewController animated:YES];
            [defaults setBool:YES forKey:@"everLaunched"];
            [defaults setBool:YES forKey:@"isLogin"];
            return;
            
        } else if ([userType isEqualToString:@"WB"]) {
            HomeViewController *homeViewController = [HomeViewController new];
            homeViewController.database = _database;
            homeViewController.user = user;
            [self.navigationController pushViewController:homeViewController animated:YES];
            [defaults setBool:YES forKey:@"everLaunched"];
            [defaults setBool:YES forKey:@"isLogin"];
            return;
            
        } else {
            return;
        }
        // fix the bug -- will jump to logon view when choose pic.
    }
}

- (void)loginApp:(UserInfo *)user {
    if (_deviceToken) {
        user.deviceToken = _deviceToken;
    } else {
        user.deviceToken = @"";
    }
    
    if (![_database whetherUserExisted:user]) {
        [_database setUser:user];
        [_database updateUser:user];
    }
    [_database setLastUesdUser:user];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    HomeViewController *homeViewController = [HomeViewController new];
    homeViewController.database = _database;
    homeViewController.user = user;
    // fix the bug -- will jump to logon view when choose pic.
    [self.navigationController pushViewController:homeViewController animated:YES];
    [defaults setBool:YES forKey:@"isLogin"];
    // fix the bug -- will jump to logon view when choose pic.

    
}

- (BOOL)verifyPassword {
    if ([passwordTextField.text length] == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)confirmPassword {
    return [confirmPasswordTextField.text isEqualToString:passwordTextField.text];
}

- (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (UILabel *)buildLabel:(NSString *)text :(UIColor *)textColor :(UIFont *)font {
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    [label setFrame:CGRectMake(0, 0, ceilf(size.width), ceilf(size.height))];
    return label;
}

- (void)resignKeyBoard {
    [accountTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:tap];
}

#pragma mark Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
