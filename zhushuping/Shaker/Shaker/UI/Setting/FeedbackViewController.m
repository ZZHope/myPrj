//
//  FeedbackViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/5/14.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Contants.h"
#import "ColorHandler.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController {
    NavigationBar *navigationBar;
    UITextView *feedbackTextView;
    NSMutableAttributedString *placeholder;
    UITapGestureRecognizer *tap;
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
    [navigationBar setRightBtnWithString:@"发送" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"意见反馈"];
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
    feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(17, 77, viewWidth-17*2, 140)];
    feedbackTextView.delegate = self;
    feedbackTextView.font = [UIFont systemFontOfSize:12];
    feedbackTextView.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    placeholder = [[NSMutableAttributedString alloc] initWithString:@"如有建议(或好话题)，稀客欢迎大家畅所欲言，吐槽大战。"];
    [placeholder addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#a7a7a7"] range:NSMakeRange(0, placeholder.length)];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, placeholder.length)];
    feedbackTextView.attributedText = placeholder;
    [self.view addSubview:feedbackTextView];
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 228, viewWidth-17*2, 10)];
    tipsLabel.text = @"稀客提示：如果使用不正常可以重启试试";
    tipsLabel.font = [UIFont systemFontOfSize:10];
    tipsLabel.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    [self.view addSubview:tipsLabel];
}

- (void)resignKeyBoard {
    [feedbackTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tap];
}

- (void)sendFeedback {
    NSString *feedbackService = @"/services/suggestion";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,feedbackService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:feedbackTextView.text forKey:@"content"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    
    [sessionDataTask resume];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"建议或意见" message:@"谢谢你的宝贵建议或意见！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tap];
    [feedbackTextView becomeFirstResponder];
    if ([feedbackTextView.text isEqualToString:placeholder.string]) {
        feedbackTextView.text = @"";
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setFrame:CGRectMake(0, -44, viewWidth, viewHeight)];
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([feedbackTextView.text isEqualToString:@""]) {
        feedbackTextView.attributedText = placeholder;
    }
    [self resignKeyBoard];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    }];
}

#pragma mark --- alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked {
    [self sendFeedback];
}


@end
