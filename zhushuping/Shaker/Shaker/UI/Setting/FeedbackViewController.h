//
//  FeedbackViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/5/14.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "UserInfo.h"

@interface FeedbackViewController : UIViewController <NavigationBarDelegate, UITextViewDelegate, NSURLSessionDataDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UserInfo *user;

@end
