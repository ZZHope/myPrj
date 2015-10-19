//
//  UserSettingViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/5/12.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "ShakerDatabase.h"
#import "UserInfo.h"
#import "ImageCropperViewController.h"

@protocol UserSettingControllerDelegate <NSObject>

- (void)didFinishAccountSettingwith:(UserInfo *)user;

@end

@interface UserSettingViewController : UIViewController <NavigationBarDelegate, NSURLSessionDataDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,ImageCropperDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) id<UserSettingControllerDelegate> delegate;

@end
