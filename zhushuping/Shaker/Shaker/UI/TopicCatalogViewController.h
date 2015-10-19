//
//  TopicCatalogViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/15.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "Topic.h"
#import "Post.h"
#import "Card.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"


@interface TopicCatalogViewController : UIViewController <NavigationBarDelegate,NSURLSessionDataDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property Topic *topic;

@end
