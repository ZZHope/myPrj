//
//  CreateTopicViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/4.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "CreateTopicViewController.h"
#import "ColorHandler.h"
#import "Contants.h"
#import "ShareViewController.h"
#import "UIImage+Common.h"
#import "ProgressHUD.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface CreateTopicViewController ()

@end

@implementation CreateTopicViewController {
    NavigationBar *navigationBar;
    UIView *bottomBar;
    NSMutableArray *layoutContentArray;
    NSInteger currentLayoutIndex;
    NSString *layoutID;
    UIScrollView *contentView;
    UIImageView *topicImageView;
    UITextView *topicTitleView;
    UITextView *topicContentView;
    CGRect topicTitleViewFrame;
    CGRect topicContentViewFrame;
    UITapGestureRecognizer *tapGesture;
    UITapGestureRecognizer *tap;
    NSMutableAttributedString *titlePlaceholder;
    NSMutableAttributedString *contentPlaceholder;
    UIActionSheet *myActionSheet;
    int retryNum;
    CAShapeLayer *topicContentViewBorder;
    UIView *line1;
    UIView *line2;
    UIView *mask;
    UIView *inputView;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
    //删除line
    if (currentLayoutIndex != 4) {
        if ([contentView.subviews containsObject:line1]) {
            [line1 removeFromSuperview];
        }
        if ([contentView.subviews containsObject:line2]) {
            [line2 removeFromSuperview];
        }
    }
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtnWithString:@"取消" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    [navigationBar setRightBtnWithString:@"创建" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"创建话题"];
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
    layoutID =  @"theme_01";
    [self createNewTopic];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    [self generateTopicLayoutArray];
    currentLayoutIndex = 1;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePic)];
    [tap setNumberOfTapsRequired:1];
    
    titlePlaceholder = [[NSMutableAttributedString alloc] initWithString:@"输入标题"];
    [titlePlaceholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, titlePlaceholder.length)];
    [titlePlaceholder addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, titlePlaceholder.length)];
    contentPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"输入内容"];
    [contentPlaceholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, contentPlaceholder.length)];
    [contentPlaceholder addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#a7a7a7"] range:NSMakeRange(0, contentPlaceholder.length)];
    
    //build textView Accessory View
    [self buildTextAccessoryView];
    
    [self buildView];
    
    
    
}

- (void)buildView {
    [self buildContentView];
    [self buildBottomBar];
}

- (void)buildContentView {
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, viewWidth, viewHeight-44-64)];
    contentView.contentSize = CGSizeMake(viewWidth, viewWidth*559/375);//20150527
    contentView.bounces = NO;
    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    //default layout
    [self buildLayout2];//更改了默认版式
    
}

- (void) buildBottomBar {
    bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-44, viewWidth, 44)];
    [self.view addSubview:bottomBar];
    [self.view bringSubviewToFront:bottomBar];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0.5f)];
    line.backgroundColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    [bottomBar addSubview:line];
    
    UIImage *layout = [UIImage imageNamed:@"topic_layout"];
    UIImage *setting = [UIImage imageNamed:@"topic_setting"];
    
    UIControl *layoutCtl = [[UIControl alloc] initWithFrame:CGRectMake(65, 0, layout.size.width+40, 44)];
    [layoutCtl addTarget:self action:@selector(chooseLayout) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *layoutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (44-layout.size.height)/2, layout.size.width, layout.size.height)];
    layoutImageView.image = layout;
    [layoutCtl addSubview:layoutImageView];
    [bottomBar addSubview:layoutCtl];
    
    UIControl *settingCtl = [[UIControl alloc] initWithFrame:CGRectMake(viewWidth-65-setting.size.width-40, 0, setting.size.width+40, 44)];
    [settingCtl addTarget:self action:@selector(chooseSetting) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *settingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (44-setting.size.height)/2, setting.size.width, setting.size.height)];
    settingImageView.image = setting;
    [settingCtl addSubview:settingImageView];
    [bottomBar addSubview:settingCtl];
}

- (void)chooseLayout {
    ChooseTopicLayoutViewController *chooseLayoutController = [ChooseTopicLayoutViewController new];
    chooseLayoutController.delegate =self;
    chooseLayoutController.user = _user;
    chooseLayoutController.database = _database;
    if (layoutContentArray.count > currentLayoutIndex) {
        chooseLayoutController.contentImage = [layoutContentArray objectAtIndex:currentLayoutIndex];
    } else {
        chooseLayoutController.contentImage = [UIImage imageNamed:@"layout1_285440"];
    }
    [self.navigationController pushViewController:chooseLayoutController animated:YES];
    
}

- (void)chooseSetting {
    ChooseTopicSettingViewController *chooseSettingController = [ChooseTopicSettingViewController new];
    chooseSettingController.delegate = self;
    chooseSettingController.user = _user;
    chooseSettingController.database = _database;
    if (layoutContentArray.count > currentLayoutIndex) {
        chooseSettingController.contentImage = [layoutContentArray objectAtIndex:currentLayoutIndex];
    } else {
        chooseSettingController.contentImage = [UIImage imageNamed:@"layout1_285440"];
    }
    [self.navigationController pushViewController:chooseSettingController animated:YES];
    
}

- (void)generateTopicLayoutArray {
    if (layoutContentArray) {
        [layoutContentArray removeAllObjects];
        layoutContentArray = nil;
    }
    UIImage *layoutContentImage1 = [UIImage imageNamed:@"layout1_285440"];
    UIImage *layoutContentImage2 = [UIImage imageNamed:@"layout2_285440"];
    UIImage *layoutContentImage3 = [UIImage imageNamed:@"layout3_285440"];
    UIImage *layoutContentImage4 = [UIImage imageNamed:@"layout4_285440"];
    UIImage *layoutContentImage5 = [UIImage imageNamed:@"layout5_285440"];
    
    [layoutContentArray addObject:layoutContentImage1];
    [layoutContentArray addObject:layoutContentImage2];
    [layoutContentArray addObject:layoutContentImage3];
    [layoutContentArray addObject:layoutContentImage4];
    [layoutContentArray addObject:layoutContentImage5];
}

- (void)createNewTopic {
    //TODO
    _topic = [Topic new];
    _topic.creatorName = _user.name;
    _topic.creatorID = _user.ID;
    _topic.creatorImage = [UIImage imageWithData:_user.photo];
}

- (void)saveTopic {
    if ([_topic.title isEqual:@""] && [_topic.content isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建话题" message:@"请添加话题标题或内容" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertView show];
        return;
    }
    _topic.layoutID = layoutID;
    _topic.backImage = topicImageView.image;
    _topic.topicImage = [UIImage imageCaptureScrollView:contentView];
    retryNum = 0;
    [navigationBar disableRightBtn];
    [ProgressHUD show:@"请稍候。。"];
    [self saveTopicOnServer];
    
}

- (void)shareTopic {
    //push the shareViewController
    ShareViewController *share = [ShareViewController new];
    share.delegate = self;
    share.topic = _topic;
    share.user = _user;
    share.database = _database;
    [self.navigationController pushViewController:share animated:YES];
}

- (void)saveTopicOnServer {
    NSData *bookData = [self generateFormData];
    
    NSString *createTopicService = @"/services/entity";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,createTopicService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *boundary = [NSString stringWithFormat:@"---------------------------1i7l7o0v8e1x6y3f8775746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:bookData];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        [ProgressHUD dismiss];
        [navigationBar enableRightBtn];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            _topic.UUID = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            if ([_database createNewTopic:_topic]) {
                [self shareTopic];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
                [alertView show];
            }
        } else if ([[dataDic valueForKey:@"data"] isEqualToString:@"NOT_LOGIN"]) {
            [self loginAndSaveAgain];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
    }];
    [sessionDataTask resume];
}

- (void)loginAndSaveAgain {
    if (retryNum > 4) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
        [alertView show];
        return;
    }
    NSString *loginService = @"/services/user/login";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,loginService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_user.userID forKey:@"username"];
    [dic setValue:_user.password forKey:@"password"];
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:bodyData];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            [self saveTopicOnServer];
            retryNum ++;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
    }];
    
    [sessionDataTask resume];
}

- (NSData *)generateFormData {
    NSString *boundary = [NSString stringWithFormat:@"---------------------------1i7l7o0v8e1x6y3f8775746641449"];
    NSMutableData *data = [NSMutableData data];
    
    //Set Topic Title
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"title\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[_topic.title dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Set Topic Content
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"content\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[_topic.content dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Set Topic Photo
    NSData *backImageData = UIImageJPEGRepresentation(_topic.backImage, 0.5);
    if (backImageData) {
        [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:backImageData];
        [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Set Topic Thumbnail
    NSData *topicImageData = UIImageJPEGRepresentation(_topic.topicImage, 1.0);
    if (topicImageData) {
        [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"thumbnail\"; filename=\"thumbnail.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:topicImageData];
        [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Set Topic Category
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"category\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"话题" dataUsingEncoding:NSUTF8StringEncoding]];
    //Set Topic Type
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"type\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"realism" dataUsingEncoding:NSUTF8StringEncoding]];
    //Set Topic PostLimit
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"postLimit\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[[NSString alloc] initWithFormat:@"%d",(int)_topic.limitNum] dataUsingEncoding:NSUTF8StringEncoding]];
    //Set Topic Theme
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"theme\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[_topic.themeID dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Set Topic Layout
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"layout\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[_topic.layoutID dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Close Form
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}

#pragma mark build layout
- (void)resetLayout {
    if (topicImageView) {
        [topicImageView removeFromSuperview];
        topicImageView = nil;
    }
    if (topicTitleView) {
        [topicTitleView removeFromSuperview];
        topicTitleView = nil;
    }
    if (topicContentView) {
        [topicContentView removeFromSuperview];
        topicContentView = nil;
    }
    if (currentLayoutIndex == 0) {
        [self buildLayout1];
    } else if (currentLayoutIndex == 2) {
        [self buildLayout2];
    } else if (currentLayoutIndex == 1) {
        [self buildLayout3];
    } else if (currentLayoutIndex == 3) {
        [self buildLayout4];
    } else if (currentLayoutIndex == 4) {
        [self buildLayout5];
    } else {
        [self buildLayout1];
    }
}

- (void)buildTextAccessoryView {
    //增加一个inputAccessory，可以点击返回键盘
    
    inputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 26)];
    inputView.backgroundColor = [UIColor whiteColor];
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewWidth-80, 1, 70, 24)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[ColorHandler colorWithHexString:@"00d8a5"] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [doneBtn addTarget:self action:@selector(resignKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:doneBtn];
}

- (void)buildLayout1 {
    contentView.contentSize = CGSizeMake(viewWidth, viewWidth*559/375);//20150527
    layoutID = [[NSString alloc] initWithFormat:@"%@-layout_01",_topic.themeID];
    topicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth*559/375)];//20150527
    [topicImageView setUserInteractionEnabled:YES];
    [topicImageView addGestureRecognizer:tap];
    topicImageView.tag = 2;
    //set image
    if (_topic.backImage) {
        topicImageView.image = _topic.backImage;
    } else {
        topicImageView.image = [UIImage imageNamed:@"topic_bg"];
    }
    
    [contentView addSubview:topicImageView];
    topicTitleView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-200)/2.0, 235*contentView.contentSize.height/559, 200, 45)];//20150527
    topicTitleViewFrame = topicTitleView.frame;
    topicTitleView.tag = 3;
    topicTitleView.contentSize = CGSizeMake(topicTitleView.bounds.size.width, topicTitleView.bounds.size.height);
    topicTitleView.inputAccessoryView = inputView;
    topicTitleView.delegate = self;
    topicTitleView.backgroundColor = [UIColor clearColor];
    topicTitleView.textColor = [UIColor whiteColor];
    topicTitleView.font = [UIFont fontWithName:@"STSong" size:25];
    if ([_topic.title isEqual:@""]) {
        topicTitleView.attributedText = titlePlaceholder;
    } else {
        topicTitleView.text = _topic.title;
    }
    topicTitleView.textAlignment = NSTextAlignmentCenter;
    //    topicTitleView.returnKeyType = UIReturnKeyDone;//20150527
    
    [topicImageView addSubview:topicTitleView];
    
    topicContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-257)/2.0, CGRectGetMaxY(topicTitleView.frame)+8, 257, 30)];//x=(viewWidth-257)/2,y=288
    topicContentViewFrame = topicContentView.frame;
    topicContentView.inputAccessoryView = inputView;
    topicContentView.tag = 4;
    topicContentView.delegate = self;
    //    topicContentView.returnKeyType = UIReturnKeyDone;//20150527
    topicContentView.backgroundColor = [UIColor clearColor];
    topicContentView.textColor = [UIColor whiteColor];
    topicContentView.font = [UIFont fontWithName:@"STSong" size:16];
    if ([_topic.content isEqual:@""]) {
        topicContentView.attributedText = contentPlaceholder;
    } else {
        topicContentView.text = _topic.content;
    }
    topicContentView.textAlignment = NSTextAlignmentCenter;
    [topicImageView addSubview:topicContentView];
}

- (void)buildLayout2 {
    contentView.contentSize = CGSizeMake(viewWidth, viewWidth*559/375);//20150527
    layoutID = [[NSString alloc] initWithFormat:@"%@-layout_03",_topic.themeID];
    
    topicImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-335*viewWidth/375)/2, 20, 335*viewWidth/375, 335*viewWidth/375)];
    [topicImageView setUserInteractionEnabled:YES];
    [topicImageView addGestureRecognizer:tap];
    topicImageView.tag = 3;
    //set image
    if (_topic.backImage) {
        topicImageView.image = _topic.backImage;
    } else {
        topicImageView.image = [UIImage imageNamed:@"topic_bg"];
    }
    [contentView addSubview:topicImageView];
    
    
    topicTitleView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-319*viewWidth/375)/2, topicImageView.frame.origin.y+topicImageView.bounds.size.height+65*(contentView.contentSize.height/559), 319*viewWidth/375, 45)];
    topicTitleViewFrame = topicTitleView.frame;
    topicTitleView.tag = 5;
    topicTitleView.delegate = self;
    topicTitleView.scrollEnabled = NO;
    topicTitleView.inputAccessoryView = inputView;
    topicTitleView.backgroundColor = [UIColor clearColor];
    topicTitleView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    topicTitleView.font = [UIFont fontWithName:@"STSong" size:24];
    if ([_topic.title isEqual:@""]) {
        topicTitleView.text = titlePlaceholder.string;
    } else {
        topicTitleView.text = _topic.title;
    }
    [contentView addSubview:topicTitleView];
    
    topicContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-319*viewWidth/375)/2, topicTitleView.frame.origin.y+topicTitleView.bounds.size.height+8, 319*viewWidth/375, 40)];
    topicContentViewFrame = topicContentView.frame;
    topicContentView.tag = 6;
    topicContentView.delegate = self;
    topicContentView.inputAccessoryView = inputView;
    topicContentView.backgroundColor = [UIColor clearColor];
    topicContentView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    topicContentView.font = [UIFont fontWithName:@"STSong" size:16];
    if ([_topic.content isEqual:@""]) {
        topicContentView.text = contentPlaceholder.string;
    } else {
        topicContentView.text = _topic.content;
    }
    [contentView addSubview:topicContentView];
    
}

- (void)buildLayout3 {
    contentView.contentSize = CGSizeMake(viewWidth, viewWidth*559/375);//20150527
    layoutID = [[NSString alloc] initWithFormat:@"%@-layout_02",_topic.themeID];
    float d = 288*viewWidth/375;
    topicImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-d)/2.0, 78*contentView.contentSize.height/599, d, d)];//20150527
    [topicImageView setUserInteractionEnabled:YES];
    topicImageView.tag = 4;
    topicImageView.layer.cornerRadius = topicImageView.bounds.size.width/2;
    topicImageView.layer.masksToBounds = YES;
    topicImageView.contentMode = UIViewContentModeScaleAspectFill;
    [topicImageView addGestureRecognizer:tap];
    //set image
    if (_topic.backImage) {
        topicImageView.image = _topic.backImage;
    } else {
        topicImageView.image = [UIImage imageNamed:@"topic_bg"];
    }
    [contentView addSubview:topicImageView];
    float w = 275*viewWidth/375;
    topicTitleView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-w)/2.0, topicImageView.frame.origin.y+topicImageView.bounds.size.height+65*contentView.contentSize.height/559, w, 45)];
    topicTitleViewFrame = topicTitleView.frame;
    topicTitleView.tag = 7;
    topicTitleView.delegate = self;
    topicTitleView.scrollEnabled = NO;
    topicTitleView.backgroundColor = [UIColor clearColor];
    topicTitleView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    topicTitleView.font = [UIFont fontWithName:@"STSong" size:24];
    if ([_topic.title isEqual:@""]) {
        topicTitleView.text = titlePlaceholder.string;
    } else {
        topicTitleView.text = _topic.title;
    }
    topicTitleView.textAlignment = NSTextAlignmentCenter;
    topicTitleView.inputAccessoryView = inputView;
    [contentView addSubview:topicTitleView];
    
    topicContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-w)/2.0, topicTitleView.frame.origin.y+topicTitleView.bounds.size.height+4, w, 30)];
    topicContentViewFrame = topicContentView.frame;
    topicContentView.tag = 8;
    topicContentView.delegate = self;
    topicContentView.inputAccessoryView = inputView;
    topicContentView.backgroundColor = [UIColor clearColor];
    topicContentView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    topicContentView.font = [UIFont fontWithName:@"STSong" size:16];
    if ([_topic.content isEqual:@""]) {
        topicContentView.text = contentPlaceholder.string;
    } else {
        topicContentView.text = _topic.content;
    }
    topicContentView.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:topicContentView];
}

- (void)buildLayout4 {
    contentView.contentSize = CGSizeMake(viewWidth, viewWidth*559/375);//20150527
    layoutID = [[NSString alloc] initWithFormat:@"%@-layout_04",_topic.themeID];
    
    topicTitleView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-275)/2, 249*contentView.contentSize.height/599, 275, 45)];
    topicTitleViewFrame = topicTitleView.frame;
    topicTitleView.tag = 9;
    topicTitleView.delegate = self;
    topicContentView.inputAccessoryView = inputView;
    topicTitleView.backgroundColor = [UIColor clearColor];
    topicTitleView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    topicTitleView.font = [UIFont fontWithName:@"STSong" size:24];
    if ([_topic.title isEqual:@""]) {
        topicTitleView.text = titlePlaceholder.string;
    } else {
        topicTitleView.text = _topic.title;
    }
    [contentView addSubview:topicTitleView];
    
    
    topicContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-275)/2, topicTitleView.frame.origin.y+topicTitleView.bounds.size.height+8, 275, 30)];
    topicContentViewFrame = topicContentView.frame;
    topicContentView.tag = 10;
    topicContentView.delegate = self;
    topicContentView.inputAccessoryView = inputView;
    topicContentView.backgroundColor = [UIColor clearColor];
    topicContentView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    topicContentView.font = [UIFont fontWithName:@"STSong" size:16];
    if ([_topic.content isEqual:@""]) {
        topicContentView.text = contentPlaceholder.string;
    } else {
        topicContentView.text = _topic.content;
    }
    //    topicContentView.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:topicContentView];
    
}

- (void)buildLayout5 {
    contentView.contentSize = CGSizeMake(viewWidth, viewWidth*559/375);//20150527
    layoutID = [[NSString alloc] initWithFormat:@"%@-layout_05",_topic.themeID];
    line1 = [[UIView alloc] initWithFrame:CGRectMake((viewWidth-292)/2, 150*contentView.contentSize.height/599, 292, 0.5)];
    line1.backgroundColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    [contentView addSubview:line1];
    
    topicTitleView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-275)/2, 249*contentView.contentSize.height/599, 275, 45)];
    topicTitleViewFrame = topicTitleView.frame;
    topicTitleView.tag = 11;
    topicTitleView.delegate = self;
    topicTitleView.inputAccessoryView = inputView;
    topicTitleView.backgroundColor = [UIColor clearColor];
    topicTitleView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    topicTitleView.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:24];
    if ([_topic.title isEqual:@""]) {
        topicTitleView.text = titlePlaceholder.string;
    } else {
        topicTitleView.text = _topic.title;
    }
    [contentView addSubview:topicTitleView];
    
    topicContentView = [[UITextView alloc] initWithFrame:CGRectMake((viewWidth-275)/2, topicTitleView.frame.origin.y+topicTitleView.bounds.size.height+8, 275, 30)];
    topicContentViewFrame = topicContentView.frame;
    topicContentView.tag = 12;
    topicContentView.delegate = self;
    topicContentView.inputAccessoryView = inputView;
    topicContentView.backgroundColor = [UIColor clearColor];
    topicContentView.textColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    topicContentView.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
    if ([_topic.content isEqual:@""]) {
        topicContentView.text = contentPlaceholder.string;
    } else {
        topicContentView.text = _topic.content;
    }
    [contentView addSubview:topicContentView];
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake((viewWidth-292)/2, 429*contentView.contentSize.height/599, 292, 0.5)];
    line2.backgroundColor = [ColorHandler colorWithHexString:@"#2a2a2a"];
    [contentView addSubview:line2];
}

- (void)changePic {
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];//此版本暂不做调整图片
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}


- (void)resignKeyBoard {
    [topicTitleView resignFirstResponder];
    [topicContentView resignFirstResponder];
    [topicImageView removeGestureRecognizer:tapGesture];
    [topicImageView addGestureRecognizer:tap];
}

- (CAShapeLayer *)drawDashBorderWith:(CGRect)frame :(CGFloat)cornerRadius :(CGFloat)borderWidth :(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the shapeLayer object's path
    shapeLayer.path = path;
    CGPathRelease(path);
    
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    shapeLayer.frame = frame;
    shapeLayer.masksToBounds = NO;
    [shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.strokeColor = [lineColor CGColor];
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineDashPattern = [NSArray arrayWithObjects: [NSNumber numberWithInt:3], [NSNumber numberWithInt:2], nil];
    shapeLayer.lineCap = kCALineCapButt;
    
    return shapeLayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//有改动 1，2交换
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    float offset;
    if (currentLayoutIndex == 0 || currentLayoutIndex == 3 || currentLayoutIndex == 4) {
        offset = 50;//20150527
    } else if (currentLayoutIndex == 1 || currentLayoutIndex == 2) {
        offset = topicImageView.bounds.size.height/2;
    }
    [contentView setFrame:CGRectMake(contentView.frame.origin.x, -offset, contentView.bounds.size.width, contentView.bounds.size.height)];
    contentView.contentSize = CGSizeMake(contentView.contentSize.width, contentView.contentSize.height+offset);
    contentView.contentOffset = CGPointMake(0, offset); //20150527
    [topicImageView removeGestureRecognizer:tap];
    [contentView addGestureRecognizer:tapGesture];
    [textView becomeFirstResponder];
    if (textView.tag == 1 || textView.tag == 3 || textView.tag == 5 || textView.tag == 7 || textView.tag == 9 || textView.tag == 11) {
        if ([textView.text isEqualToString:titlePlaceholder.string]) {
            textView.text = @"";
        }
    } else if (textView.tag == 2 || textView.tag == 4 || textView.tag == 6 || textView.tag == 8 || textView.tag == 10 || textView.tag == 12) {
        if ([textView.text isEqualToString:contentPlaceholder.string]) {
            textView.text = @"";
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        if (textView.tag == 1 || textView.tag == 3) {
            textView.attributedText = titlePlaceholder;
            textView.textAlignment = NSTextAlignmentCenter;
            _topic.title = @"";
        } else if (textView.tag == 5 || textView.tag == 9 || textView.tag == 11) {
            textView.text = titlePlaceholder.string;
            textView.textAlignment = NSTextAlignmentLeft;
            _topic.title = @"";
        } else if (textView.tag == 7) {
            textView.text = titlePlaceholder.string;
            textView.textAlignment = NSTextAlignmentCenter;
            _topic.title = @"";
        } else if (textView.tag == 2 || textView.tag == 4) {
            textView.attributedText = contentPlaceholder;
            textView.textAlignment = NSTextAlignmentCenter;
            _topic.content = @"";
        } else if (textView.tag == 6 || textView.tag == 10 || textView.tag == 12) {
            textView.text = contentPlaceholder.string;
            textView.textAlignment = NSTextAlignmentLeft;
            _topic.content = @"";
        } else if (textView.tag == 8) {
            textView.text = contentPlaceholder.string;
            textView.textAlignment = NSTextAlignmentCenter;
            _topic.content = @"";
        }
    } else {
        if (textView.tag == 1 || textView.tag == 3 || textView.tag == 5 || textView.tag == 7 || textView.tag == 9 ||textView.tag == 11) {
            _topic.title = textView.text;
        } else if (textView.tag == 2 || textView.tag == 4 || textView.tag == 6 || textView.tag == 8 || textView.tag == 10 ||textView.tag == 12) {
            _topic.content = textView.text;
        }
    }
    [contentView setFrame:CGRectMake(contentView.frame.origin.x, 64, contentView.bounds.size.width, contentView.bounds.size.height)];
    contentView.contentSize = CGSizeMake(viewWidth, viewWidth*559/375);
    [self resignKeyBoard];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.tag == 3) {
        if (textView.text.length > 16) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 16)];
        }
        CGSize size = [topicTitleView sizeThatFits:CGSizeMake(topicTitleView.bounds.size.width, topicTitleView.bounds.size.height)];//make the size change with textView's text.
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-8-size.height,
                                            topicTitleView.bounds.size.width,
                                            size.height)];
        //keep the text view change when text changes
    } else if (textView.tag == 4) {
        if (textView.text.length > 208) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 208)];
        }
        CGSize size = [topicContentView sizeThatFits:CGSizeMake(topicContentView.bounds.size.width, topicContentView.bounds.size.height)];
        float maxHeight = 317*contentView.contentSize.height/559;
        float minY = 165*contentView.contentSize.height/559;
        [topicContentView setFrame:CGRectMake(topicContentViewFrame.origin.x,
                                              topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height)<minY?minY:topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height),
                                              topicContentView.bounds.size.width,
                                              size.height>maxHeight?maxHeight:size.height)];
        
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-8-topicTitleView.bounds.size.height,
                                            topicTitleView.bounds.size.width,
                                            topicTitleView.bounds.size.height)];
        //keep the text view change when text changes
    }  else if (textView.tag == 5) { //第二个版式的title
        if (textView.text.length > 28) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 28)];
        }
        CGSize size = [topicTitleView sizeThatFits:CGSizeMake(topicTitleView.bounds.size.width, topicTitleView.bounds.size.height)];
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-8-size.height,
                                            topicTitleView.bounds.size.width,
                                            size.height
                                            )];
        //keep the text view change when text changes
    } else if (textView.tag == 6) {//第二个版式的content
        if (textView.text.length > 80) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 80)];
        }
        CGSize size = [topicContentView sizeThatFits:CGSizeMake(topicContentView.bounds.size.width, topicContentView.bounds.size.height)];
        float maxHeight = 90*contentView.contentSize.height/559*0.5;//ZSP修改
        float minY = 461*contentView.contentSize.height/559*0.5;//ZSP修改
        [topicContentView setFrame:CGRectMake(topicContentViewFrame.origin.x,
                                              topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height)<minY?minY:topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height),
                                              topicContentView.bounds.size.width,
                                              size.height>maxHeight?maxHeight:size.height)];
        
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-8-topicTitleView.bounds.size.height,
                                            topicTitleView.bounds.size.width,
                                            topicTitleView.bounds.size.height)];
        //keep the text view change when text changes
    }  else if (textView.tag == 7) {
        if (textView.text.length > 24) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 24)];
        }
        CGSize size = [topicTitleView sizeThatFits:CGSizeMake(topicTitleView.bounds.size.width, topicTitleView.bounds.size.height)];
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-4-size.height,
                                            topicTitleView.bounds.size.width,
                                            size.height)];
        //keep the text view change when text changes
    } else if (textView.tag == 8) {
        if (textView.text.length > 68) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 68)];
        }
        CGSize size = [topicContentView sizeThatFits:CGSizeMake(topicContentView.bounds.size.width, topicContentView.bounds.size.height)];
        float maxHeight = 82*contentView.contentSize.height/559;
        float minY = 365*contentView.contentSize.height/559;
        [topicContentView setFrame:CGRectMake(topicContentViewFrame.origin.x,
                                              topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height)<minY?minY:topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height),
                                              topicContentView.bounds.size.width,
                                              size.height>maxHeight?maxHeight:size.height)];
        
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-4-topicTitleView.bounds.size.height,
                                            topicTitleView.bounds.size.width,
                                            topicTitleView.bounds.size.height)];
        //keep the text view change when text changes
    }  else if (textView.tag == 9) {
        if (textView.text.length > 24) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 24)];
        }
        CGSize size = [topicTitleView sizeThatFits:CGSizeMake(topicTitleView.bounds.size.width, topicTitleView.bounds.size.height)];
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-8-size.height,
                                            topicTitleView.bounds.size.width,
                                            size.height)];
        //keep the text view change when text changes
    } else if (textView.tag == 10) {
        if (textView.text.length > 255) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 255)];
        }
        CGSize size = [topicContentView sizeThatFits:CGSizeMake(topicContentView.bounds.size.width, topicContentView.bounds.size.height)];
        float maxHeight = 369*contentView.contentSize.height/559;
        float minY = 145*contentView.contentSize.height/559;
        [topicContentView setFrame:CGRectMake(topicContentViewFrame.origin.x,
                                              topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height)<minY?minY:topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height),
                                              topicContentView.bounds.size.width,
                                              size.height>maxHeight?maxHeight:size.height)];
        
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-8-topicTitleView.bounds.size.height,
                                            topicTitleView.bounds.size.width,
                                            topicTitleView.bounds.size.height)];
        //keep the text view change when text changes
    }  else if (textView.tag == 11) {
        if (textView.text.length > 20) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 20)];
        }
        CGSize size = [topicTitleView sizeThatFits:CGSizeMake(topicTitleView.bounds.size.width, topicTitleView.bounds.size.height)];
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-8-size.height,
                                            topicTitleView.bounds.size.width,
                                            size.height)];
        //keep the text view change when text changes
        if (topicTitleView.frame.origin.y - line1.frame.origin.y < 23) {
            [line1 setFrame:CGRectMake(line1.frame.origin.x, topicTitleView.frame.origin.y - 23, line1.bounds.size.width, line1.bounds.size.height)];
        }
    } else if (textView.tag == 12) {
        if (textView.text.length > 195) {
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 195)];
        }
        CGSize size = [topicContentView sizeThatFits:CGSizeMake(topicContentView.bounds.size.width, topicContentView.bounds.size.height)];
        float maxHeight = 315*contentView.contentSize.height/559;
        float minY = 171*contentView.contentSize.height/559;
        [topicContentView setFrame:CGRectMake(topicContentViewFrame.origin.x,
                                              topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height)<minY?minY:topicContentViewFrame.origin.y-(topicContentView.contentSize.height-topicContentViewFrame.size.height),
                                              topicContentView.bounds.size.width,
                                              size.height>maxHeight?maxHeight:size.height)];
        
        [topicTitleView setFrame:CGRectMake(topicTitleViewFrame.origin.x,
                                            topicContentView.frame.origin.y-8-topicTitleView.bounds.size.height,
                                            topicTitleView.bounds.size.width,
                                            topicTitleView.bounds.size.height)];
        //keep the text view change when text changes
        if (topicTitleView.frame.origin.y - line1.frame.origin.y < 23) {
            [line1 setFrame:CGRectMake(line1.frame.origin.x, topicTitleView.frame.origin.y - 23, line1.bounds.size.width, line1.bounds.size.height)];
        }
        if (line2.frame.origin.y - (topicContentView.frame.origin.y+topicContentView.bounds.size.height) < 23) {
            [line2 setFrame:CGRectMake(line2.frame.origin.x, topicContentView.frame.origin.y+topicContentView.bounds.size.height+ 23, line2.bounds.size.width, line2.bounds.size.height)];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.length+range.location > textView.text.length) {
        return NO;
    }
    NSInteger newLength = [textView.text length] + [text length] - range.length;
    if (textView.tag == 1 || textView.tag == 3) {//title
        if (newLength <= 16) {//20150527
            return YES;
        } else {
            return NO;
        }
    } else if (textView.tag == 5) {
        if (newLength <= 28) {
            return YES;
        }
        return NO;
    } else if (textView.tag == 7) {
        if (newLength <= 24) {
            return YES;
        }
        return NO;
    } else if (textView.tag == 9) {
        if (newLength <= 24) {
            return YES;
        }
        return NO;
    } else if (textView.tag == 11) {
        if (newLength <= 20) {
            return YES;
        }
        return NO;
    } else if (textView.tag == 2 || textView.tag == 4) {//content
        if (newLength <= 208) {
            return YES;
        }
        return NO;
    } else if (textView.tag == 6) {
        if (newLength <= 80) {
            return YES;
        }
        return NO;
    } else if (textView.tag == 8) {
        if (newLength <= 68) {
            return YES;
        }
        return NO;
    } else if (textView.tag == 10) {
        if (newLength <= 255) {
            return YES;
        }
        return NO;
    } else if (textView.tag == 12) {
        if (newLength <= 195) {
            return YES;
        }
        return NO;
    }else {
        return NO;
    }
}

#pragma mark ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self locolPhoto];
                
                break;
            default:
                break;
        }
    } else if (actionSheet.tag == 2) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self locolPhoto];
                break;
            default:
                break;
        }
    }
}

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"You don't have a camera!");
    }
}

- (void)locolPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    //picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^(){
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [self imageByScalingToMaxSize:image];
        // 裁剪
        ImageCropperViewController *imgEditorVC = [[ImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 40, topicImageView.bounds.size.width, topicImageView.bounds.size.height)];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark ImageCropperDelegate
- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    topicImageView.image = editedImage;
    _topic.backImage = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}


- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5+20;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消创建" message:@"确定要取消创建么？" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是", nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)rightBtnClicked {
    //save the topic
    [self saveTopic];
}

#pragma mark ChooseTopicLayoutDelegate
- (void)didChooseLayout:(NSInteger)layoutIndex {
    currentLayoutIndex = layoutIndex;
    [self resetLayout];
}

#pragma mark ChooseSettingDelegate
- (void)didChooseSetting:(NSInteger)limitNum {
    _topic.limitNum = limitNum;
}

#pragma mark Share Button Actions
- (void)wechatSessionShare {
    NSString *theme = [_topic.title stringByAppendingString:@":"];
    UIImage *image = _topic.topicImage;
    //    UIImage *image = [UIImage imageNamed:@"layout1_79122"];
    NSString *content = _topic.content.length >10 ?[[_topic.content substringToIndex:10] stringByAppendingString:@"..."] : _topic.content;
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/entity/",_topic.UUID];
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneSession :theme :content :image :[NSURL URLWithString:URLString]];
}

- (void)wechatTimelineShare {
    NSString *theme = [_topic.title stringByAppendingString:@":"];
    //    UIImage *image = _topic.topicImage;
    UIImage *image = [UIImage imageNamed:@"layout1_79122"];
    NSString *content = _topic.content.length >10 ?[[_topic.content substringToIndex:10] stringByAppendingString:@"..."] : _topic.content;
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/entity/",_topic.UUID];
    [[ShareEngine sharedInstance] sendLinkContent:WXSceneTimeline :theme :content :image :[NSURL URLWithString:URLString]];
}

- (void)sinaWeiboShare {
    NSString *theme = [_topic.title stringByAppendingString:@":"];
    //    UIImage *image = [UIImage imageWithData:UIImageJPEGRepresentation(_topic.topicImage, 0.001)];
    UIImage *image = [UIImage imageNamed:@"layout1_79122"];
    NSString *content = _topic.content.length >10 ?[[_topic.content substringToIndex:10] stringByAppendingString:@"..."] : _topic.content;
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@",HOST_4,@"/entity/",_topic.UUID];
    [[ShareEngine sharedInstance] sendWBLinkeContent:content :theme :image :[NSURL URLWithString:URLString]];
}

#pragma mark ShareViewControllerDelegate
- (void)share:(NSInteger)type {
    if (type == WXTimeLine) {
        [self wechatTimelineShare];
    } else if (type == WXSession) {
        [self wechatSessionShare];
    } else if (type == SinaWB) {
        [self sinaWeiboShare];
    }
}

@end
