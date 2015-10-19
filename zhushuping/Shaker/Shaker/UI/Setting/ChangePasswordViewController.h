//
//  ChangePasswordViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/5/14.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"

@interface ChangePasswordViewController : UIViewController <NavigationBarDelegate, UITextFieldDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;

@end
