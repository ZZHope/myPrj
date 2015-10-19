//
//  AddedPostViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/15.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "AddedPostViewController.h"
#import "Contants.h"
#import "ColorHandler.h"

@interface AddedPostViewController ()

@end

@implementation AddedPostViewController {
    NavigationBar *navigationBar;
    UIView *bottomView;
    UIImageView *contentView;
    UIScrollView *cardScrollView;
//    NSMutableArray *layoutArray;
//    NSMutableArray *layoutContentArray;
    UIControl *currentCtl;
    NSInteger currentIndex;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtn:[UIImage imageNamed:@"cancelIcon"]];
    [navigationBar setRightBtn:[UIImage imageNamed:@"detemineIcon"]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"已添加页面"];
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
    currentIndex = 0;
    
    [self buildView];
}

- (void)buildView {
    contentView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-285)/2, 7+64, 285, 440)];
    if (_addedCardArray) {
        Card *card = [_addedCardArray objectAtIndex:0];
        contentView.image = card.cardImage;
    }
    [self.view addSubview:contentView];
    [self buildBottomView];
}


- (void)buildBottomView {
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-150, viewWidth, 150)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label1 = [self buildLabel:@"已添加" :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:15]];
    [label1 setFrame:CGRectMake(8, 4, label1.bounds.size.width, label1.bounds.size.height)];
    [bottomView addSubview:label1];
    
    [self buildCardScrollView];
}

- (void)removeCard:(UIControl *)ctl {
    [_addedCardArray removeObjectAtIndex:ctl.tag];
    [self buildCardScrollView];
}

- (void)buildCardScrollView {
    if (cardScrollView) {
        [cardScrollView removeFromSuperview];
        cardScrollView = nil;
    }
    float ctlWidth = 79;
    float ctlHeight = 122;
    cardScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 25, viewWidth-20, 125)];
    cardScrollView.contentSize = CGSizeMake((ctlWidth+13)*_addedCardArray.count, 0);
    [bottomView addSubview:cardScrollView];
    
    UIImage *deleteIcon = [UIImage imageNamed:@"deleteIcon"];
    for (int i=0; i<_addedCardArray.count; i++) {
        Card *card = [_addedCardArray objectAtIndex:i];
        UIControl *cardCtl = [[UIControl alloc] initWithFrame:CGRectMake(i*(ctlWidth+13), 0, ctlWidth, ctlHeight)];
        cardCtl.layer.borderColor = [UIColor blackColor].CGColor;
        cardCtl.layer.borderWidth = 0.7f;
        cardCtl.tag = i;
        [cardCtl addTarget:self action:@selector(choosecard:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 79, 122)];
        cardImageView.image = card.cardImage;
        [cardCtl addSubview:cardImageView];
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, deleteIcon.size.width, deleteIcon.size.height)];
        [deleteBtn setCenter:CGPointMake(cardCtl.frame.origin.x+cardCtl.bounds.size.width, cardCtl.frame.origin.y+10)];
        [deleteBtn setImage:deleteIcon forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(removeCard:) forControlEvents:UIControlEventTouchUpInside];
        [cardScrollView addSubview:cardCtl];
        [cardScrollView addSubview:deleteBtn];
    }
}

- (void)choosecard:(UIControl *)ctl {
    if (currentCtl) {
        currentCtl.layer.borderColor = [UIColor blackColor].CGColor;
    }
    ctl.layer.borderColor = [ColorHandler colorWithHexString:@"#00d8a5"].CGColor;
    currentCtl = ctl;
    currentIndex = ctl.tag;
    Card *card = [_addedCardArray objectAtIndex:ctl.tag];
    contentView.image = card.cardImage;
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

- (void)rightBtnClicked {
    [self.delegate didEditCardArray:_addedCardArray atIndex:(NSInteger)currentIndex];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
