//
//  SJBManager.m
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "SJBManager.h"
#import "LoginViewController.h"
#import "UserGuideViewController.h"
#import "MainViewController.h"


@implementation SJBManager

+ (void)prsentSJBControllerWithType:(SJBViewControllerType)controllerType
{
    //    以修改keywindow的rootViewController，来实现界面的跳转
    UIViewController *controller =  [[[self alloc] init] controllerByType:controllerType];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = controller;

}

//根据传入controllerTyp创建具体的QYViewController对象
- (UIViewController*)controllerByType:(SJBViewControllerType)type
{
    UIViewController *viewController = nil;
    
    switch (type) {
        case SJBControllerTypeUserGuideView:
            viewController = [[UserGuideViewController alloc] init];
            break;
        case SJBControllerTypeLoginView:
            viewController = [[LoginViewController alloc] init];
            break;
        case SJBControllerTypeMainView:
            viewController = [[MainViewController alloc] init];
            break;
        default:
            break;
    }
    return viewController;
}



@end
