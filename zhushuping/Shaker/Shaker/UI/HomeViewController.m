//
//  HomeViewController.m
//  Shaker2
//
//  Created by Leading Chen on 15/3/30.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "HomeViewController.h"
#import "CreateTopicViewController.h"
#import "ColorHandler.h"
#import "UIImage+Blur.h"
#import "Contants.h"
#import "TopicViewController.h"
#import "UIImageView+WebCache.h"
#import "ShareViewController.h"
#import "MailViewController.h"

#define kWidth self.view.bounds.size.width
#define kHeight self.view.bounds.size.height


enum TabPage {
    EXPLORE_PAGE,
    PERSONAL_PAGE,
};

@interface HomeViewController ()<UIAlertViewDelegate>

@end

@implementation HomeViewController {
    NavigationBar *navigationBar;
    NSInteger currentTab;
    //ExploreView
    UIScrollView *exploreBackView;
    UILabel *refreshLabel;
    UILabel *loadLabel;
    CGRect categoryBarOriginalRect;
    Topic *recommendedTopic;
    UIImageView *recommendImageView;
    UIView *categoryBar;
    UIControl *categoryCtl1;
    UIControl *categoryCtl2;
    UIControl *categoryCtl3;
    UILabel *categoryLabel1;
    UILabel *categoryLabel2;
    UILabel *categoryLabel3;
    UIView *categoryContent1;
    UIView *categoryContent2;
    UIView *categoryContent3;
    UIView *indicator;
    NSMutableArray *topicArray1;
    NSMutableArray *topicArray2;
    NSMutableArray *topicArray3;
    
    //PersonalView
    UIView *personalView;
    UIView *userInfoView;
    UIImageView *userImageView;
    UILabel *nicknameLabel;
    UILabel *descLabel;
    UILabel *mineNumLabel;
    UILabel *mineHead;
    UILabel *markNumLabel;
    UILabel *markHead;
    UIControl *mineCtl;
    UIControl *markCtl;
    NSMutableArray *mineArray;
    NSMutableArray *markArray;
    UIScrollView *mineScrollView;
    UIScrollView *markScrollView;
    UIImageView *loadingIconView;
    UIImageView *loadingTextView;
    
    //TabBar
    UIView *tabBar;
    CGPoint currentOffset;
    BOOL isShow;
    BOOL isDecelerate;
    UIImageView *exploreBtnImageView;
    UIImageView *createBtnImageView;
    UIImageView *personalBtnImageView;
    //Create
    UIView *mask;
    UIView *chooseCategoryView;
    UIControl *category1;
    UIControl *category2;
    UITapGestureRecognizer *tapGesture;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
    //remove mask &chooseCategoryView
    if (mask) {
        [mask removeFromSuperview];
        mask = nil;
    }
    if (chooseCategoryView) {
        [chooseCategoryView removeFromSuperview];
        chooseCategoryView = nil;
    }
    // show tabbar
    [self showTabBar];
//    [self refreshData];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    if (navigationBar) {
        [navigationBar removeFromSuperview];
        navigationBar = nil;
    }
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    
    if (currentTab == EXPLORE_PAGE) {
        [navigationBar setRightBtn:[UIImage imageNamed:@"home_mail"]];
        
        
        
        [navigationBar setTitleImageView:[UIImage imageNamed:@"logo_title"]];
    } else if (currentTab == PERSONAL_PAGE) {
        [navigationBar setRightBtn:[UIImage imageNamed:@"personalSetting"]];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"个人主页"];
        [title addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#2a2a2a"] range:NSMakeRange(0, title.length)];
        [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
        [navigationBar setTitleTextView:title];
    }
    
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setFloat:app_version forKey:@"version"];
    
    topicArray1 = [NSMutableArray new];
    topicArray2 = [NSMutableArray new];
    topicArray3 = [NSMutableArray new];
    mineArray = [NSMutableArray new];
    markArray = [NSMutableArray new];
    recommendedTopic = [Topic new];
    // Do any additional setup after loading the view.
    currentTab = EXPLORE_PAGE;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelCreateTopic)];
    tapGesture.delegate = self;
    UIImage *loadingIcon = [UIImage imageNamed:@"loadingIcon"];
    UIImage *loadingText = [UIImage imageNamed:@"loadingText"];
    loadingIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, loadingIcon.size.width, loadingIcon.size.height)];
    loadingIconView.image = loadingIcon;
    loadingTextView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, loadingText.size.width, loadingText.size.height)];
    loadingTextView.image = loadingText;
    
    indicator = [[UIView alloc] initWithFrame:CGRectMake(0, categoryBar.bounds.size.height-1, categoryBar.bounds.size.width/2, 1)];//20150610
    
    _user = [_database getUserInfo];//20150610增加，修复了再次登录不显示个人信息的bug
    [self buildExploreView];
    [self buildPersonalView];
    [self buildTabBar];
    
    [self getData];
    
   

}

- (void)buildExploreView {
    exploreBackView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, viewWidth, viewHeight)];
    
    exploreBackView.delegate = self;
    exploreBackView.showsVerticalScrollIndicator = NO;
    exploreBackView.showsHorizontalScrollIndicator = NO;
    exploreBackView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:exploreBackView];
    
    [loadingTextView setFrame:CGRectMake((exploreBackView.bounds.size.width-loadingTextView.bounds.size.width)/2, -28, loadingTextView.bounds.size.width, loadingTextView.bounds.size.height)];
    [loadingIconView setFrame:CGRectMake(loadingTextView.frame.origin.x-5-loadingIconView.bounds.size.width, -28, loadingIconView.bounds.size.width, loadingIconView.bounds.size.height)];
    
    
    UIControl *recommendCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 44-20, viewWidth, 248)];
    [recommendCtl addTarget:self action:@selector(goToRecommendTopic) forControlEvents:UIControlEventTouchUpInside];
    [exploreBackView addSubview:recommendCtl];
    
    recommendImageView = [[UIImageView alloc] initWithFrame:recommendCtl.bounds];
    [recommendCtl addSubview:recommendImageView];
    categoryBarOriginalRect = CGRectMake(0, 248+44-20, viewWidth, 40);
    
    [self buildCategoryBar];
    [self buildCategoryContent];
}

- (void)buildCategoryBar {
    categoryBar = [[UIView alloc] initWithFrame:categoryBarOriginalRect];
    categoryBar.backgroundColor = [UIColor whiteColor];
    [exploreBackView addSubview:categoryBar];
    

    
    categoryCtl2 = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, categoryBar.bounds.size.width/2.0, categoryBar.bounds.size.height)];
    categoryCtl2.backgroundColor = [UIColor clearColor];
    categoryCtl2.tag = 2;
    [categoryCtl2 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    categoryLabel2 = [[UILabel alloc] initWithFrame:categoryCtl2.bounds];
    
    categoryLabel2.textColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    categoryLabel2.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12];
    categoryLabel2.text = @"超现实";
    categoryLabel2.textAlignment = NSTextAlignmentCenter;
    [categoryCtl2 addSubview:categoryLabel2];
    [categoryBar addSubview:categoryCtl2];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(categoryBar.bounds.size.width/2-0.5, (categoryBar.bounds.size.height-10)/2.0, 1, 10)];
    line2.backgroundColor = [ColorHandler colorWithHexString:@"d6d6d6"];
    [categoryBar addSubview:line2];
    
    categoryCtl3 = [[UIControl alloc] initWithFrame:CGRectMake(categoryBar.bounds.size.width/2.0, 0, categoryBar.bounds.size.width/2, categoryBar.bounds.size.height)];
    categoryCtl3.backgroundColor = [UIColor clearColor];
    categoryCtl3.tag = 3;
    [categoryCtl3 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    categoryLabel3 = [[UILabel alloc] initWithFrame:categoryCtl3.bounds];
    categoryLabel3.textColor = [ColorHandler colorWithHexString:@"#9e9e9e"];
    categoryLabel3.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12];
    categoryLabel3.text = @"反现实";
    categoryLabel3.textAlignment = NSTextAlignmentCenter;
    [categoryCtl3 addSubview:categoryLabel3];
    [categoryBar addSubview:categoryCtl3];
    
    indicator = [[UIView alloc] initWithFrame:CGRectMake(0, categoryBar.bounds.size.height-1, categoryBar.bounds.size.width/2, 1)];
    indicator.backgroundColor = [ColorHandler colorWithHexString:@"00d8a5"];
    [categoryBar addSubview:indicator];

}
//尺寸修改
- (void)buildCategoryContent {
    categoryContent2 = [[UIView alloc] initWithFrame:CGRectMake(0, 288+44-20, viewWidth,304)];//304
    [exploreBackView addSubview:categoryContent2];

    categoryContent3 = [[UIView alloc] initWithFrame:CGRectMake(viewWidth, 288+44-20, viewWidth, 304)];
    [exploreBackView addSubview:categoryContent3];
}

- (void)buildCategoryContentWith:(NSMutableArray *)topics :(NSInteger)index {
    
    float x = 0;
    float y = 0;
    float cellWidth =  (viewWidth-3)/2; //0527
    float cellHeight = cellWidth*559/375+40;//0527
    for (int i=0; i<topics.count; i++) {
        Topic *topic = [topics objectAtIndex:i];
        x = i%2==0?0:viewWidth-cellWidth;
        y = ceilf(i/2)*cellHeight;
        
        //topics
        if (topics.count) {
            
            PostCellView *postCell = [[PostCellView alloc] initWithFrame:CGRectMake(x, y, cellWidth, cellHeight) Topic:topic];
            postCell.delegate = self;
            if (index == 1) {
                [categoryContent1 addSubview:postCell];
            } else if (index == 2) {
                [categoryContent2 addSubview:postCell];
            } else if (index == 3) {
                [categoryContent3 addSubview:postCell];
            }

            
        }else{
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, cellWidth, cellHeight)];
            imgView.image = [UIImage imageNamed:@"noTopic"];
        }
        
        
    }
}

- (void)buildPersonalCotentWith:(NSMutableArray *)topics :(NSInteger)index {
    

    
    float x = 0;
    float y = 0;
    float cellWidth = (viewWidth-3)/2;
    float cellHeight = cellWidth*559/375+40;//0527
    for (int i=0; i<topics.count; i++) {
        Topic *topic = [topics objectAtIndex:i];
        x = i%2==0?0:viewWidth-cellWidth;
        y = floorf(i/2)*cellHeight;
        
        PostCellView *postCell = [[PostCellView alloc] initPersonalPostWithFrame:CGRectMake(x, y, cellWidth, cellHeight) Topic:topic];

        postCell.delegate = self;
        if (index == 1) {//创建个人主页
            [mineScrollView addSubview:postCell];
        } else if (index == 2) {
            [markScrollView addSubview:postCell];
        }
    }
}

- (void)buildPersonalView {
    personalView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, viewWidth, viewHeight-20)];
    personalView.backgroundColor = [UIColor whiteColor];
    userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, viewWidth, 138)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, userInfoView.bounds.size.height-0.5, userInfoView.bounds.size.width, 0.5)];
    line.backgroundColor = [ColorHandler colorWithHexString:@"#a2a2a2"];
    [userInfoView addSubview:line];
    [personalView addSubview:userInfoView];
    
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 32, 75, 75)];
    userImageView.layer.cornerRadius = 2;
    if (_user.photo){
        
        userImageView.image = [UIImage imageWithData:_user.photo];
        
    }else{
        userImageView.image = [UIImage imageNamed:@"defaultUserPic2"];
    }
    [userInfoView addSubview:userImageView];
    
    nicknameLabel = [self buildLabel:_user.name :[ColorHandler colorWithHexString:@"#2a2a2a"] :[UIFont systemFontOfSize:18]];
    [nicknameLabel setFrame:CGRectMake(108, 59, viewWidth-118, nicknameLabel.bounds.size.height)];
    [userInfoView addSubview:nicknameLabel];
    
    descLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"简介: %@", _user.desc] :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:12]];
    [descLabel setFrame:CGRectMake(108, 89, viewWidth-118, descLabel.bounds.size.height)];
    [userInfoView addSubview:descLabel];
    
    UIView *boxCategoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 138+44, viewWidth, 58)];
    boxCategoryView.backgroundColor = [UIColor whiteColor];
    [personalView addSubview:boxCategoryView];
    
    mineCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth/2, 58)];
    mineCtl.tag = 1;
    [mineCtl addTarget:self action:@selector(clickOnBoxCategory:) forControlEvents:UIControlEventTouchUpInside];
    [boxCategoryView addSubview:mineCtl];
    mineHead = [self buildLabel:@"我的" :[ColorHandler colorWithHexString:@"#00d8a5"] :[UIFont systemFontOfSize:12]];
    [mineHead setFrame:CGRectMake((viewWidth/2-mineHead.bounds.size.width)/2, 38, mineHead.bounds.size.width, mineHead.bounds.size.height)];
    [mineCtl addSubview:mineHead];
    
    markCtl = [[UIControl alloc] initWithFrame:CGRectMake(viewWidth/2, 0, viewWidth/2, 58)];
    markCtl.tag = 2;
    [markCtl addTarget:self action:@selector(clickOnBoxCategory:) forControlEvents:UIControlEventTouchUpInside];
    [boxCategoryView addSubview:markCtl];
    markHead = [self buildLabel:@"收藏" :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:12]];
    [markHead setFrame:CGRectMake((viewWidth/2-markHead.bounds.size.width)/2, 38, markHead.bounds.size.width, markHead.bounds.size.height)];
    [markCtl addSubview:markHead];
}

- (void)buildTabBar {
    if (tabBar) {
        [tabBar removeFromSuperview];
    }
    tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-44, viewWidth, 44)];
    tabBar.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabBar.bounds.size.width, 0.5)];
    line.backgroundColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    [tabBar addSubview:line];
    [self.view addSubview:tabBar];
    [self.view bringSubviewToFront:tabBar];
    float ctlWidth = viewWidth/3;
    float ctlHeight = 44;
    
    UIControl *exploreCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ctlWidth, ctlHeight)];
    exploreCtl.tag = 1;
    [exploreCtl addTarget:self action:@selector(clickOnTabBar:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *exploreIcon_h = [UIImage imageNamed:@"explore_h"];
    UIImage *exploreIcon_u = [UIImage imageNamed:@"explore_u"];
    exploreBtnImageView = [[UIImageView alloc] initWithImage:exploreIcon_u highlightedImage:exploreIcon_h];
    [exploreBtnImageView setCenter:CGPointMake(ctlWidth/2, ctlHeight/2)];
    [exploreBtnImageView setHighlighted:YES];
    [exploreCtl addSubview:exploreBtnImageView];
    [tabBar addSubview:exploreCtl];
    
    UIControl *createCtl = [[UIControl alloc] initWithFrame:CGRectMake(ctlWidth, 0, ctlWidth, ctlHeight)];
    createCtl.tag = 2;
    [createCtl addTarget:self action:@selector(clickOnTabBar:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *createIcon = [UIImage imageNamed:@"createIcon"];
    createBtnImageView = [[UIImageView alloc] initWithImage:createIcon];
    [createBtnImageView setCenter:CGPointMake(ctlWidth/2, ctlHeight/2)];
    [createCtl addSubview:createBtnImageView];
    [tabBar addSubview:createCtl];
    
    UIControl *personalCtl = [[UIControl alloc] initWithFrame:CGRectMake(ctlWidth*2, 0, ctlWidth, ctlHeight)];
    personalCtl.tag = 3;
    [personalCtl addTarget:self action:@selector(clickOnTabBar:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *personalIcon_h = [UIImage imageNamed:@"person_h"];
    UIImage *personalIcon_u = [UIImage imageNamed:@"person_u"];
    personalBtnImageView = [[UIImageView alloc] initWithImage:personalIcon_u highlightedImage:personalIcon_h];
    [personalBtnImageView setCenter:CGPointMake(ctlWidth/2, ctlHeight/2)];
    [personalCtl addSubview:personalBtnImageView];
    [tabBar addSubview:personalCtl];
}

- (void)showTabBar {
    [UIView animateWithDuration:0.3f animations:^{
        [tabBar setFrame:CGRectMake(0, viewHeight-tabBar.bounds.size.height, tabBar.bounds.size.width, tabBar.bounds.size.height)];
    } completion:^(BOOL finished){
        isShow = YES;
    }];
}

- (void)dismissTabBar {
    [UIView animateWithDuration:0.3f animations:^{
        [tabBar setFrame:CGRectMake(0, viewHeight, tabBar.bounds.size.width, tabBar.bounds.size.height)];
    } completion:^(BOOL finished){
        isShow = NO;
    }];
}

- (void)buildChooseCategoryView {
    if (mask) {
        [mask removeFromSuperview];
        mask = nil;
    }
    if (chooseCategoryView) {
        [chooseCategoryView removeFromSuperview];
        chooseCategoryView = nil;
    }
    mask = [[UIView alloc] initWithFrame:self.view.bounds];
    mask.layer.contents = (id)[self getBlurImageWithCGRect:self.view.frame].CGImage;
    [self.view addSubview:mask];

    chooseCategoryView = [[UIView alloc] initWithFrame:self.view.bounds];
    chooseCategoryView.alpha = 0.7f;
    chooseCategoryView.backgroundColor = [UIColor blackColor];
    [chooseCategoryView addGestureRecognizer:tapGesture];
    category1 = [[UIControl alloc] initWithFrame:CGRectMake(10, 119, viewWidth-20, 222)];
    category1.tag = 1;
    category1.layer.borderWidth = 1;
    category1.layer.borderColor = [ColorHandler colorWithHexString:@"#ffffff"].CGColor;
    [category1 addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *category1ImageView = [[UIImageView alloc] initWithFrame:category1.bounds];
    category1ImageView.image = [UIImage imageNamed:@"category1"];
    [category1 addSubview:category1ImageView];
    [chooseCategoryView addSubview:category1];
    
    category2 = [[UIControl alloc] initWithFrame:CGRectMake(10, 351, viewWidth-20, 222)];
    category2.tag = 2;
    category2.layer.borderWidth = 1;
    category2.layer.borderColor = [ColorHandler colorWithHexString:@"#ffffff"].CGColor;
    [category2 addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *category2ImageView = [[UIImageView alloc] initWithFrame:category2.bounds];
    category2ImageView.image = [UIImage imageNamed:@"category2"];
    [category2 addSubview:category2ImageView];
    [chooseCategoryView addSubview:category2];
    
    [self.view addSubview:chooseCategoryView];
}

- (void)cancelCreateTopic {
    [chooseCategoryView removeGestureRecognizer:tapGesture];
    [chooseCategoryView removeFromSuperview];
    [UIView animateWithDuration:0.8f animations:^{
        mask.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [mask removeFromSuperview];
    }];
}

- (void)clickOnTabBar:(UIControl *)ctl {
    if (ctl.tag == 1) {
        [exploreBtnImageView setHighlighted:YES];
        [personalBtnImageView setHighlighted:NO];
        //set ExploreView
        currentTab = EXPLORE_PAGE;

        [self.view addSubview:exploreBackView];
        [self buildNavigationBar];
        [self.view bringSubviewToFront:tabBar];
    } else if (ctl.tag == 2) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isLogin"]boolValue]) {
           
            //Create Post/Entity
            CreateTopicViewController *topicCreator = [[CreateTopicViewController alloc] init];
            topicCreator.user = _user;
            topicCreator.database = _database;
            [self.navigationController pushViewController:topicCreator animated:YES];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            
            [alert show];
           // [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        
    } else if (ctl.tag == 3) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isLogin"]boolValue]){
            
            [exploreBtnImageView setHighlighted:NO];
            [personalBtnImageView setHighlighted:YES];
            [exploreBackView removeFromSuperview];
            //set PersonalView
            currentTab = PERSONAL_PAGE;
            [self.view addSubview:personalView];
            [self buildNavigationBar];
            [self.view bringSubviewToFront:tabBar];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            
            [alert show];
            //[self dismissViewControllerAnimated:YES completion:nil];
        }
            
    }
}

- (void)chooseCategory:(UIControl *)ctl {
    if (ctl.tag == 1) {
        //create category1
        CreateTopicViewController *topicCreator = [CreateTopicViewController new];
        topicCreator.user = _user;
        topicCreator.database = _database;
        [UIView animateWithDuration:0.2f animations:^{
            category1.layer.borderColor = [ColorHandler colorWithHexString:@"#1de9b6"].CGColor;
        } completion:^(BOOL finished) {
            [self.navigationController pushViewController:topicCreator animated:YES];
        }];
        
    } else if (ctl.tag == 2) {
        //create category2
        CreateTopicViewController *topicCreator = [CreateTopicViewController new];
        topicCreator.user = _user;
        topicCreator.database = _database;
        [UIView animateWithDuration:0.2f animations:^{
            category2.layer.borderColor = [ColorHandler colorWithHexString:@"#1de9b6"].CGColor;
        } completion:^(BOOL finished) {
            [self.navigationController pushViewController:topicCreator animated:YES];
        }];
    }
}

- (void)clickOnCategory:(UIControl *)ctl {

    if (ctl.tag == 2) {
        //choose category two
//        categoryLabel1.textColor = [ColorHandler colorWithHexString:@"#9e9e9e"];
        categoryLabel2.textColor = [ColorHandler colorWithHexString:@"#00d8a5"];
        categoryLabel3.textColor = [ColorHandler colorWithHexString:@"#9e9e9e"];
//        float exploreBackView_h = 152 + 315*(ceil(topicArray2.count/2)+1);//20150610
//        exploreBackView.contentSize = CGSizeMake(viewWidth, exploreBackView_h);
        
       
        [UIView animateWithDuration:0.5f animations:^{
            [indicator setFrame:CGRectMake(0, categoryBar.bounds.size.height-1, categoryBar.bounds.size.width/2, 1)];

            
            [categoryContent2 setFrame:CGRectMake(0, 288+44-20, categoryContent2.bounds.size.width, categoryContent2.bounds.size.height)];
            [categoryContent3 setFrame:CGRectMake(viewWidth, 288+44-20, categoryContent3.bounds.size.width, categoryContent3.bounds.size.height)];
            
        } completion:^(BOOL finished){
            //reset exploreBackView's height
        }];
        
    } else if (ctl.tag == 3) {
        //choose category three

        categoryLabel2.textColor = [ColorHandler colorWithHexString:@"#9e9e9e"];
        categoryLabel3.textColor = [ColorHandler colorWithHexString:@"#00d8a5"];
//        float exploreBackView_h = 152 + 315*(ceil(topicArray3.count/2)+1);//0527//20150610
//        exploreBackView.contentSize = CGSizeMake(viewWidth, exploreBackView_h);//0619
//        
        [UIView animateWithDuration:0.5f animations:^{
            [indicator setFrame:CGRectMake(categoryBar.bounds.size.width/2, categoryBar.bounds.size.height-1, categoryBar.bounds.size.width/2, 1)];

    //correct the categoryContent frame setting
            [categoryContent2 setFrame:CGRectMake(-viewWidth, 288+44-20, categoryContent2.bounds.size.width, categoryContent2.bounds.size.height)];
            [categoryContent3 setFrame:CGRectMake(0, 288+44-20, categoryContent3.bounds.size.width, categoryContent3.bounds.size.height)];
    //correct the categoryContent frame setting
            
        } completion:^(BOOL finished){
            //reset exploreBackView's height
        }];
        
    }
}

- (void)clickOnBoxCategory:(UIControl *)ctl {
    if (ctl.tag == 1) {
        //choose mine Content
        [UIView animateWithDuration:0.5f animations:^{
            [mineScrollView setFrame:CGRectMake(0, 196+44, viewWidth, viewHeight-196-44-20)];
            [markScrollView setFrame:CGRectMake(viewWidth, 196+44, viewWidth, viewHeight-196-44-20)];
        }completion:^(BOOL finished) {
            mineNumLabel.textColor = [ColorHandler colorWithHexString:@"#00d8a5"];
            mineHead.textColor = [ColorHandler colorWithHexString:@"#00d8a5"];
            markNumLabel.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
            markHead.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
        }];
        
    } else if (ctl.tag == 2) {
        //choose mark Content
        [UIView animateWithDuration:0.5f animations:^{
            [mineScrollView setFrame:CGRectMake(-viewWidth, 196+44, viewWidth,viewHeight-196-44-20)];
            [markScrollView setFrame:CGRectMake(0, 196+44, viewWidth, viewHeight-196-44-20)];
        }completion:^(BOOL finished) {
            mineNumLabel.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
            mineHead.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
            markNumLabel.textColor = [ColorHandler colorWithHexString:@"#00d8a5"];
            markHead.textColor = [ColorHandler colorWithHexString:@"#00d8a5"];
        }];
    }
}

- (void)goToRecommendTopic {
    TopicViewController *topViewController = [TopicViewController new];
    topViewController.user = _user;
    topViewController.database = _database;
    topViewController.topic = recommendedTopic;
    [self.navigationController pushViewController:topViewController animated:YES];
}

- (void)getData {
    
    [self getRecommendData];
    //20150610
    [self getCategoryData:@"anti-realism"];
    [self getCategoryData:@"surrealism"];
    
    [self getMineArray];
    [self getMarkArray];
    
}

- (void)getCategoryData:(NSString *)type {
    NSString *getEntityTypeService = @"/services/entity/type/";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST_4,getEntityTypeService,type];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            int cnt = (int)[[dataDic valueForKey:@"data"] count];
           
            //correct the categoryContent frame setting
            if ([type isEqualToString:@"surrealism"]) {
                //Default contentSize of exploreBackView
                float exploreBackView_h = 152 + 315*(ceil(cnt/2)+1);//20150610
                [indicator setFrame:CGRectMake(0, categoryBar.bounds.size.height-1, categoryBar.bounds.size.width/2, 1)];
                exploreBackView.contentSize = CGSizeMake(viewWidth, exploreBackView_h);
               [categoryContent2 setFrame:CGRectMake(categoryContent2.frame.origin.x, categoryContent2.frame.origin.y, categoryContent2.bounds.size.width, exploreBackView_h)];//20150527
                //[indicator setFrame:CGRectMake(0, categoryBar.bounds.size.height-1, categoryBar.bounds.size.width/2, 1)];//20150610
                
            } else if ([type isEqualToString:@"anti-realism"]) {
                float exploreBackView_h = 152+ 315*(ceil(cnt/2)+1);//20150610
                exploreBackView.contentSize = CGSizeMake(viewWidth, exploreBackView_h);
                [categoryContent3 setFrame:CGRectMake(categoryContent3.frame.origin.x, categoryContent3.frame.origin.y, categoryContent3.bounds.size.width, exploreBackView_h)];
                //[indicator setFrame:CGRectMake(categoryBar.bounds.size.width/2, categoryBar.bounds.size.height-1, categoryBar.bounds.size.width/2, 1)];//20150610
            }
            //correct the categoryContent frame setting
            
            
            for (int i=0; i<cnt; i++) {
                Topic *topic = [Topic new];
                NSDictionary *topicDataDic = [[dataDic valueForKey:@"data"] objectAtIndex:i];
                topic.UUID = [topicDataDic valueForKey:@"id"];
                topic.title = [topicDataDic valueForKey:@"title"];
                topic.content = [topicDataDic valueForKey:@"content"];
                topic.type = [topicDataDic valueForKey:@"type"];
                topic.likeNum = [[topicDataDic valueForKey:@"likeCount"] integerValue];
                topic.limitNum =[[topicDataDic valueForKey:@"postLimit"] integerValue];
                if ([[topicDataDic valueForKey:@"thumbnail"] hasPrefix:@"http://"]) {
                    topic.topicImageURL = [topicDataDic valueForKey:@"thumbnail"];
                } else {
                    topic.topicImageURL = [[NSString alloc] initWithFormat:@"%@%@", HOST_4, [topicDataDic valueForKey:@"thumbnail"]];
                }
                if ([[topicDataDic valueForKey:@"picture"] hasPrefix:@"http://"]) {
                    topic.backImageURL = [topicDataDic valueForKey:@"picture"];
                } else {
                    topic.backImageURL = [[NSString alloc] initWithFormat:@"%@%@", HOST_4, [topicDataDic valueForKey:@"picture"]];
                }
                topic.creatorID = [[topicDataDic valueForKey:@"Owner"] valueForKey:@"id"];
                topic.creatorName = [[topicDataDic valueForKey:@"Owner"] valueForKey:@"nickname"];
                if ([[[topicDataDic valueForKey:@"Owner"] valueForKey:@"profile"] hasPrefix:@"http://"]) {
                    topic.creatorImageURL = [[topicDataDic valueForKey:@"Owner"] valueForKey:@"profile"];
                } else {
                    topic.creatorImageURL = [[NSString alloc] initWithFormat:@"%@%@", HOST_4, [[topicDataDic valueForKey:@"Owner"] valueForKey:@"profile"]];
                }

                if ([type isEqualToString:@"surrealism"]) {
                    [topicArray2 addObject:topic];
                    PostCellView *cell2 = [self buildCategoryCellWith:topic :i];
                    [categoryContent2 addSubview:cell2];
                    
//                    //设定默认值
//                    float exploreBackView_h = 352 + 315*(ceilf(topicArray2.count/2)+0.1);//20150610
//                    exploreBackView.contentSize = CGSizeMake(viewWidth, exploreBackView_h);
                   // [indicator setFrame:CGRectMake(0, categoryBar.bounds.size.height-1, categoryBar.bounds.size.width/2, 1)];
                    
                } else if ([type isEqualToString:@"anti-realism"]) {
                    [topicArray3 addObject:topic];
                    PostCellView *cell3 = [self buildCategoryCellWith:topic :i];
                    [indicator setFrame:CGRectMake(categoryBar.bounds.size.width/2, categoryBar.bounds.size.height-1, categoryBar.bounds.size.width/2, 1)];//20150610
                    [categoryContent3 addSubview:cell3];
                }
            }
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"首页" message:@"服务器不给力，请稍后再试。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
    [sessionDataTask resume];
}

//修改过
- (PostCellView *)buildCategoryCellWith:(Topic *)topic :(NSInteger)index {
    float cellWidth = (viewWidth-3)/2;
    float cellHeight = cellWidth*1.5+28;  //315;28=头像高度+间隙//首页的间距改变 0527
    float x = index%2==0?0:viewWidth-cellWidth;
    float y = floorf(index/2)*cellHeight;
    PostCellView *postCell = [[PostCellView alloc] initWithFrame:CGRectMake(x, y, cellWidth, cellHeight) Topic:topic];
    postCell.delegate = self;
    
    return postCell;
}

#pragma Get Data From Server
- (void)getRecommendData {
    NSString *getRecommendService = @"/services/entity/type/recommend";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST_4,getRecommendService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            int cnt = (int)[[dataDic valueForKey:@"data"] count];
            if (cnt < 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推荐话题" message:@"服务器不给力，请稍后再试。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                return;
            }
            Topic *topic = [Topic new];
            topic.UUID = [[[dataDic valueForKey:@"data"] valueForKey:@"id"] objectAtIndex:0];
            topic.title = [[[dataDic valueForKey:@"data"] valueForKey:@"title"] objectAtIndex:0];
            topic.content = [[[dataDic valueForKey:@"data"] valueForKey:@"content"] objectAtIndex:0];
            topic.likeNum = (int)[[[dataDic valueForKey:@"data"] valueForKey:@"likeCount"] objectAtIndex:0];
            topic.limitNum = (int)[[[dataDic valueForKey:@"data"] valueForKey:@"postLimit"] objectAtIndex:0];
            topic.topicImageURL = [[NSString alloc] initWithFormat:@"%@%@", HOST_4,[[[dataDic valueForKey:@"data"] valueForKey:@"thumbnail"] objectAtIndex:0]];
            if ([[[[[dataDic valueForKey:@"data"] valueForKey:@"Owner"] objectAtIndex:0] valueForKey:@"profile"] hasPrefix:@"http://"]) {
                topic.creatorImageURL = [[[[dataDic valueForKey:@"data"] valueForKey:@"Owner"] objectAtIndex:0] valueForKey:@"profile"];
            } else {
                topic.creatorImageURL = [[NSString alloc] initWithFormat:@"%@%@", HOST_4, [[[[dataDic valueForKey:@"data"] valueForKey:@"Owner"] objectAtIndex:0] valueForKey:@"profile"]];
            }
            //Set RecommendedView
            recommendedTopic = topic;

            //方法更改过，增加了占位图并且防止汉语的命名增加了转码格式
            [recommendImageView sd_setImageWithURL:[NSURL URLWithString:[topic.topicImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"离开现实表面"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                recommendedTopic.topicImage = recommendImageView.image;

            }];
        } else {
            //TODO
        }
    }];
    
    [sessionDataTask resume];
}

//个人主页的布局
- (void)getMineArray {
   mineArray = [_database getAllTopicsByUser:_user]; //add user restriction
    float mineContent_h = (viewHeight-2)*1.5*(floorf(mineArray.count/2)+1);//310=(viewHeight-2)*1.5
    if (mineScrollView) {
        [mineScrollView removeFromSuperview];
        mineScrollView = nil;
    }
    if (mineNumLabel) {
        [mineNumLabel removeFromSuperview];
        mineNumLabel = nil;
    }

    mineHead.textColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    mineNumLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%d",(int)mineArray.count] :[ColorHandler colorWithHexString:@"#00d8a5"] :[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
    [mineNumLabel setFrame:CGRectMake((viewWidth/2-mineNumLabel.bounds.size.width)/2, 0, mineNumLabel.bounds.size.width, mineNumLabel.bounds.size.height)];
    [mineCtl addSubview:mineNumLabel];
    mineScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 196+44, viewWidth, viewHeight-196-44-20)];
    mineScrollView.contentSize = CGSizeMake(viewWidth, mineContent_h+100);
    mineScrollView.delegate = self;
    [self buildPersonalCotentWith:mineArray :1];
    [personalView addSubview:mineScrollView];
}

- (void)getMarkArray {
    markArray = [_database getAllCollectedTopicsByUser:_user]; //add user restriction
    if (markScrollView) {
        [markScrollView removeFromSuperview];
        markScrollView = nil;
    }
    if (markNumLabel) {
        [markNumLabel removeFromSuperview];
        markNumLabel = nil;
    }
    
    markHead.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    markNumLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%d",(int)markArray.count] :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
    [markNumLabel setFrame:CGRectMake((viewWidth/2-markNumLabel.bounds.size.width)/2, 0, markNumLabel.bounds.size.width, markNumLabel.bounds.size.height)];
    [markCtl addSubview:markNumLabel];
    
    float markContent_h = 315*(floorf(markArray.count/2)+1);
    markScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(viewWidth, 196+44, viewWidth, viewHeight-196-44-20)];
    markScrollView.contentSize = CGSizeMake(viewWidth, markContent_h+100);
    markScrollView.delegate = self;
    [self buildPersonalCotentWith:markArray :2];
    [personalView addSubview:markScrollView];
}

- (void)refreshData {
    [self getData];
    if (categoryContent1) {
        [categoryContent1 removeFromSuperview];
        categoryContent1 = nil;
    }
    if (categoryContent2) {
        [categoryContent2 removeFromSuperview];
        categoryContent2 = nil;
    }
    if (categoryContent3) {
        [categoryContent3 removeFromSuperview];
        categoryContent3 = nil;
    }
    [self buildCategoryContent];
    exploreBackView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [loadingTextView setFrame:CGRectMake((viewWidth-loadingTextView.bounds.size.width)/2, -28, loadingTextView.bounds.size.width, loadingTextView.bounds.size.height)];
    [loadingIconView setFrame:CGRectMake(loadingTextView.frame.origin.x-5-loadingIconView.bounds.size.width, -28, loadingIconView.bounds.size.width, loadingIconView.bounds.size.height)];
    
    [self showTabBar];
}

- (UILabel *)buildLabel:(NSString *)text :(UIColor *)textColor :(UIFont *)font {
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    [label setFrame:CGRectMake(0, 0, ceilf(size.width), ceilf(size.height))];
    
    return label;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   CGPoint offset = scrollView.contentOffset;
    float deltaOffset_y = (currentOffset.y?currentOffset.y:0) - offset.y;
    if (deltaOffset_y < 0) {
        if (isShow && !isDecelerate) {
            [self dismissTabBar];
        }
    } else {
        if (!isShow && !isDecelerate) {
            [self showTabBar];
        }
    }
    currentOffset = offset;
    
    
    if (offset.y > 0) {
        //fade in&out the navigationBar
        float alpha = (248 - offset.y)/248;
        if (alpha >= 0) {
            navigationBar.alpha = alpha;
        } else {
            navigationBar.alpha = 0.0f;
        }
        
        // move the categoryBar up&down
        if (offset.y > categoryBarOriginalRect.origin.y) {
            [categoryBar setFrame:CGRectMake(0, offset.y, viewWidth, 40)];
            [exploreBackView bringSubviewToFront:categoryBar];
        } else {
            [categoryBar setFrame:categoryBarOriginalRect];
            [exploreBackView bringSubviewToFront:categoryBar];
        }
    }
    
    
    if (offset.y <= -40) {
        
        [loadingTextView setFrame:CGRectMake((viewWidth-loadingTextView.bounds.size.width)/2, -28, loadingTextView.bounds.size.width, loadingTextView.bounds.size.height)];

        [loadingIconView setFrame:CGRectMake(loadingTextView.frame.origin.x-5-loadingIconView.bounds.size.width, -28, loadingIconView.bounds.size.width, loadingIconView.bounds.size.height)];
        [exploreBackView addSubview:loadingTextView];
        [exploreBackView addSubview:loadingIconView];
    } else {
        if (loadingTextView.superview) {
            [loadingTextView removeFromSuperview];
        }
        if (loadingIconView.superview) {
            [loadingIconView removeFromSuperview];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -40) {
        [UIView animateWithDuration:0.2f animations:^{
                exploreBackView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
        }completion:^(BOOL finished) {
            [self refreshData];
        }];
    }
    isDecelerate = decelerate;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    isDecelerate = NO;
}

#pragma mark PostCellDelegate
- (void)didChooseTopic:(Topic *)topic {
    TopicViewController *topViewController = [TopicViewController new];
    topViewController.user = _user;
    topViewController.database = _database;
    topViewController.topic = topic;
    [self.navigationController pushViewController:topViewController animated:YES];
}

#pragma mark NavigationBarDelegate
- (void)rightBtnClicked {
    if (currentTab == EXPLORE_PAGE) {
        //message View
        //添加
        MailViewController *mailVC = [[MailViewController alloc]init];
        
        
        [self.navigationController pushViewController:mailVC animated:YES];
        
    } else if (currentTab == PERSONAL_PAGE) {
        //Setting
        UserSettingViewController *settingViewController = [UserSettingViewController new];
        settingViewController.user = _user;
        settingViewController.database = _database;
        settingViewController.delegate = self;
        [self.navigationController pushViewController:settingViewController animated:YES];
    }
}


#pragma mark UserSettingViewControllerDelegate
- (void)didFinishAccountSettingwith:(UserInfo *)user {
    _user = user;
    userImageView.image = [UIImage imageWithData:_user.photo];
    nicknameLabel.text = _user.name;
    descLabel.text = _user.desc;
}


- (void)shareTopic {
    //push the shareViewController
    ShareViewController *share = [ShareViewController new];
//    share.delegate = self;
//    share.topic = _topic;
    share.user = _user;
    share.database = _database;
    [self.navigationController pushViewController:share animated:YES];
}


#pragma mark alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            case 1:
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        default:
            break;
    }
}

@end
