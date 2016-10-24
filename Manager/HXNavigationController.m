//
//  HXNavigationController.m
//  financer
//
//  Created by  淑萍 on 16/5/30.
//  Copyright © 2016年 Jney. All rights reserved.
//

#import "HXNavigationController.h"
#import "CustomButton.h"
#import "UIBarButtonItem+Item.h"

@interface HXNavigationController ()<UINavigationControllerDelegate>
@property(nonatomic,weak) id popDelegate;
@end

@implementation HXNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}


+(void)initialize  //写在此方法中可以起到懒加载作用，并且只要设置一次，整个项目处处是一样的标题
{
    
    [self setNavigationBarTheme];
    [self setBarButtonItemTheme];
}

//bar的主题
+(void)setNavigationBarTheme
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HXRGB(4, 70, 117),NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        
        [[UINavigationBar appearance] setTranslucent:NO];
    }
//    navBar.translucent = NO;
    [navBar setShadowImage:[[UIImage alloc]init]];
    
}


+(void)setBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:HXRGB(4, 70, 117)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:HXRGB(4, 70, 117)} forState:UIControlStateHighlighted];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateDisabled];
}



-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count>0 && viewController != self.viewControllers[0]) {
        
        
        UIBarButtonItem *item = [UIBarButtonItem ItemWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] highLight:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] target:self action:@selector(back)];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer,item];
        

    }
}


-(void)back
{
    [self popViewControllerAnimated:YES];
}



//delegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationController.navigationBar.translucent = NO;
    viewController.hidesBottomBarWhenPushed = YES;
    
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
     

    }else{
        
        self.interactivePopGestureRecognizer.delegate = nil;
       
         self.tabBarController.tabBar.hidden = YES ;
      
    }
    
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    if (viewController == self.viewControllers[0]) {
       

        self.tabBarController.tabBar.hidden = NO;
    }else{
        
        self.tabBarController.tabBar.hidden = YES;
     
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
