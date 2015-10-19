//
//  TopicCatalogViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/15.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "TopicCatalogViewController.h"
#import "Contants.h"
#import "ColorHandler.h"
#import "CreateNewPostViewController.h"
#import "PostViewController.h"
#import "WebContentViewController.h"

@interface TopicCatalogViewController ()

@end

@implementation TopicCatalogViewController {
    NavigationBar *navigationBar;
    UIScrollView *postListScrollView;
    NSMutableArray *posts;
    UIView *bottomBar;
    UIWebView *catalogWebView;

}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtn:[UIImage imageNamed:@"returnIcon"]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:_topic.title];
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
    // Do any additional setup after loading the view.
//    [self getPost];
    
//    [self buildView];
    [self buildCatalogView];
}

- (void)buildCatalogView {
    catalogWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, viewWidth, viewHeight)];
    catalogWebView.scrollView.bounces = NO;
    catalogWebView.scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
    NSString *catalogURLString = [[NSString alloc] initWithFormat:@"%@/entity/%@/catalog",HOST_4,_topic.UUID];
    [catalogWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:catalogURLString]]];
    [self.view addSubview:catalogWebView];
}

- (void)getPost {
    posts = [NSMutableArray new];
    //TODO
    Post *p1 = [Post new];
    Card *c1 = [Card new];
    c1.cardImage = [UIImage imageNamed:@"IMG_0058.jpg"];
    [p1.cards addObject:c1];
    [p1.cards addObject:c1];
    p1.creatorName = @"leading";
    [posts addObject:p1];
    
}

- (void)buildView {
    UILabel *label1 = [self buildLabel:@"话题参与人列表" :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:10]];
    [label1 setFrame:CGRectMake(12, 74, label1.bounds.size.width, label1.bounds.size.height)];
    [self.view addSubview:label1];
    UILabel *label2 = [self buildLabel:[[NSString alloc] initWithFormat:@"共%d人参与",(int)posts.count] :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:10]];
    [label2 setFrame:CGRectMake(viewWidth-12-label2.bounds.size.width, 74, label2.bounds.size.width, label2.bounds.size.height)];
    [self.view addSubview:label2];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 28+64, 350, 0.5)];
    line.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [self.view addSubview:line];
    
    [self buildPostListScrollView];
    [self buildBottomBar];
}

- (void)buildPostListScrollView {
    float cellHeight = 98;
    postListScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 28.5+64, viewWidth, viewHeight-44-28.5-64)];
    postListScrollView.contentSize = CGSizeMake(viewWidth, cellHeight*posts.count);
    [self.view addSubview:postListScrollView];
    
    UIImage *likeIcon = [UIImage imageNamed:@"likeIcon_gray"];
    for (int i=0; i<posts.count; i++) {
        Post *post = [posts objectAtIndex:i];
        Card *firstCard = [post.cards objectAtIndex:0];
        UIControl *cell = [[UIControl alloc] initWithFrame:CGRectMake(0, cellHeight*i, viewWidth, cellHeight)];
        cell.tag = i;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 11, 87, 87)];
        imageView.layer.borderColor = [ColorHandler colorWithHexString:@"#e7e7e7"].CGColor;
        imageView.layer.borderWidth = 0.5f;
        imageView.layer.cornerRadius = 2;
        imageView.image = firstCard.cardImage;
        [cell addSubview:imageView];
        
        UILabel *contentLabel = [self buildLabel:[self getShortContentWithCard:firstCard] :[ColorHandler colorWithHexString:@"#2a2a2a"] :[UIFont systemFontOfSize:14]];
        [contentLabel setFrame:CGRectMake(113, 19, contentLabel.bounds.size.width, contentLabel.bounds.size.height)];
        [cell addSubview:contentLabel];
        
        UILabel *nameLabel = [self buildLabel:post.creatorName :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:11]];
        [nameLabel setFrame:CGRectMake(113, 78, nameLabel.bounds.size.width, nameLabel.bounds.size.height)];
        [cell addSubview:nameLabel];
        
        UIImageView *likeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(322, 74, likeIcon.size.width, likeIcon.size.height)];
        likeIconView.image = likeIcon;
        [cell addSubview:likeIconView];
        UILabel *likeNumLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%d",(int)post.likeNum] :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:9]];
        [likeNumLabel setFrame:CGRectMake(345, 78, likeNumLabel.bounds.size.width, likeNumLabel.bounds.size.height)];
        [cell addSubview:likeNumLabel];
        
        [cell addTarget:self action:@selector(didChoosePost:) forControlEvents:UIControlEventTouchUpInside];
        [postListScrollView addSubview:cell];
    }
    
}

- (void)buildBottomBar {
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

- (void)chooseParticipate {
    CreateNewPostViewController *postCreator = [CreateNewPostViewController new];
    postCreator.topic = _topic;
    postCreator.user = _user;
    postCreator.database = _database;
    [self.navigationController pushViewController:postCreator animated:YES];
}

- (void)didChoosePost:(UIControl *)ctl {
    PostViewController *postViewController = [PostViewController new];
    postViewController.post = [posts objectAtIndex:ctl.tag];
    postViewController.user = _user;
    postViewController.database = _database;
    [self.navigationController pushViewController:postViewController animated:YES];
}

- (NSString *)getShortContentWithCard:(Card *)card {
    return card.content.length>10?[[NSString alloc] initWithFormat:@"%@%@",[card.content substringToIndex:10],@"..."]:[[NSString alloc] initWithFormat:@"%@%@",card.content,@"..."];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}


@end
