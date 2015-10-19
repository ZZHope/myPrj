//
//  ShareEngine.h
//  NetworkTest
//
//  Created by Leading Chen on 14/10/28.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@protocol ShareEngineDelegate <NSObject>
@optional
- (void)didLogon:(NSString *)logonType :(NSDictionary *)userDic;
- (void)didShareContent:(BOOL)success;

@end

@interface ShareEngine : NSObject <WXApiDelegate,NSURLSessionDelegate,WeiboSDKDelegate>
@property (nonatomic, strong) id <ShareEngineDelegate> delegate;

+ (ShareEngine *) sharedInstance;
- (void)registerApp;
- (BOOL)handleOpenURL:(NSURL *)url;

- (void)sendLinkContent:(NSInteger)scene :(NSString *)title :(NSString *)description :(UIImage *)thumbImage :(NSURL *)url;
- (void)sendWBLinkeContent:(NSString *)title :(NSString *)description :(UIImage *)thumbImage :(NSURL *)url;

- (void)sendAuthRequest;
- (void)sendSSOAuthRequest;
@end
