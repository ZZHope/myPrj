//
//  ForgetPasswordViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-29.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ColorHandler.h"
#import "Contants.h"

@interface ForgetPasswordViewController () {
    UITextField *emailTextField;
    UIGestureRecognizer *tapGestureRecognizer;
    NavigationBar *navigationBar;
}

@end

@implementation ForgetPasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    [title addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#2a2a2a"] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
    [navigationBar setTitleTextView:title];
    
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    [self buildView];
}

- (void)buildView {
    UILabel *paddingLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(26, 77, viewWidth-26*2, 40)];
    emailTextField.tag = 1;
    emailTextField.delegate = self;
    emailTextField.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    emailTextField.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的邮箱" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#2a2a2a"],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    emailTextField.font = [UIFont systemFontOfSize:12];
    emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTextField.leftView = paddingLabel1;
    emailTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:emailTextField];
    
    UIButton *resetPasswordBtn = [[UIButton alloc] initWithFrame:CGRectMake(26, 142, viewWidth-26*2, 40)];
    resetPasswordBtn.backgroundColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    [resetPasswordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    resetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resetPasswordBtn addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetPasswordBtn];
}

- (void)resetPassword {
    if ([self isValidEmail:emailTextField.text]) {
        [self sendResetPassword];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重置密码" message:@"重置密码已发送，请去注册邮箱查看并尽快更换新密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重置密码" message:@"请输入正确邮箱" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }

}

- (void)sendResetPassword {
    //TODO
}

- (void)resignKeyBoard {
    [emailTextField resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

- (void)returnToLogon {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

@end
