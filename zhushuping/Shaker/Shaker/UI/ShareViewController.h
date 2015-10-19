//
//  ShareViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/13.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "Topic.h"
#import "Post.h"
#import "ShareEngine.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"

enum {
    WXTimeLine = 1,
    WXSession = 2,
    Email = 3,
    SinaWB = 4,
    SMS = 5
};

@protocol ShareViewControllerDelegate <NSObject>

- (void)share:(NSInteger)type;

@end

@interface ShareViewController : UIViewController <NavigationBarDelegate, ShareEngineDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) id<ShareViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *fromController;
@property (nonatomic, strong) Topic *topic;
@property (nonatomic, strong) Post *post;
@end
