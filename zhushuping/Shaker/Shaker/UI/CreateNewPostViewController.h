//
//  CreateNewPostViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/15.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"
#import "Post.h"
#import "Card.h"
#import "Topic.h"
#import "ChooseTopicLayoutViewController.h"
#import "AddedPostViewController.h"
#import "ShareViewController.h"

@interface CreateNewPostViewController : UIViewController <NavigationBarDelegate, ChooseTopicLayoutViewControllerDelegate, AddedPostViewControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ShareViewControllerDelegate, ShareEngineDelegate, UIWebViewDelegate>
@property (nonatomic, strong) Topic *topic;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;

@end
