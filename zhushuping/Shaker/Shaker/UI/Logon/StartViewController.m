//
//  StartViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/5/8.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "StartViewController.h"
#import "ColorHandler.h"
#import "Contants.h"
#import "RegisterLogonViewController.h"
#import "HomeViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController {
    UIButton *logonBtn;
    UIButton *registerBtn;
    UIButton *guestBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self buildView];
}

- (void)buildView {
    UIImage *logoImage = [UIImage imageNamed:@"shaker_logo"];
    UIImage *sloganImage = [UIImage imageNamed:@"shaker_slogan"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-logoImage.size.width)/2, 98, logoImage.size.width, logoImage.size.height)];
    logoImageView.image = logoImage;
    [self.view addSubview:logoImageView];
    UIImageView *sloganImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-sloganImage.size.width)/2, 182, sloganImage.size.width, sloganImage.size.height)];
    sloganImageView.image = sloganImage;
    [self.view addSubview:sloganImageView];
    
    //Btn
    registerBtn = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-264)/2, viewHeight-243, 264, 40)];
    registerBtn.backgroundColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    registerBtn.layer.cornerRadius = 2;
    [registerBtn addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    logonBtn = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-264)/2, viewHeight-188, 264, 40)];
    logonBtn.backgroundColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    [logonBtn setTitle:@"登录" forState:UIControlStateNormal];
    logonBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    logonBtn.layer.cornerRadius = 2;
    [logonBtn addTarget:self action:@selector(gotoLogon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logonBtn];
    
    guestBtn = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-264)/2, viewHeight-133, 264, 40)];
    guestBtn.backgroundColor = [UIColor whiteColor];
    [guestBtn setTitleColor:[ColorHandler colorWithHexString:@"#00d8a5"] forState:UIControlStateNormal];
    [guestBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
    guestBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    guestBtn.layer.cornerRadius = 2;
    guestBtn.layer.borderColor = [ColorHandler colorWithHexString:@"#00d8a5"].CGColor;
    guestBtn.layer.borderWidth = 1;
    [guestBtn addTarget:self action:@selector(gotoGuest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:guestBtn];
    
}

- (void)gotoLogon {
    RegisterLogonViewController *logonViewController = [RegisterLogonViewController new];
    logonViewController.database = _database;
    logonViewController.deviceToken = _deviceToken;
    logonViewController.flag = LOGON;
    [self.navigationController pushViewController:logonViewController animated:YES];
}

- (void)gotoRegister {
    RegisterLogonViewController *logonViewController = [RegisterLogonViewController new];
    logonViewController.database = _database;
    logonViewController.deviceToken = _deviceToken;
    logonViewController.flag = REGISTER;
    [self.navigationController pushViewController:logonViewController animated:YES];
}


#pragma  521增加
- (void)gotoGuest {
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [self.navigationController presentViewController:navigation animated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
