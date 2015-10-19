//
//  TopicViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/13.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "TopicViewController.h"
#import "ColorHandler.h"
#import "Contants.h"
#import "TopicCell2.h"
#import "TopicCatalogViewController.h"
#import "CreateNewPostViewController.h"
#import "UIImage+Blur.h"
#import "UIImageView+WebCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "StartViewController.h"
#import "UIImage+Common.h"

@interface TopicViewController ()

@end

@implementation TopicViewController {
    NavigationBar *navigationBar;
    UIView *bottomBar;
    TopicCell2 *topicCell;
    UIView *actionSheet;
    UIView *mask;
    UITapGestureRecognizer *tap1;
    UIWebView *topicWebView;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtn:[UIImage imageNamed:@"returnIcon"]];
    [navigationBar setRightBtn:[UIImage imageNamed:@"moreIcon"]];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"话题"];
    [title addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#2a2a2a"] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
    [navigationBar setTitleTextView:title];
    [navigationBar setBackColor:[UIColor whiteColor]];
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissActionSheet)];
    
    //    [self getTopicFromServer];
    //    [self buildView];
    [self buildWebView];
}

- (void)buildWebView {
    topicWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 28, viewWidth, viewHeight-28)];
    topicWebView.scrollView.bounces = NO;
    topicWebView.scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
    topicWebView.delegate = self;
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@/entity/%@?username=%@&password=%@",HOST_4,_topic.UUID,_user.userID,[self md5HexDigest:_user.password]];
    [topicWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
    [self.view addSubview:topicWebView];
    
}

- (void)buildView {
    [self buildTopicView];
    if (_topic.limitNum == -1) {
        [self buildBottomBar2];
    } else {
        [self buildBottomBar1];
    }
}

- (void)buildTopicView {
    topicCell = [[TopicCell2 alloc] initWithFrame:CGRectMake((viewWidth-333)/2, (viewHeight-511)/2, 333, 511) Topic:_topic];
    [self.view addSubview:topicCell];
    
}

- (void)buildBottomBar1 {
    bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-44, viewWidth, 44)];
    [self.view addSubview:bottomBar];
    [self.view bringSubviewToFront:bottomBar];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0.5f)];
    line.backgroundColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    line.alpha = 0.5f;
    [bottomBar addSubview:line];
    
    UIImage *catalog = [UIImage imageNamed:@"catalog"];
    UIImage *participate = [UIImage imageNamed:@"participate"];
    
    UIControl *catalogCtl = [[UIControl alloc] initWithFrame:CGRectMake(65, 0, catalog.size.width+40, 44)];
    [catalogCtl addTarget:self action:@selector(chooseCatalog) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *catalogImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (44-catalog.size.height)/2, catalog.size.width, catalog.size.height)];
    catalogImageView.image = catalog;
    [catalogCtl addSubview:catalogImageView];
    [bottomBar addSubview:catalogCtl];
    
    UIControl *participateCtl = [[UIControl alloc] initWithFrame:CGRectMake(250, 0, participate.size.width+40, 44)];
    [participateCtl addTarget:self action:@selector(chooseParticipate) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *participateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (44-participate.size.height)/2, participate.size.width, participate.size.height)];
    participateImageView.image = participate;
    [participateCtl addSubview:participateImageView];
    [bottomBar addSubview:participateCtl];
}

- (void)buildBottomBar2 {
    bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-44, viewWidth, 44)];
    [self.view addSubview:bottomBar];
    [self.view bringSubviewToFront:bottomBar];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0.5f)];
    line.backgroundColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    line.alpha = 0.5f;
    [bottomBar addSubview:line];
    
    UIImage *addPost = [UIImage imageNamed:@"addPost"];
    UIButton *addPostBtn = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-addPost.size.width)/2, (bottomBar.bounds.size.height-addPost.size.height)/2, addPost.size.width, addPost.size.height)];
    [addPostBtn setImage:addPost forState:UIControlStateNormal];
    [addPostBtn addTarget:self action:@selector(chooseParticipate) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:addPostBtn];
}

- (void)buildActionSheet {
    if (mask) {
        [mask removeFromSuperview];
        mask = nil;
    }
    mask = [[UIView alloc] initWithFrame:self.view.bounds];
    mask.layer.contents = (id)[self getBlurImageWithCGRect:self.view.frame].CGImage;
    
 
    
    mask.alpha = 0.95f;
    mask.backgroundColor = [UIColor blackColor];
    [mask addGestureRecognizer:tap1];
    [self.view addSubview:mask];
    
    actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, 268)];
    actionSheet.backgroundColor = [UIColor whiteColor];
    actionSheet.alpha = 0.9f;
    
    UIImage *wechatTimeline = [UIImage imageNamed:@"topic_wechatTimelineIcon"];
    UIImage *wechatSession = [UIImage imageNamed:@"topic_wechatSessionIcon"];
    UIImage *weibo = [UIImage imageNamed:@"topic_weiboIcon"];
    
    int kMargin = 20.0f;
    int kBtnWidth= (viewWidth-4*kMargin)*0.33;
    
    UIButton *wechatSessionBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMargin, 37,kBtnWidth , wechatSession.size.height)];//wechatSession.size.width
    wechatSessionBtn.tag = 1;
    [wechatSessionBtn setImage:wechatSession forState:UIControlStateNormal];
    [wechatSessionBtn addTarget:self action:@selector(clickOnActionSheetButton:) forControlEvents:UIControlEventTouchUpInside];
    [actionSheet addSubview:wechatSessionBtn];
    
    UIButton *wechatTimelineBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wechatSessionBtn.frame)+kMargin, 37, kBtnWidth, wechatTimeline.size.height)];//wechatTimeline.size.width
    wechatTimelineBtn.tag = 2;
    [wechatTimelineBtn setImage:wechatTimeline forState:UIControlStateNormal];
    [wechatTimelineBtn addTarget:self action:@selector(clickOnActionSheetButton:) forControlEvents:UIControlEventTouchUpInside];
    [actionSheet addSubview:wechatTimelineBtn];
    
    UIButton *weiboBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wechatTimelineBtn.frame)+kMargin, 37, kBtnWidth, weibo.size.height)];//weibo.size.width
    weiboBtn.tag = 3;
    [weiboBtn setImage:weibo forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(clickOnActionSheetButton:) forControlEvents:UIControlEventTouchUpInside];
    [actionSheet addSubview:weiboBtn];
    
    UIControl *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(29, 144, viewWidth-58, 40)];
    collectBtn.tag = 4;
    collectBtn.backgroundColor = [UIColor whiteColor];
    collectBtn.layer.cornerRadius = 2;
    collectBtn.layer.borderColor = [ColorHandler colorWithHexString:@"#a7a7a7"].CGColor;
    collectBtn.layer.borderWidth = 0.5f;
    UILabel *collectLabel = [[UILabel alloc] initWithFrame:collectBtn.bounds];
    collectLabel.textColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    collectLabel.textAlignment = NSTextAlignmentCenter;
    collectLabel.text = @"收藏";
    collectBtn.layer.borderColor = [ColorHandler colorWithHexString:@"#00d8a5"].CGColor;
    [collectBtn addSubview:collectLabel];
    [collectBtn addTarget:self action:@selector(clickOnActionSheetButton:) forControlEvents:UIControlEventTouchUpInside];
    [actionSheet addSubview:collectBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(29, 206, viewWidth-58, 40)];
    cancelBtn.tag = 5;
    cancelBtn.backgroundColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    cancelBtn.layer.cornerRadius = 2;
    [cancelBtn setTintColor:[UIColor whiteColor]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickOnActionSheetButton:) forControlEvents:UIControlEventTouchUpInside];
    [actionSheet addSubview:cancelBtn];
    
    [self.view addSubview:actionSheet];
    [UIView animateWithDuration:0.8f animations:^{
        [actionSheet setFrame:CGRectMake(0, viewHeight-268, viewWidth, 268)];
    }];
}

- (void)getTopicFromServer {
    NSString *getTopicService = @"/services/entity/";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST_4,getTopicService,_topic.UUID];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            //Set topic
            _topic.title = [[dataDic valueForKey:@"data"] valueForKey:@"title"];
            _topic.content = [[dataDic valueForKey:@"data"] valueForKey:@"content"];
            _topic.type = [[dataDic valueForKey:@"data"] valueForKey:@"type"];
            if ([[[dataDic valueForKey:@"data"] valueForKey:@"thumbnail"] hasPrefix:@"http://"]) {
                _topic.topicImageURL = [[dataDic valueForKey:@"data"] valueForKey:@"thumbnail"];
            } else {
                _topic.topicImageURL = [[NSString alloc] initWithFormat:@"%@%@", HOST_4, [[dataDic valueForKey:@"data"] valueForKey:@"thumbnail"]];
            }
            if ([[[dataDic valueForKey:@"data"] valueForKey:@"picture"] hasPrefix:@"http://"]) {
                _topic.backImageURL = [[dataDic valueForKey:@"data"] valueForKey:@"picture"];
            } else {
                _topic.backImageURL = [[NSString alloc] initWithFormat:@"%@%@", HOST_4, [[dataDic valueForKey:@"data"] valueForKey:@"picture"]];
            }
            _topic.creatorID = [[[dataDic valueForKey:@"data"] valueForKey:@"Owner"] valueForKey:@"id"];
            _topic.creatorName = [[[dataDic valueForKey:@"data"] valueForKey:@"Owner"] valueForKey:@"nickname"];
            if ([[[[dataDic valueForKey:@"data"] valueForKey:@"Owner"] valueForKey:@"profile"] hasPrefix:@"http://"]) {
                _topic.creatorImageURL = [[[dataDic valueForKey:@"data"] valueForKey:@"Owner"] valueForKey:@"profile"];
            } else {
                _topic.creatorImageURL = [[NSString alloc] initWithFormat:@"%@%@", HOST_4, [[[dataDic valueForKey:@"data"] valueForKey:@"Owner"] valueForKey:@"profile"]];
            }
            _topic.topicImageURL = [[dataDic valueForKey:@"data"] valueForKey:@"content"];
            _topic.limitNum = [[[dataDic valueForKey:@"data"] valueForKey:@"postLimit"] integerValue];
            _topic.likeNum = [[[dataDic valueForKey:@"data"] valueForKey:@"likeCount"] integerValue];
            
            if ([_database collectTopic:_topic ByUser:_user]) {//add collectorID
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收藏" message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            
        } else {
            //TODO
        }
    }];
    
    [sessionDataTask resume];
    
}

- (void)chooseCatalog {
    TopicCatalogViewController *topicCatalog = [TopicCatalogViewController new];
    topicCatalog.topic = _topic;
    topicCatalog.user = _user;
    topicCatalog.database = _database;
    [self.navigationController pushViewController:topicCatalog animated:YES];
}

- (void)chooseParticipate {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
       
        CreateNewPostViewController *postCreator = [CreateNewPostViewController new];
        postCreator.topic = _topic;
        postCreator.user = _user;
        postCreator.database = _database;
        [self.navigationController pushViewController:postCreator animated:YES];

    }else{
        
        StartViewController *startVC = [[StartViewController alloc]init];
        [self presentViewController:startVC animated:YES completion:nil];
    }
}

- (void)dismissActionSheet {
    if (actionSheet) {
        [UIView animateWithDuration:0.8f animations:^{
            [actionSheet setFrame:CGRectMake(0, viewHeight, viewWidth, 268)];
        }completion:^(BOOL finished) {
            [actionSheet removeFromSuperview];
            [mask removeFromSuperview];
            [mask removeGestureRecognizer:tap1];
        }];
    }
}

- (void)clickOnActionSheetButton:(UIButton *)btn {
    if (btn.tag == 1) {
        [self wechatSessionShare];
    } else if (btn.tag == 2) {
        [self wechatTimelineShare];
    } else if (btn.tag == 3) {
        [self sinaWeiboShare];
    } else if (btn.tag == 4) {
        [self collect];

    } else if (btn.tag == 5) {
        [self dismissActionSheet];
    }
}

- (UIImage *)getBlurImageWithCGRect:(CGRect)rect {
    //Render the layer in the image context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CALayer *layer = self.view.layer;
    [layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    image = [[UIImage imageWithData:imageData] drn_boxblurImageWithBlur:0.7f];
    
    return image;
}


#pragma mark Share Button Actions
- (void)wechatSessionShare {
    NSString *theme = [_topic.title stringByAppendingString:@":"];
    UIImage *image = [UIImage imageWithOriginImage:_topic.topicImage scaledToSize:CGSizeMake(220, 148)];
    //UIImage *image = [UIImage imageNamed:@"layout1_79122"];
    NSString *content = _topic.content.length >10 ?[[_topic.content substringToIndex:10] stringByAppendingString:@"..."] : _topic.content;
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/entity/",_topic.UUID];
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneSession :theme :content :image :[NSURL URLWithString:URLString]];
}

- (void)wechatTimelineShare {
    NSString *theme = [_topic.title stringByAppendingString:@":"];
    UIImage *image = [UIImage imageWithOriginImage:_topic.topicImage scaledToSize:CGSizeMake(220, 140)];
    //UIImage *image = [UIImage imageNamed:@"layout1_79122"];
    NSString *content = _topic.content.length >10 ?[[_topic.content substringToIndex:10] stringByAppendingString:@"..."] : _topic.content;
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/entity/",_topic.UUID];
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneTimeline :theme :content :image :[NSURL URLWithString:URLString]];
}

- (void)sinaWeiboShare {
    NSString *theme = [_topic.title stringByAppendingString:@":"];
        UIImage *image = [UIImage imageWithOriginImage:_topic.topicImage scaledToSize:CGSizeMake(220/1.5, 140/1.5)];//UIImage *image = [UIImage imageNamed:@"layout1_79122"];
    NSString *content = _topic.content.length >10 ?[[_topic.content substringToIndex:10] stringByAppendingString:@"..."] : _topic.content;
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://v2.shaker.mobi",@"/entity/",_topic.UUID];
    [[ShareEngine sharedInstance] sendWBLinkeContent:content :theme :image :[NSURL URLWithString:URLString]];
}

- (void)collect {
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        
        
        [self getTopicFromServer];

        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登陆", nil];
        alert.tag = 10;
        [alert show];

        
    }

}

- (NSString *)md5HexDigest:(NSString*)input {
    if (!input) {
        return @"";
    }
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (int)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked {
    [self buildActionSheet];
}


#pragma mark WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *URL = [request URL];
        if ([[URL absoluteString] containsString:@"catalog"]) {
            [self chooseCatalog];
        } else if ([[URL absoluteString] containsString:@"join"]) {
            [self chooseParticipate];
        }else{
            return YES; 
        }
        return NO;
    }
    return YES;
}

- (NSDictionary *)parseURL:(NSURL *)url{
    NSMutableDictionary *paraDictionary = [NSMutableDictionary new];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@", url];
    NSArray *compontent1 = [urlString componentsSeparatedByString:@"?"];
    NSString *parameterString = [compontent1 lastObject];
    NSArray *parameterArray = [parameterString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameterArray) {
        NSArray *keyVal = [parameter componentsSeparatedByString:@"="];
        if (keyVal.count > 0) {
            NSString *paraKey = [keyVal objectAtIndex:0];
            NSString *value = (keyVal.count == 2) ? [keyVal lastObject] : nil;
            [paraDictionary setValue:value forKey:paraKey];
        }
    }
    return paraDictionary;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -- alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            case 0:
            [self dismissActionSheet];
            break;
        case 1:{
            if (alertView.tag==10) {
                [self dismissActionSheet];
                StartViewController *startVC = [[StartViewController alloc]init];
                [self presentViewController:startVC animated:YES completion:nil];
            }
        }
            
        default:
            break;
    }
}
@end
