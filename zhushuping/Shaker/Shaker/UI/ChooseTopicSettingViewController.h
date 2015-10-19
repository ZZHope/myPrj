//
//  ChooseTopicSettingViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/7.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"

@protocol ChooseTopicSettingViewControllerDelegate <NSObject>

- (void)didChooseSetting:(NSInteger)limitNum;

@end

@interface ChooseTopicSettingViewController : UIViewController <NavigationBarDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) id <ChooseTopicSettingViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *contentImage;

@end
