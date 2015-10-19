//
//  HomeViewController.h
//  Shaker2
//
//  Created by Leading Chen on 15/3/30.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "PostCellView.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"
#import "UserSettingViewController.h"


@interface HomeViewController : UIViewController <NavigationBarDelegate, UIScrollViewDelegate, PostCellDelegate,UIGestureRecognizerDelegate, NSURLSessionDataDelegate, UserSettingControllerDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;


@end
