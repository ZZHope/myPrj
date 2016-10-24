//
//  HUAXIAManager.m
//  financer
//
//  Created by  淑萍 on 16/6/22.
//  Copyright © 2015年 HuaxiaFinance. All rights reserved.
//
//

#import "HUAXIAManager.h"
#import "LoginViewController.h"
#import "MyTabBarController.h"
#import "HXNavigationController.h"
#import "NotificationManager.h"


@implementation HUAXIAManager

+  (void)presentHUAXIAControllerWithType:(HUAXIAViewControllerType)controllerType
{
    //    以修改keywindow的rootViewController，来实现界面的跳转
    UIViewController *controller =  [[[self alloc] init] controllerByType:controllerType];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = controller;
    
}

//根据传入controllerTyp创建具体的ViewController对象
- (UIViewController*)controllerByType:(HUAXIAViewControllerType)type
{
    UIViewController *viewController = nil;
    
    switch (type) {
        
        case HUAXIAControllerTypeLoginView:
        {
            [UIApplication sharedApplication].statusBarHidden = NO;
            
            viewController = [[HXNavigationController alloc]initWithRootViewController:[[LoginViewController alloc] init]];
            

        }
           
            break;
        case HUAXIAControllerTypeMainView:
        {
            [UIApplication sharedApplication].statusBarHidden = NO;
            viewController = [[MyTabBarController alloc] init];

        }
            
            
            break;
        default:
            break;
    }
    return viewController;
}

@end
