//
//  ViewController.m
//  TestPie
//
//  Created by  淑萍 on 17/2/14.
//  Copyright © 2017年 华夏信财. All rights reserved.
//

#import "ViewController.h"
#import "PieProgressView.h"
@interface ViewController ()
@property(nonatomic,strong) PieProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _progressView = [[PieProgressView alloc]init];
    self.progressView.colors = [NSMutableArray array];
    [self.progressView.colors addObject:[UIColor redColor]];
    [self.progressView.colors addObject:[UIColor greenColor]];
    [self.progressView.colors addObject:[UIColor blueColor]];
    self.progressView.frame = CGRectMake(100, 100, 100, 100);
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.hidden = YES;
    [self.view addSubview:self.progressView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.progressView setProgressWithAnimated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
