//
//  MailViewController.m
//  Shaker
//
//  Created by shaker on 15/5/24.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "MailViewController.h"
#import "NavigationBar.h"
#import "ColorHandler.h"
#import "Contants.h"


@interface MailViewController ()<NavigationBarDelegate>

@property(nonatomic, strong)UIImageView *imgView;

@end

@implementation MailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-41)*0.5, 144+64, 41,129*0.5)];
    
    self.imgView.image = [UIImage imageNamed:@"noMessage"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.imgView];
    
    
    [self navigationBarCreat];
    
}

-(void)navigationBarCreat
{
    NavigationBar *navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtnWithString:@"返回" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"通知"];
    [title addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#000000"] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
    [navigationBar setTitleTextView:title];
    [navigationBar setBackColor:[UIColor whiteColor]];
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

#pragma mark -- navigationBar delegate

-(void)leftBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
