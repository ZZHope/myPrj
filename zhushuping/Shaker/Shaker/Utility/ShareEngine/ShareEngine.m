//
//  ShareEngine.m
//  NetworkTest
//
//  Created by Leading Chen on 14/10/28.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ShareEngine.h"
#import "Contants.h"

@implementation ShareEngine {
    NSString *wbToken;
}

static ShareEngine *sharedSingleton_ = nil;

+ (ShareEngine *) sharedInstance
{
    if (sharedSingleton_ == nil)
    {
        sharedSingleton_ = [ShareEngine new];
    }
    
    return sharedSingleton_;
}

- (void)registerApp {
    [WXApi registerApp:WXAppid withDescription:@"Shaker"];//Weixin
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WeiboAppKey];//Sina Weibo
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.absoluteString hasPrefix:@"wb"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    } else if ([url.absoluteString hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        return NO;
    }
}

- (void)onReq:(BaseReq *)req {
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0) {
            [self.delegate didShareContent:YES];
        } else {
            [self.delegate didShareContent:NO];
        }
        /*
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
         */
    } else if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (resp.errCode == 0) {
            [self getAccess_Token:aresp.code];
        } else {
            UIAlertView *shareAlert = [[UIAlertView alloc] initWithTitle:@"验证失败" message:@"请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [shareAlert show];
        }
        
    }
}

- (void)getAccess_Token:(NSString *)code {
    NSString *URLString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAppid,WXAppSecect,code];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        NSLog(@"%@",dataDic);
        [self getUserInfo:[dataDic valueForKey:@"access_token"] :[dataDic valueForKey:@"openid"]];
    }];
    
    [sessionDataTask resume];
    
}

- (void)getUserInfo:(NSString *)token :(NSString *)openID {
    NSString *URLString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        NSLog(@"%@",dataDic);
        [self.delegate didLogon:@"WX" :dataDic];
    }];
    
    [sessionDataTask resume];
}

- (void)sendLinkContent:(NSInteger)scene :(NSString *)title :(NSString *)description :(UIImage *)thumbImage :(NSURL *)url {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [url absoluteString];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = (int)scene;
    
    [WXApi sendReq:req];
}


- (void)respLinkContent:(NSString *)title :(NSString *)description :(UIImage *)thumbImage :(NSURL *)url {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [url absoluteString];
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void)sendAuthRequest {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo"  ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)respAuthRequest {
    //SendAuthResp *resp = [SendAuthResp new];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
   
}


#pragma WeiBo SDK
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            [self.delegate didShareContent:YES];
        } else {
            [self.delegate didShareContent:NO];
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        //todo
        WBAuthorizeResponse *aresponse = (WBAuthorizeResponse *)response;
        if (aresponse.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            wbToken = [(WBAuthorizeResponse *)response accessToken];
            NSString *uid = aresponse.userID;
            [self getWeiboUserInfo:wbToken :uid];
        }
        
    }
}

- (void)getWeiboUserInfo:(NSString *)token :(NSString *)uid {
    NSString *URLString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",token,uid];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        NSLog(@"%@",dataDic);
        [self.delegate didLogon:@"WB" :dataDic];
    }];
    
    [sessionDataTask resume];
}

- (void)sendSSOAuthRequest {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WeiboRedirectURL;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"Shaker",
                         @"Other_Info_1": [NSNumber numberWithInt:123]};
    [WeiboSDK sendRequest:request];
}

- (void)sendWBLinkeContent:(NSString *)title :(NSString *)description :(UIImage *)thumbImage :(NSURL *)url {
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"Shaker";
    webpage.title = title;
    webpage.description = description;
    webpage.thumbnailData = UIImagePNGRepresentation(thumbImage);
    webpage.webpageUrl = [url absoluteString];
    message.mediaObject = webpage;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = WeiboRedirectURL;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:wbToken];
    request.userInfo = @{@"ShareMessageFrom": @"Shaker",
                         @"Other_Info_1": [NSNumber numberWithInt:123]};
    
    [WeiboSDK sendRequest:request];

}

@end
