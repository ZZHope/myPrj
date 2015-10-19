//
//  WebContentViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/17.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "WebContentViewController.h"
#import "Contants.h"
#import "ColorHandler.h"

@interface WebContentViewController ()

@end

@implementation WebContentViewController {
    NavigationBar *navigationBar;
    UIWebView *webContent;
    NSString *URLString;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtn:[UIImage imageNamed:@"returnIcon"]];
    
    [navigationBar setBackColor:[UIColor whiteColor]];
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildView];
}

- (void)buildView {
    webContent = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, viewWidth, viewHeight)];
    
    [self generateURLString];
    [webContent loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];

    [self.view addSubview:webContent];
}

- (void)generateURLString {
    if (_type == TOPIC) {
        URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/services/entity/",_topic.UUID];
    } else if (_type == POST) {
        URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/services/post/",_post.UUID];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
