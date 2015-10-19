//
//  AppDelegate.m
//  Shaker
//
//  Created by Leading Chen on 15/4/4.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ShakerDatabase.h"
#import "UserInfo.h"
#import "ShareEngine.h"
#import "StartViewController.h"
#import "Contants.h"
#import "UIImageView+WebCache.h"
#import "NewFeatureViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate {
    StartViewController *logonViewController;
    HomeViewController *homeViewController;
    NSString *token;
    ShakerDatabase *database;
    UserInfo *user;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //set do not backup flag
//    [self addSkipBackupAttributeToItemAtURL:[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]];
//    //Register APN service
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    } else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    }
//    
//    if (launchOptions) {
//        //TODO
//        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        [self handleNotification:userInfo];
//    }
    
    //清除图片缓存
    [[SDImageCache sharedImageCache]clearDisk];
    
   
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    database = [ShakerDatabase new];
    UINavigationController *navigation;
    
    [[ShareEngine sharedInstance] registerApp];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"everLaunched"]) { //check whether first launch or not
        //if it's the first time, then create all tables and set defaults.
        NewFeatureViewController *newFeature = [[NewFeatureViewController alloc]init];
        self.window.rootViewController = newFeature;
        
        [defaults setBool:YES forKey:@"everLaunched"];
        [defaults setBool:YES forKey:@"tipsForNewStuff"];


    } else {
        //if it's not the first time, then direct to the main view.
        if ([defaults floatForKey:@"version"] != app_version) {
            [database createAllTables];
            [defaults setBool:YES forKey:@"tipsForNewStuff"];
            if (![defaults boolForKey:@"isLogin"]) {
                logonViewController = [StartViewController new];
                logonViewController.database = database;
                logonViewController.deviceToken = token;
                
                navigation = [[UINavigationController alloc] initWithRootViewController:logonViewController];
            } else {
                user = [database getUserInfo];
                
                homeViewController = [HomeViewController new];
                homeViewController.database = database;
                homeViewController.user = user;
                
                navigation = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            }
            self.window.rootViewController = navigation;

        } else {
            if (![defaults boolForKey:@"isLogin"]) {
                logonViewController = [StartViewController new];
                logonViewController.database = database;
                logonViewController.deviceToken = token;
                
                navigation = [[UINavigationController alloc] initWithRootViewController:logonViewController];
            } else {
                user = [database getUserInfo];
                
                homeViewController = [HomeViewController new];
                homeViewController.database = database;
                homeViewController.user = user;
                
                navigation = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            }
            self.window.rootViewController = navigation;
        }
        
    }
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [[ShareEngine sharedInstance] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    //NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  [[ShareEngine sharedInstance] handleOpenURL:url];
    
}

/*
#pragma PushNotification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * tempToken = [deviceToken description];
    token = [tempToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [[token componentsSeparatedByString:@" "] componentsJoinedByString:@"" ];
    NSLog(@"got string token %@", token);
    user.deviceToken = token;
    if (!user.ID) {
        logonViewController.deviceToken = token;
    } else {
        [self updateUserDeviceToken];
    }
}

- (void)updateUserDeviceToken {
    NSString *updateAccountService = @"/services/user/";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST_4,updateAccountService,user.ID];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:user.deviceToken forKey:@"deviceToken"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    
    [sessionDataTask resume];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    // set badge to nil when data download.
    //TODO
    [self handleNotification:userInfo];
    //application.applicationIconBadgeNumber = 0;
}

- (void)handleNotification:(NSDictionary *)dict {
//    NotificationMessage *notification = [NotificationMessage new];
//    notification.type = @"1";
//    if ([dict objectForKey:@"name"]) {
//        notification.content = [[NSString alloc] initWithFormat:@"%@ 加入了您的邀请",[dict objectForKey:@"name"]];
//    } else {
//        notification.content = @"";
//    }
//    if ([dict objectForKey:@"date"]) {
//        notification.date = [dict objectForKey:@"date"];
//    } else {
//        notification.date = @"";
//    }
//    if ([dict objectForKey:@"time"]) {
//        notification.time = [dict objectForKey:@"time"];
//    } else {
//        notification.time = @"";
//    }
//    if ([dict objectForKey:@"eventID"]) {
//        notification.eventUUID = [dict objectForKey:@"eventID"];
//        EventInfo *event = [database getEvent:notification.eventUUID];
//        notification.pic = event.template.thumbnail;
//        notification.user = event.user.userID;
//    } else {
//        notification.eventUUID = @"";
//        notification.pic = nil;
//        notification.user = @"";
//    }
//    
//    [database insertNotification:notification];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
*/
@end
