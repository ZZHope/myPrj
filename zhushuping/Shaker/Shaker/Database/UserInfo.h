//
//  UserInfo.h
//  Shaker2
//
//  Created by Leading Chen on 15/3/30.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (strong ,nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSData *photo;
@property (strong, nonatomic) NSData *backgroundPic;
@property (strong, nonatomic) NSString *QQ;
@property (strong, nonatomic) NSString *weibo;
@property (strong, nonatomic) NSString *weixin;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *ID;

@end
