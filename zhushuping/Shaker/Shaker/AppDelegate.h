//
//  AppDelegate.h
//  Shaker
//
//  Created by Leading Chen on 15/4/4.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

