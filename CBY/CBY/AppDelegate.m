//
//  AppDelegate.m
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "AppDelegate.h"
#import "common.h"
#import "SJBManager.h"
#import "CbyDataBaseManager.h"
#import "DBCommon.h"
#import "CbyUserSingleton.h"
#import "AFNetworking.h"
#import "AFNCommon.h"

#import <AlipaySDK/AlipaySDK.h>

//#define  kAppKey     @"4fa53e73d67d"
//#define kAppSecret   @"a47a87759ff97c844fceb4f3e88d4be6"

@interface AppDelegate ()

@property(nonatomic,strong) NSArray *carInfo;

@end
// NSString *currentStr = @"0.0";
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [NSThread sleepForTimeInterval:1.0];//可以让加载页面显示时间更长点
    
#pragma mark -
#pragma mark 如果是首次下载使用这个版本的软件，那么需要弹出用户指引界面
    
    /*
     1.判断是否第一次使用这个版本
     */
    NSString *key = (NSString *)kCFBundleVersionKey;
    
    // 1.1.先去沙盒中取出上次使用的版本号
    NSString *lastVersionCode = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // 1.2.加载程序中info.plist文件(获得当前软件的版本号)
    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[key];
    [self compareVerionWithCurrentVersion:currentVersionCode];
    
    
    
    
    if ([lastVersionCode isEqualToString:currentVersionCode]) {
        // 非第一次使用软件
        [SJBManager prsentSJBControllerWithType:SJBControllerTypeMainView];
        [UIApplication sharedApplication].statusBarHidden = NO;
        CbyUserSingleton *userInfo = [CbyUserSingleton shareUserSingleton];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"successLogin"]) {
            userInfo.isLogin = YES;
            userInfo.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
            userInfo.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        }
        
    } else {
        // 第一次使用软件
        
        //对比当前版本号与最新版本号
        
        CbyDataBaseManager *manager = [CbyDataBaseManager shareInstance];
        [manager saveCarVersionToDB:kCarTable withColumns:currentVersionCode];
        
        
        // 1.3.保存当前软件版本号
        
        [[NSUserDefaults standardUserDefaults] setObject:currentVersionCode forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 1.4.新特性控制器（指引界面）
        [SJBManager prsentSJBControllerWithType:SJBControllerTypeUserGuideView];
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
    
    
    
    
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark =======跳转到支付宝进去支付=========
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"appDelegate pay result = %@", resultDic);
         }];
    }
    
    return YES;
}

#pragma mark -- 查询版本号
-(void)compareVerionWithCurrentVersion:(NSString *)currentVersion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_app_update.php"];
    NSDictionary *parameter = @{kInterfaceName:@"checkVersion"};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            NSString *str = [NSString stringWithFormat:@"%.1f",[currentVersion floatValue]];
            if (![str isEqualToString:[responseObject objectForKey:@"version"]]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"最新版本为：%@，当前版本为：%@",[responseObject objectForKey:@"version"],[NSString stringWithFormat:@"v%.1f",[currentVersion floatValue]]] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"version :error%@",error);
        
    }];
    
}


@end
