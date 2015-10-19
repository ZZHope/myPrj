//
//  ChangePasswordViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/5/14.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Contants.h"
#import "ColorHandler.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController {
    NavigationBar *navigationBar;
    UIGestureRecognizer *tap;
    UITextField *oldPwdField;
    UITextField *newPwdField;
    UITextField *confirmPwdField;
    int retryNum;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    if (navigationBar) {
        [navigationBar removeFromSuperview];
        navigationBar = nil;
    }
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    
    [navigationBar setLeftBtnWithString:@"返回" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    [navigationBar setRightBtnWithString:@"保存" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"修改密码"];
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
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    // Do any additional setup after loading the view.
    
    [self buildView];
}

- (void)buildView {
    UILabel *paddingLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 47)];
    UILabel *paddingLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 47)];
    UILabel *paddingLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 47)];
    oldPwdField = [[UITextField alloc] initWithFrame:CGRectMake(17, 77, viewWidth-17*2, 47)];
    oldPwdField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    oldPwdField.layer.cornerRadius = 4;
    oldPwdField.font = [UIFont systemFontOfSize:14];
    oldPwdField.textColor = [ColorHandler colorWithHexString:@"#414141"];
    oldPwdField.secureTextEntry = YES;
    oldPwdField.delegate = self;
    oldPwdField.leftView = paddingLabel1;
    oldPwdField.leftViewMode = UITextFieldViewModeAlways;
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:@"输入旧密码"];
    [placeholder1 addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#a7a7a7"] range:NSMakeRange(0, placeholder1.length)];
    oldPwdField.attributedPlaceholder = placeholder1;
    [self.view addSubview:oldPwdField];
    
    newPwdField = [[UITextField alloc] initWithFrame:CGRectMake(17, 141, viewWidth-17*2, 47)];
    newPwdField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    newPwdField.layer.cornerRadius = 4;
    newPwdField.font = [UIFont systemFontOfSize:14];
    newPwdField.textColor = [ColorHandler colorWithHexString:@"#414141"];
    newPwdField.secureTextEntry = YES;
    newPwdField.delegate = self;
    newPwdField.leftView = paddingLabel2;
    newPwdField.leftViewMode = UITextFieldViewModeAlways;
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc] initWithString:@"输入新密码"];
    [placeholder2 addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#a7a7a7"] range:NSMakeRange(0, placeholder2.length)];
    newPwdField.attributedPlaceholder = placeholder2;
    [self.view addSubview:newPwdField];
    
    confirmPwdField = [[UITextField alloc] initWithFrame:CGRectMake(17, 200, viewWidth-17*2, 47)];
    confirmPwdField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    confirmPwdField.layer.cornerRadius = 4;
    confirmPwdField.font = [UIFont systemFontOfSize:14];
    confirmPwdField.textColor = [ColorHandler colorWithHexString:@"#414141"];
    confirmPwdField.secureTextEntry = YES;
    confirmPwdField.delegate = self;
    confirmPwdField.leftView = paddingLabel3;
    confirmPwdField.leftViewMode = UITextFieldViewModeAlways;
    NSMutableAttributedString *placeholder3 = [[NSMutableAttributedString alloc] initWithString:@"确认新密码"];
    [placeholder3 addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#a7a7a7"] range:NSMakeRange(0, placeholder3.length)];
    confirmPwdField.attributedPlaceholder = placeholder3;
    [self.view addSubview:confirmPwdField];
}

- (void)changePwd {
    if ([self verifyPassword]) {
        _user.password = newPwdField.text;
        
        NSString *changePwdService = @"/services/user/change/password";
        NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,changePwdService];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:oldPwdField.text forKey:@"oldpassword"];
        [dic setValue:newPwdField.text forKey:@"newpassword"];
        NSError *err;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
        [request setHTTPBody:bodyData];
        
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSError *err;
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            
            if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
                [_database updateUserPassword:_user];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"修改密码成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertView.tag = 1;
                [alertView show];
            } else if ([[dataDic valueForKey:@"data"] isEqualToString:@"OLD_PASSWORD_WRONG"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"旧密码错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            } else if ([[dataDic valueForKey:@"data"] isEqualToString:@"NOT_LOGIN"]) {
                [self loginAndSaveAgain];
            }
            
        }];
        
        [sessionDataTask resume];
    }
}

- (void)loginAndSaveAgain {
    if (retryNum > 4) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
        [alertView show];
        return;
    }
    NSString *loginService = @"/services/user/login";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,loginService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_user.userID forKey:@"username"];
    [dic setValue:_user.password forKey:@"password"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            [self changePwd];
            retryNum ++;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
    }];
    
    [sessionDataTask resume];
}

- (BOOL)verifyPassword {
    if (![[_database getUserPassword:_user] isEqualToString:oldPwdField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"旧密码错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
        return NO;
    }
    if ([oldPwdField.text length] == 0 || [newPwdField.text length] == 0 || [confirmPwdField.text length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
        return NO;
    }
    if (![self confirmPassword]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"两次输入的新密码不匹配" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
        return NO;
    }
    return YES;
}

- (BOOL)confirmPassword {
    return [newPwdField.text isEqualToString:confirmPwdField.text];
}

- (void)resignKeyBoard {
    [oldPwdField resignFirstResponder];
    [newPwdField resignFirstResponder];
    [confirmPwdField resignFirstResponder];
    [self.view removeGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark UITextViewDelegate
- (void)textFieldDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tap];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setFrame:CGRectMake(0, -44, viewWidth, viewHeight)];
    }];
}

- (void)textFieldDidEndEditing:(UITextView *)textView {
    [self resignKeyBoard];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    }];
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked {
    [self changePwd];
}

@end
