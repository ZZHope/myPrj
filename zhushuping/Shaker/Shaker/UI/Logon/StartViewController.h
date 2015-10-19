//
//  StartViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/5/8.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakerDatabase.h"
#import "UserInfo.h"

@interface StartViewController : UIViewController
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) NSString *deviceToken;

@end
