//
//  RegisterLogonViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/5/7.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakerDatabase.h"
#import "ForgetPasswordViewController.h"
#import "ShareEngine.h"
#import "NavigationBar.h"

@interface RegisterLogonViewController : UIViewController <UITextFieldDelegate, NSURLSessionDataDelegate,ShareEngineDelegate, NavigationBarDelegate>
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, assign) int flag;

enum {
    LOGON,
    REGISTER
};

@end
