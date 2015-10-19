//
//  UserInfoViewController.h
//  xike
//
//  Created by Leading Chen on 14-9-19.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakerDatabase.h"
#import "UserInfo.h"
#import "ImageCropperViewController.h"
#import "NavigationBar.h"

@interface UserInfoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate, NSURLSessionDataDelegate,ImageCropperDelegate,NavigationBarDelegate>

@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) UserInfo *user;

@end
