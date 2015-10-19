//
//  TopicViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/13.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "NavigationBar.h"
#import "UserInfo.h"
#import "ShareEngine.h"
#import "ShakerDatabase.h"

@protocol TopicViewControllerDelegate <NSObject>

- (void)share:(NSInteger)type;

@end

@interface TopicViewController : UIViewController <ShareEngineDelegate, NavigationBarDelegate, NSURLSessionDataDelegate, UIWebViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) Topic *topic;
@property (nonatomic, strong) id<TopicViewControllerDelegate> delegate;
@end
