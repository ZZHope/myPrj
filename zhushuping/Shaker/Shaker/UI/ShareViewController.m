//
//  ShareViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/13.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "ShareViewController.h"
#import "ColorHandler.h"
#import "Contants.h"
#import "HomeViewController.h"
#import "TopicViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController {
    NavigationBar *navigationBar;
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
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"分享/发送"];
    [navigationBar setTitleTextView:title];
//    [navigationBar setLeftBtn:[UIImage imageNamed:@"returnIcon"]];
    [navigationBar setLeftBtnWithString:@"< 查看" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    [navigationBar setRightBtnWithString:@"首页" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildContentView];
}

- (void)buildContentView {
    UIImage *alreadySavedImage = [UIImage imageNamed:@"already_saved"];
    UIImageView *savedImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-alreadySavedImage.size.width)/2, 64+55, alreadySavedImage.size.width, alreadySavedImage.size.height)];
    savedImageView.image = alreadySavedImage;
    [self.view addSubview:savedImageView];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth-80)/2, 64+137, 80, 15)];
    shareLabel.textColor = [ColorHandler colorWithHexString:@"#00bfa5"];
    shareLabel.font = [UIFont systemFontOfSize:15];
    shareLabel.text = @"分享发送至";
    [self.view addSubview:shareLabel];
    
    //Share Components' buttons
    // WeChate Session
    UIImage *sessionIcon = [UIImage imageNamed:@"wechatSession_icon"];
    UIImage *sessionText = [UIImage imageNamed:@"wechatSession_text"];
    UIButton *weChatSessionButton = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth/2-sessionIcon.size.width)/2, 64+185, sessionIcon.size.width, sessionIcon.size.height)];
    [weChatSessionButton setBackgroundImage:sessionIcon forState:UIControlStateNormal];
    [weChatSessionButton addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    weChatSessionButton.tag = WXSession;
    [self.view addSubview:weChatSessionButton];
    UIImageView *sessionTextImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth/2-sessionText.size.width)/2, 64+230, sessionText.size.width, sessionText.size.height)];
    sessionTextImageView.image = sessionText;
    [self.view addSubview:sessionTextImageView];
    
    //WeChat Timeline
    UIImage *timelineIcon = [UIImage imageNamed:@"wechatTimeline_icon"];
    UIImage *timelineText = [UIImage imageNamed:@"wechatTimeline_text"];
    UIButton *weChatTimelineButton = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-timelineIcon.size.width)/2, 64+185, timelineIcon.size.width, timelineIcon.size.height)];
    [weChatTimelineButton setBackgroundImage:timelineIcon forState:UIControlStateNormal];
    [weChatTimelineButton addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    weChatTimelineButton.tag = WXTimeLine;
    [self.view addSubview:weChatTimelineButton];
    UIImageView *timelineTextImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-timelineText.size.width)/2, 64+230, timelineText.size.width, timelineText.size.height)];
    timelineTextImageView.image = timelineText;
    [self.view addSubview:timelineTextImageView];
    
    //Sina Weibo
    UIImage *sinaweiboIcon = [UIImage imageNamed:@"sinaWeibo_icon"];
    UIImage *sinaweiboText = [UIImage imageNamed:@"sinaWeibo_text"];
    UIButton *sinaWeiboButton = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth/2-sinaweiboIcon.size.width)/2+viewWidth/2, 64+185, sinaweiboIcon.size.width, sinaweiboIcon.size.height)];
    [sinaWeiboButton setBackgroundImage:sinaweiboIcon forState:UIControlStateNormal];
    [sinaWeiboButton addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    sinaWeiboButton.tag = SinaWB;
    [self.view addSubview:sinaWeiboButton];
    UIImageView *sinaweiboTextImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth/2-sinaweiboText.size.width)/2+viewWidth/2, 64+230, sinaweiboText.size.width, sinaweiboText.size.height)];
    sinaweiboTextImageView.image = sinaweiboText;
    [self.view addSubview:sinaweiboTextImageView];
    
}

- (void)clickOnButton:(UIButton *)button {
    if (button.tag == WXTimeLine) {
        [self.delegate share:WXTimeLine];
    } else if (button.tag == WXSession) {
        [self.delegate share:WXSession];
    } else if (button.tag == SinaWB) {
        [self.delegate share:SinaWB];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
//    [self.navigationController popViewControllerAnimated:YES];
    TopicViewController *topicViewController = [TopicViewController new];
    topicViewController.topic = _topic;
    topicViewController.user = _user;
    topicViewController.database = _database;
    [self.navigationController pushViewController:topicViewController animated:YES];
    
}

- (void)rightBtnClicked {
    //back to homePage
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[HomeViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
}

@end
