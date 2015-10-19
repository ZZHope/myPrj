//
//  ChooseTopicLayoutViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/7.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "Topic.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"

@protocol ChooseTopicLayoutViewControllerDelegate <NSObject>

- (void)didChooseLayout:(NSInteger)layoutIndex;

@end

@interface ChooseTopicLayoutViewController : UIViewController <NavigationBarDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) id<ChooseTopicLayoutViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *contentImage;

@end

