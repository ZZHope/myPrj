//
//  MyTabBarController.m
//  HuaxiaFinance
//
//  Created by apple on 15/11/13.
//  Copyright (c) 2015年 HuaxiaFinance. All rights reserved.
//

#import "MyTabBarController.h"
#import "ChatViewListViewController.h"
#import "ProductViewController.h"
#import "MoreViewController.h"
#import "Appdelegate.h"
#import "addressBookViewController.h"
#import "HXNavigationController.h"
#import "NotificationManager.h"
#import "HomeViewController.h"
#import "Financial.h"
#import "UserConfig.h"
@interface MyTabBarController ()<UITabBarControllerDelegate>

//@property(nonatomic,retain)NSMutableArray * controllers;
@property(nonatomic,strong) NSString *badgeStr;

@end

@implementation MyTabBarController

//- (AppDelegate *)appDelegate
//{
//    return (AppDelegate *)[UIApplication sharedApplication].delegate;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
   [self Creatcontrollers];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
}

-(void)Creatcontrollers{
 
        //实例化4个主视图控制器
        //主页
        //HomePageViewController * HomeVC = [[HomePageViewController alloc]init];
        HomeViewController * HomeVC = [[HomeViewController alloc]init];
        HXNavigationController * homeNav = [[HXNavigationController alloc]initWithRootViewController:HomeVC];
        HomeVC.tabBarItem.title = @"首页";
        [HomeVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HXRGB(4, 70, 117)} forState:UIControlStateSelected];
        [HomeVC.tabBarItem setImage:[[UIImage imageNamed:@"tab_home_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [HomeVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_home_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        
        //客户
        ChatViewListViewController *chatVC = [[ChatViewListViewController alloc]init];//
        HXNavigationController * converNav = [[HXNavigationController alloc]initWithRootViewController:chatVC];
        chatVC.tabBarItem.title = @"客户";
        chatVC.tabBarItem.badgeValue = self.badgeStr;
        [chatVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HXRGB(4, 70, 117)} forState:UIControlStateSelected];
        [chatVC.tabBarItem setImage:[[UIImage imageNamed:@"tab_client_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [chatVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_client_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
        

       
        //产品
        ProductViewController * ProductVC = [[ProductViewController alloc]init];
        HXNavigationController * productNav = [[HXNavigationController alloc]initWithRootViewController:ProductVC];
        ProductVC.tabBarItem.title = @"产品";
        [ProductVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HXRGB(4, 70, 117)} forState:UIControlStateSelected];
        [ProductVC.tabBarItem setImage: [[UIImage imageNamed:@"tab_product_n" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [ProductVC.tabBarItem setSelectedImage:[[[UIImage imageNamed:@"tab_product_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
      
        //更多
        MoreViewController * MoreVC = [[MoreViewController alloc]init];
        HXNavigationController * moreNav = [[HXNavigationController alloc]initWithRootViewController:MoreVC];
        MoreVC.tabBarItem.title = @"更多";
        [MoreVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HXRGB(4, 70, 117)} forState:UIControlStateSelected];
        [MoreVC.tabBarItem setImage:[[UIImage imageNamed:@"tab_more_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [MoreVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_more_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        UIView *tempView = chatVC.view; //为了启动加载，第二个页面不懒加载
    
        self.viewControllers = @[homeNav,converNav,productNav,moreNav];

    
        UIImageView * backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        [backView setImage:[UIImage imageNamed:@"tab_bg"]];
         [self.tabBar insertSubview:backView atIndex:0];
        self.tabBar.opaque = YES;
        self.selectedIndex = [[[NotificationManager shareInstance] tabbarIndex] integerValue];
  
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
