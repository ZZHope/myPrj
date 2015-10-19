//
//  WebContentViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/17.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"
#import "Topic.h"
#import "Post.h"
#import "Card.h"

enum {
    TOPIC,
    POST,
    CARD
};

@interface WebContentViewController : UIViewController <NavigationBarDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) Topic *topic;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) Card *card;
@end
