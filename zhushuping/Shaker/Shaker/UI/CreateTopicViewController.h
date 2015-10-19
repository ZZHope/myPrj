//
//  CreateTopicViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/4.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "ShakerDatabase.h"
#import "ChooseTopicLayoutViewController.h"
#import "ChooseTopicSettingViewController.h"
#import "Topic.h"
#import "UserInfo.h"
#import "ImageCropperViewController.h"
#import "ShareViewController.h"


@interface CreateTopicViewController : UIViewController <NavigationBarDelegate, ChooseTopicLayoutViewControllerDelegate, ChooseTopicSettingViewControllerDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, NSURLSessionDataDelegate, ShareViewControllerDelegate, ShareEngineDelegate, ImageCropperDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) Topic *topic;
@end
