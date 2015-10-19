//
//  AboutUSViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/5/13.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "AboutUSViewController.h"
#import "Contants.h"
#import "ColorHandler.h"

@interface AboutUSViewController ()<UIAlertViewDelegate>

@end

@implementation AboutUSViewController {
    NavigationBar *navigationBar;
    UIScrollView *contentView;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    if (navigationBar) {
        [navigationBar removeFromSuperview];
        navigationBar = nil;
    }
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    
    [navigationBar setLeftBtnWithString:@"返回" color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont systemFontOfSize:15]];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"关于稀客"];
    [title addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#2a2a2a"] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, title.length)];
    [navigationBar setTitleTextView:title];
    
    navigationBar.alpha = 1.0f;
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    [self buildView];
}

- (void)buildView {
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, viewWidth, viewHeight-64)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.showsVerticalScrollIndicator = NO;
    contentView.contentSize = CGSizeMake(viewWidth, (viewHeight-64)*1.2);
    [self.view addSubview:contentView];
    
    UIImage *aboutUS_logo = [UIImage imageNamed:@"aboutUS_logo"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-aboutUS_logo.size.width)/2, 52, aboutUS_logo.size.width, aboutUS_logo.size.height)];
    logoImageView.image = aboutUS_logo;
    [contentView addSubview:logoImageView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame)+15, viewWidth, 14)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *logoText= [[NSMutableAttributedString alloc] initWithString:@"稀客"];
    [logoText addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#00d8a5"] range:NSMakeRange(0, 2)];
    [logoText addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#414141"] range:NSMakeRange(2, logoText.length-2)];
    label1.attributedText = logoText;
    [contentView addSubview:label1];
    
    UILabel *label2 = [self buildLabel:@"「离开现实表面」内容互动社区" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:12]];
    [label2 setFrame:CGRectMake((viewWidth-label2.bounds.size.width)/2, CGRectGetMaxY(label1.frame)+13, label2.bounds.size.width, label2.bounds.size.height)];
    [contentView addSubview:label2];
//    UILabel *label3 = [self buildLabel:@"超现实送你一支迷幻剂，释放所有与现实无关的想象" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:10]];
//    [label3 setFrame:CGRectMake((viewWidth-label3.bounds.size.width)/2, 268, label3.bounds.size.width, label3.bounds.size.height)];
//    [contentView addSubview:label3];
    UILabel *label4 = [self buildLabel:@"版本号v2.0" :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:10]];
    [label4 setFrame:CGRectMake(label2.frame.origin.x+label2.bounds.size.width-label4.bounds.size.width, CGRectGetMaxY(label2.frame)+20, label4.bounds.size.width, label4.bounds.size.height)];
    [contentView addSubview:label4];
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(17, 315, viewWidth-17, 0.5f)];
    line1.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line1];
    UILabel *websiteHead = [self buildLabel:@"稀客官网" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:12]];
    [websiteHead setFrame:CGRectMake(17, (57-websiteHead.bounds.size.height)/2+315, websiteHead.bounds.size.width, websiteHead.bounds.size.height)];
    
    UIButton *xikeBtn = [self creatBtnWithtag:1001 frame:CGRectMake(CGRectGetMaxX(websiteHead.frame), CGRectGetMaxX(line1.frame), viewWidth-websiteHead.bounds.size.width,50)];
    
    [contentView addSubview:xikeBtn];

    [contentView addSubview:websiteHead];
    
    
    
    UIImage *arrowImage = [UIImage imageNamed:@"right_arrow"];
    UIImageView *arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-arrowImage.size.width, (56-arrowImage.size.height)/2+315, arrowImage.size.width, arrowImage.size.height)];
    arrow1.image = arrowImage;
    [contentView addSubview:arrow1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(17, 372, viewWidth-17, 0.5f)];
    line2.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line2];
    UILabel *wechatHead = [self buildLabel:@"关注微信" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:12]];
    [wechatHead setFrame:CGRectMake(17, (57-wechatHead.bounds.size.height)/2+372, wechatHead.bounds.size.width, wechatHead.bounds.size.height)];
    
    UIButton *wechatBtn = [self creatBtnWithtag:1002 frame:CGRectMake(CGRectGetMaxX(wechatHead.frame), CGRectGetMaxY(line2.frame), viewWidth-wechatHead.bounds.size.width,50)];
    [contentView addSubview:wechatBtn];
    [contentView addSubview:wechatHead];
    UIImageView *arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-arrowImage.size.width, (56-arrowImage.size.height)/2+372, arrowImage.size.width, arrowImage.size.height)];
    arrow2.image = arrowImage;
    [contentView addSubview:arrow2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(17, 429, viewWidth-17, 0.5f)];
    line3.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line3];
    UILabel *weiboHead = [self buildLabel:@"关注微博" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:12]];
    [weiboHead setFrame:CGRectMake(17, (57-weiboHead.bounds.size.height)/2+429, weiboHead.bounds.size.width, weiboHead.bounds.size.height)];
    [contentView addSubview:weiboHead];
    
    UIButton *weiboBtn = [self creatBtnWithtag:1003 frame:CGRectMake(CGRectGetMaxX(weiboHead.frame), CGRectGetMaxY(line3.frame), viewWidth-weiboHead.bounds.size.width, 50)];
    [contentView addSubview:weiboBtn];
    
    UIImageView *arrow3= [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-arrowImage.size.width, (56-arrowImage.size.height)/2+429, arrowImage.size.width, arrowImage.size.height)];
    arrow3.image = arrowImage;
    [contentView addSubview:arrow3];
    
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(17, 483, viewWidth-17, 0.5f)];
    line4.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line4];
    
    
    UILabel *telHead = [self buildLabel:@"联系电话" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:12]];
    [telHead setFrame:CGRectMake(17, (57-telHead.bounds.size.height)/2+483, telHead.bounds.size.width, telHead.bounds.size.height)];
    [contentView addSubview:telHead];
    UIButton *telBtn = [self creatBtnWithtag:1004 frame:CGRectMake(CGRectGetMaxX(weiboHead.frame), CGRectGetMaxY(line4.frame), viewWidth-weiboHead.bounds.size.width+10, 50)];
    [telBtn setTitle:@"021-61127786" forState:UIControlStateNormal];
    telBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    telBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [telBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [contentView addSubview:telBtn];
    
    UIImageView *arrow4= [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17-arrowImage.size.width, (56-arrowImage.size.height)/2+483, arrowImage.size.width, arrowImage.size.height)];
    arrow4.image = arrowImage;
    [contentView addSubview:arrow4];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(17, 537, viewWidth-17, 0.5f)];
    line5.backgroundColor = [ColorHandler colorWithHexString:@"#e7e7e7"];
    [contentView addSubview:line5];

    
    
    
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

#pragma custombutton

-(UIButton *)creatBtnWithtag:(NSInteger)tag frame:(CGRect)frame
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    btn.tag = tag;
    [btn addTarget:self action:@selector(tapToEnable:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


-(void)tapToEnable:(UIButton*)sender
{
    switch (sender.tag) {
        case 1001:
            
        {
            NSURL *url = [NSURL URLWithString:@"http://www.shaker.mobi/"];
            [[UIApplication sharedApplication]openURL:url];
        }
            
            break;
        case 1002:
            [self pasteToBoardWithString:@"稀客shaker"];
            
            break;
        case 1003:
            [self pasteToBoardWithString:@"shaker520"];
            
        case 1004:
            
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"联系我们" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 2001;
            [alert show];
        }

            
            break;


        default:
            break;
    }
}

-(void)pasteToBoardWithString:(NSString *)string
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setString:string];
    pasteBoard.persistent = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"关于稀客" message:@"稀客账号已经复制到粘贴板，请登录后关注" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark -- alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            if (alertView.tag==2001) {//tel
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://021-61127786"]];

            }
        }
            break;

            
        default:
            break;
    }
}

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
