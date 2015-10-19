//
//  ChooseTopicLayoutViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/7.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "ChooseTopicLayoutViewController.h"
#import "ColorHandler.h"
#import "Contants.h"



@interface ChooseTopicLayoutViewController ()

@end

@implementation ChooseTopicLayoutViewController {
    NavigationBar *navigationBar;
    UIView *bottomView;
    UIImageView *contentView;
    UIScrollView *layoutScrollView;
    NSMutableArray *layoutArray;
    NSMutableArray *layoutContentArray;
    UIControl *currentCtl;
    UITapGestureRecognizer *tap1;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtn:[UIImage imageNamed:@"cancelIcon"]];
    [navigationBar setRightBtn:[UIImage imageNamed:@"detemineIcon"]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"设置版式"];
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
    self.view.backgroundColor = [UIColor grayColor];
    tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChooseLayout)];
    
    [self generateLayoutArray];
    
    [self buildView];
}

//版式宽高比例设置
- (void)buildView {
    
    float margin = (viewHeight-44-(viewWidth-80)*1.54)*0.5;
    
   // contentView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-285)/2.0, 7+64, 285, 285*1.54)];//jheight=440
     contentView = [[UIImageView alloc] initWithFrame:CGRectMake(50, margin, viewWidth-100, (viewWidth-100)*1.54)];//jheight=440,y=7+64
    if (_contentImage) {
        contentView.image = _contentImage;   //resizableImageWithCapInsets:UIEdgeInsetsMake(430, 142, 9, 142) resizingMode:UIImageResizingModeStretch];
    } else {
        contentView.image = [UIImage imageNamed:@"layout1_285440"];// resizableImageWithCapInsets:UIEdgeInsetsMake(430, 142, 9, 142) resizingMode:UIImageResizingModeStretch];
    }
    [contentView addGestureRecognizer:tap1];
    [contentView setUserInteractionEnabled:YES];
    [self.view addSubview:contentView];
    [self buildBottomView];
}

- (void)generateLayoutArray {
    if (layoutArray) {
        [layoutArray removeAllObjects];
        layoutArray = nil;
    }
    if (layoutContentArray) {
        [layoutContentArray removeAllObjects];
        layoutContentArray = nil;
    }
    layoutArray = [NSMutableArray new];
    layoutContentArray = [NSMutableArray new];
    
    UIImage *layoutImage1 = [UIImage imageNamed:@"layout1_79122"];
    UIImage *layoutImage2 = [UIImage imageNamed:@"layout2_79122"];
    UIImage *layoutImage3 = [UIImage imageNamed:@"layout3_79122"];
    UIImage *layoutImage4 = [UIImage imageNamed:@"layout4_79122"];
    UIImage *layoutImage5 = [UIImage imageNamed:@"layout5_79122"];
    
    UIImage *layoutContentImage1 = [UIImage imageNamed:@"layout1_285440"];
    UIImage *layoutContentImage2 = [UIImage imageNamed:@"layout2_285440"];
    UIImage *layoutContentImage3 = [UIImage imageNamed:@"layout3_285440"];
    UIImage *layoutContentImage4 = [UIImage imageNamed:@"layout4_285440"];
    UIImage *layoutContentImage5 = [UIImage imageNamed:@"layout5_285440"];
    
    
    
    [layoutArray addObject:layoutImage1];
    [layoutArray addObject:layoutImage3];
    [layoutArray addObject:layoutImage2];
    [layoutArray addObject:layoutImage4];
    [layoutArray addObject:layoutImage5];

    [layoutContentArray addObject:layoutContentImage1];
    [layoutContentArray addObject:layoutContentImage3];
    [layoutContentArray addObject:layoutContentImage2];
    [layoutContentArray addObject:layoutContentImage4];
    [layoutContentArray addObject:layoutContentImage5];
}

- (void)buildBottomView {
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-150, viewWidth, 150)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label1 = [self buildLabel:@"设置版式" :[UIColor lightGrayColor] :[UIFont systemFontOfSize:15]];
    [label1 setFrame:CGRectMake(8, 4, label1.bounds.size.width, label1.bounds.size.height)];
    [bottomView addSubview:label1];
    
    float ctlWidth = 79;
    float ctlHeight = 122;
    layoutScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 25, viewWidth-20, 125)];
    layoutScrollView.contentSize = CGSizeMake((ctlWidth+13)*layoutArray.count, 0);
    [bottomView addSubview:layoutScrollView];
    
    for (int i=0; i<layoutArray.count; i++) {
        UIControl *layoutCtl = [[UIControl alloc] initWithFrame:CGRectMake(i*(ctlWidth+13), 0, ctlWidth, ctlHeight)];
        layoutCtl.layer.borderColor = [UIColor blackColor].CGColor;
        layoutCtl.layer.borderWidth = 0.7f;
        layoutCtl.tag = i;
        [layoutCtl addTarget:self action:@selector(chooseLayout:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *layoutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 79, 122)];
        layoutImageView.image = (UIImage *)[layoutArray objectAtIndex:i];
        [layoutCtl addSubview:layoutImageView];
        [layoutScrollView addSubview:layoutCtl];
    }
}

- (void)chooseLayout:(UIControl *)ctl {
    if (currentCtl) {
        currentCtl.layer.borderColor = [UIColor blackColor].CGColor;
    }
    ctl.layer.borderColor = [ColorHandler colorWithHexString:@"#00d8a5"].CGColor;
    currentCtl = ctl;
    contentView.image = [layoutContentArray objectAtIndex:ctl.tag];
}

- (void)didChooseLayout {
    [self.delegate didChooseLayout:currentCtl.tag];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark NavigationBarDelegate
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked {
    [self.delegate didChooseLayout:currentCtl.tag];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
