//
//  PostViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/16.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "NavigationBar.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"

@interface PostViewController : UIViewController <NavigationBarDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) Post *post;
@end
