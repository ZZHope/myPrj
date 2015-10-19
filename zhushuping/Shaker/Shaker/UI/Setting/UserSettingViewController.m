//
//  UserSettingViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/5/12.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "UserSettingViewController.h"
#import "Contants.h"
#import "ColorHandler.h"
#import "AboutUSViewController.h"
#import "FeedbackViewController.h"
#import "ChangePasswordViewController.h"
#import "StartViewController.h"
#import "ProgressHUD.h"

@interface UserSettingViewController ()

@end

@implementation UserSettingViewController {
    NavigationBar *navigationBar;
    UIScrollView *contentView;
    UIImageView *thumbnailImageView;
    UITextField *nicknameLabel;
    UITextField *descLabel;
    UIActionSheet *myActionSheet;
    UITapGestureRecognizer *tap;
    UITapGestureRecognizer *tap2;
    int retryNum1;
    int retryNum2;
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
    [navigationBar setRightBtnWithString:@"完成" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"设置"];
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePic)];
    [self buildView];
}

- (void)buildView {
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, viewWidth, viewHeight-64)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = CGSizeMake(viewWidth, 600);
    [self.view addSubview:contentView];
    
    UILabel *userInfoHeadLabel = [self buildLabel:@"个人资料" :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:10]];
    [userInfoHeadLabel setFrame:CGRectMake(17, (25-userInfoHeadLabel.bounds.size.height)/2, userInfoHeadLabel.bounds.size.width, userInfoHeadLabel.bounds.size.height)];
    [contentView addSubview:userInfoHeadLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 25, viewWidth, 0.5f)];
    line1.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line1];
    
    
    UILabel *thumbnailHeadLabel = [self buildLabel:@"头像" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:14]];
    [thumbnailHeadLabel setFrame:CGRectMake(17, (56-thumbnailHeadLabel.bounds.size.height)/2+26, thumbnailHeadLabel.bounds.size.width, thumbnailHeadLabel.bounds.size.height)];
    [contentView addSubview:thumbnailHeadLabel];
    

    thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-45, (56-45)/2+26, 45, 45)];
    thumbnailImageView.layer.cornerRadius = 2;
    if (_user.photo) {
        thumbnailImageView.image = [UIImage imageWithData:_user.photo];
    }else{
        thumbnailImageView.image = [UIImage imageNamed:@"defaultUserPic2"];
    }
    [thumbnailImageView addGestureRecognizer:tap2];
    thumbnailImageView.userInteractionEnabled = YES;
    [contentView addSubview:thumbnailImageView];
    
    //中间触控区域
    UIButton *respondBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(thumbnailHeadLabel.frame), CGRectGetMinY(thumbnailHeadLabel.frame), viewWidth-thumbnailHeadLabel.bounds.size.width-thumbnailImageView.bounds.size.width, thumbnailHeadLabel.bounds.size.height)];
    
    [respondBtn addTarget:self action:@selector(respondsToTap) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:respondBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(17, 81.5, viewWidth-17, 0.5f)];
    line2.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line2];
    
    
    UILabel *nicknameHeadLabel = [self buildLabel:@"昵称" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:14]];
    [nicknameHeadLabel setFrame:CGRectMake(17, (56-nicknameHeadLabel.bounds.size.height)/2+82, nicknameHeadLabel.bounds.size.width, nicknameHeadLabel.bounds.size.height)];
    [contentView addSubview:nicknameHeadLabel];
    
    nicknameLabel = [[UITextField alloc] initWithFrame:CGRectMake(95, 103, viewWidth-100, 14)];
    nicknameLabel.textAlignment = NSTextAlignmentLeft;
    nicknameLabel.delegate = self;
    nicknameLabel.returnKeyType = UIReturnKeyDone;
    nicknameLabel.tag = 1;
    nicknameLabel.text = _user.name;
    nicknameLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    nicknameLabel.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    nicknameLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:nicknameLabel];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(17, 138, viewWidth-17, 0.5f)];
    line3.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line3];
    
    
    UILabel *descHeadLabel = [self buildLabel:@"简介" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:14]];
    [descHeadLabel setFrame:CGRectMake(17, (56-descHeadLabel.bounds.size.height)/2+138, descHeadLabel.bounds.size.width, descHeadLabel.bounds.size.height)];
    [contentView addSubview:descHeadLabel];
    
    descLabel = [[UITextField alloc] initWithFrame:CGRectMake(95, 160, viewWidth-100, 14)];
    descLabel.delegate = self;
    descLabel.returnKeyType = UIReturnKeyDone;
    descLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    descLabel.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.text = _user.desc;
    [contentView addSubview:descLabel];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 194.5, viewWidth, 0.5)];
    line4.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line4];
    
    
    UILabel *supportHeadLabel = [self buildLabel:@"支持" :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:10]];
    [supportHeadLabel setFrame:CGRectMake(17, (25-supportHeadLabel.bounds.size.height)/2+194, supportHeadLabel.bounds.size.width, supportHeadLabel.bounds.size.height)];
    [contentView addSubview:supportHeadLabel];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 219.5, viewWidth, 0.5)];
    line5.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line5];
    
    UILabel *aboutUSLabel = [self buildLabel:@"关于稀客" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:14]];
    [aboutUSLabel setFrame:CGRectMake(17, (56-aboutUSLabel.bounds.size.height)/2+219, aboutUSLabel.bounds.size.width, aboutUSLabel.bounds.size.height)];
    [contentView addSubview:aboutUSLabel];
    UIImage *arrowImage = [UIImage imageNamed:@"right_arrow"];
    UIImageView *arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-arrowImage.size.width, (56-arrowImage.size.height)/2+219, arrowImage.size.width, arrowImage.size.height)];
    arrow1.image = arrowImage;
    [contentView addSubview:arrow1];
    UIControl *aboutUSCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 220, viewWidth, 55)];
    [aboutUSCtl addTarget:self action:@selector(goToAboutUS) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:aboutUSCtl];
    
    
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(17, 275, viewWidth-17, 0.5)];
    line6.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line6];
    
    UILabel *feedbackHeadLabel = [self buildLabel:@"意见反馈" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:14]];
    [feedbackHeadLabel setFrame:CGRectMake(17, (56-feedbackHeadLabel.bounds.size.height)/2+275, feedbackHeadLabel.bounds.size.width, feedbackHeadLabel.bounds.size.height)];
    [contentView addSubview:feedbackHeadLabel];
    UIImageView *arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-arrowImage.size.width, (56-arrowImage.size.height)/2+275, arrowImage.size.width, arrowImage.size.height)];
    arrow2.image = arrowImage;
    [contentView addSubview:arrow2];
    UIControl *feedbackCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 275, viewWidth, 55)];
    [feedbackCtl addTarget:self action:@selector(goToFeedback) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:feedbackCtl];
    
    
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(17, 331, viewWidth-17, 0.5)];
    line7.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line7];
    
    UILabel *giveScoreHeadLabel = [self buildLabel:@"给稀客打分" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:14]];
    [giveScoreHeadLabel setFrame:CGRectMake(17, (56-giveScoreHeadLabel.bounds.size.height)/2+331, giveScoreHeadLabel.bounds.size.width, giveScoreHeadLabel.bounds.size.height)];
    [contentView addSubview:giveScoreHeadLabel];
    UIImageView *arrow3 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-arrowImage.size.width, (56-arrowImage.size.height)/2+331, arrowImage.size.width, arrowImage.size.height)];
    arrow3.image = arrowImage;
    [contentView addSubview:arrow3];
    UIControl *giveScoreCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 331, viewWidth, 55)];
    [giveScoreCtl addTarget:self action:@selector(goToScore) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:giveScoreCtl];
    
    
    UIView *line8 = [[UIView alloc] initWithFrame:CGRectMake(17, 387, viewWidth-17, 0.5)];
    line8.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line8];

    UILabel *clearCacheHeadLabel = [self buildLabel:@"清理缓存" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:14]];
    [clearCacheHeadLabel setFrame:CGRectMake(17, (56-clearCacheHeadLabel.bounds.size.height)/2+387, clearCacheHeadLabel.bounds.size.width, clearCacheHeadLabel.bounds.size.height)];
    UIControl *clearCtr = [[UIControl alloc]initWithFrame:CGRectMake(CGRectGetMaxX(clearCacheHeadLabel.frame), (56-clearCacheHeadLabel.bounds.size.height)/2+387, viewWidth-clearCacheHeadLabel.bounds.size.width, clearCacheHeadLabel.bounds.size.height)];
    [clearCtr addTarget:self action:@selector(clearDataCatch) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:clearCtr];
    
    [contentView addSubview:clearCacheHeadLabel];
    UIImageView *arrow4 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-arrowImage.size.width, (56-arrowImage.size.height)/2+387, arrowImage.size.width, arrowImage.size.height)];
    arrow4.image = arrowImage;
    [contentView addSubview:arrow4];
    
    
    UIView *line9 = [[UIView alloc] initWithFrame:CGRectMake(17, 443, viewWidth-17, 0.5)];
    line9.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line9];
    
    UILabel *changePwdHeadLabel = [self buildLabel:@"修改密码" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:14]];
    [changePwdHeadLabel setFrame:CGRectMake(17, (56-changePwdHeadLabel.bounds.size.height)/2+443, changePwdHeadLabel.bounds.size.width, changePwdHeadLabel.bounds.size.height)];
    
    [contentView addSubview:changePwdHeadLabel];
    UIImageView *arrow5 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-arrowImage.size.width, (56-arrowImage.size.height)/2+443, arrowImage.size.width, arrowImage.size.height)];
    arrow5.image = arrowImage;
    [contentView addSubview:arrow5];
    UIControl *changePwdCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 443, viewWidth, 56)];
    [changePwdCtl addTarget:self action:@selector(goToChangePassword) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:changePwdCtl];
    
    UIView *line10 = [[UIView alloc] initWithFrame:CGRectMake(17, 500, viewWidth-17, 0.5)];
    line10.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line10];
    
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-264)/2, 520, 264, 40)];
    logoutBtn.backgroundColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:logoutBtn];
}

- (void)resignKeyBoard {
    [nicknameLabel resignFirstResponder];
    [descLabel resignFirstResponder];
    [contentView removeGestureRecognizer:tap];
}

- (void)changePic {
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}


- (void)goToAboutUS {
    AboutUSViewController *aboutUSController = [AboutUSViewController new];
    [self.navigationController pushViewController:aboutUSController animated:YES];
}

- (void)goToFeedback {
    FeedbackViewController *feedbackController = [FeedbackViewController new];
    feedbackController.user = _user;
    [self.navigationController pushViewController:feedbackController animated:YES];
}

- (void)goToScore {

    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?mt=8&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=924809913"]];
    
}

//itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id;=%d",appid

- (void)goToChangePassword {
    ChangePasswordViewController *changePWDHead = [ChangePasswordViewController new];
    changePWDHead.user = _user;
    changePWDHead.database = _database;
    [self.navigationController pushViewController:changePWDHead animated:YES];
}

- (void)logout {
    NSString *logoutService = @"/services/user/logout";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,logoutService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    [sessionDataTask resume];
    
    StartViewController *startViewController = [StartViewController new];
    startViewController.database = _database;
    [self.navigationController pushViewController:startViewController animated:YES];//20150527

}


- (void)updateUser {
    _user.photo = UIImagePNGRepresentation(thumbnailImageView.image);
    _user.name = nicknameLabel.text;
    _user.desc = descLabel.text;
    if ([_database updateUser:_user]) {
        [self updateAccountOnServer];
        [self uploadProfileOnServer];
        [self.delegate didFinishAccountSettingwith:_user];
        [self.navigationController popViewControllerAnimated:YES];
    }
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"服务器开会小差,稍后再试~" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
}

- (void)updateAccountOnServer {
    NSString *updateAccountService = @"/services/user/";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST_4,updateAccountService,_user.ID];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:nicknameLabel.text forKey:@"nickname"];
    [dic setValue:descLabel.text forKey:@"desc"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {

        } else if ([[dataDic valueForKey:@"data"] isEqualToString:@"NOT_LOGIN"]) {
            [self loginAndUpdateAgain];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"同步失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
        
    }];
    
    [sessionDataTask resume];
}

- (void)loginAndUpdateAgain {
    if (retryNum1 > 4) {
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
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            [self updateAccountOnServer];
            retryNum1 ++;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)loginAndUploadAgain {
    if (retryNum2 > 4) {
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
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            [self uploadProfileOnServer];
            retryNum2 ++;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)uploadProfileOnServer {
    NSData *imgData = UIImageJPEGRepresentation(thumbnailImageView.image, 0.5);
    
    NSString *uploadProfileService = @"/services/user/upload/profile";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,uploadProfileService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831464368775746641449"];
    NSMutableData *body = [NSMutableData new];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[_user.ID dataUsingEncoding:NSUTF8StringEncoding]];
    if (imgData) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", @"profile",_user.name] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imgData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // set request HTTPHeader
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {

        } else if ([[dataDic valueForKey:@"data"] isEqualToString:@"NOT_LOGIN"]) {
            [self loginAndUploadAgain];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"同步失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
        
    }];
    
    [sessionDataTask resume];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ImageCropperDelegate
- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [thumbnailImageView setImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self locolPhoto];
            break;
        default:
            break;
    }
}

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"You don't have a camera!");
    }
}

- (void)locolPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    //picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^(void){}];
    // [self presentModalViewController:picker animated:YES];
}


-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //[_pictureView setImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:^(){
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [self imageByScalingToMaxSize:image];
        // 裁剪
        ImageCropperViewController *imgEditorVC = [[ImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width)];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    float ORIGINAL_MAX_WIDTH = self.view.bounds.size.width;
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}


- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark UITextViewDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [contentView addGestureRecognizer:tap];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma 清除缓存

-(void)clearDataCatch
{
    [ProgressHUD show:@"清理中"];
    [self performSelector:@selector(clearCatch) withObject:self afterDelay:1.0f];

}

-(void)clearCatch
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"清理完成" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alert show];
    [ProgressHUD dismiss];

}

//头像触控区的反应
-(void)respondsToTap
{
    [self changePic];
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked {
    [self updateUser];
}

@end
