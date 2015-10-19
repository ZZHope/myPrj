//
//  PostViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/16.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "PostViewController.h"
#import "Contants.h"
#import "ColorHandler.h"

@interface PostViewController ()

@end

@implementation PostViewController {
    NavigationBar *navigationBar;
    NSInteger currentIndex;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtn:[UIImage imageNamed:@"returnIcon"]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%d/%d",(int)currentIndex,(int)_post.cards.count]];
    [title addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#2a2a2a"] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
    [navigationBar setTitleTextView:title];
    [navigationBar setBackColor:[UIColor whiteColor]];
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
