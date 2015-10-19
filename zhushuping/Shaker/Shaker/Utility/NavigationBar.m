//
//  NavigationBar.m
//  Shaker2
//
//  Created by Leading Chen on 15/3/30.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "NavigationBar.h"
#import "ColorHandler.h"

#define viewWidth CGRectGetWidth([UIScreen mainScreen].applicationFrame)


@implementation NavigationBar {
    UIControl *leftBtn;
    UIControl *rightBtn;
    UILabel *titleLabelView;
    UIImageView *titleImageView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5)];
    line.backgroundColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    [self addSubview:line];
}

- (void)setBackColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
}

- (void)setLeftBtnWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font {
    if (leftBtn) {
        [leftBtn removeFromSuperview];
        leftBtn = nil;
    }
    UILabel *btnLabel = [self buildLabel:string :color :font];
    float w = btnLabel.bounds.size.width;
    float h = btnLabel.bounds.size.height;
    
    leftBtn = [[UIControl alloc] initWithFrame:CGRectMake(6, 20, w+20, h+20)];
    leftBtn.tag = 1;
    [btnLabel setFrame:CGRectMake(10, 10, btnLabel.bounds.size.width, btnLabel.bounds.size.height)];
    [leftBtn addSubview:btnLabel];
    [leftBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
}

- (void)setRightBtnWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font {
    if (rightBtn) {
        [rightBtn removeFromSuperview];
        rightBtn = nil;
    }
    UILabel *btnLabel = [self buildLabel:string :color :font];
    float w = btnLabel.bounds.size.width;
    float h = btnLabel.bounds.size.height;
    
    rightBtn = [[UIControl alloc] initWithFrame:CGRectMake(viewWidth-w-16-10, 20, w+20, h+20)];
    rightBtn.tag = 2;
    [btnLabel setFrame:CGRectMake(10, 10, btnLabel.bounds.size.width, btnLabel.bounds.size.height)];
    [rightBtn addSubview:btnLabel];
    [rightBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
}

- (void)setLeftBtn:(UIImage *)image {
    if (leftBtn) {
        [leftBtn removeFromSuperview];
        leftBtn = nil;
    }
    float w = image.size.width;
    float h = image.size.height;
    leftBtn = [[UIControl alloc] initWithFrame:CGRectMake(6, 20, w+20, h+20)];
    leftBtn.tag = 1;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, w, h)];
    imageView.image = image;
    [imageView setUserInteractionEnabled:NO];
    [leftBtn addSubview:imageView];
    [leftBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
}

- (void)setRightBtn:(UIImage *)image {
    if (rightBtn) {
        [rightBtn removeFromSuperview];
        rightBtn = nil;
    }
    float w = image.size.width;
    float h = image.size.height;
    rightBtn = [[UIControl alloc] initWithFrame:CGRectMake(viewWidth-w-20-6, (44-h)/2+10, w+20, h+20)];
    rightBtn.tag = 2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, w, h)];
    imageView.image = image;
    [imageView setUserInteractionEnabled:NO];
    [rightBtn addSubview:imageView];
    [rightBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
}

- (void)setOtherButton:(CGRect)frame :(UIImage *)image :(NSString *)text {
    UIControl *otherButton = [[UIControl alloc] initWithFrame:frame];
    otherButton.tag = 3;
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height-20)];
        imageView.image = image;
        [otherButton addSubview:imageView];
    }
    if (text) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height-20)];
        label.text = text;
        [otherButton addSubview:label];
    }
    [otherButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:otherButton];
}

- (void)setTitleImageView:(UIImage *)image {
    if (titleImageView) {
        [titleImageView removeFromSuperview];
        titleImageView = nil;
    }
    float w = image.size.width;
    float h = image.size.height;
    titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    titleImageView.image = image;
    [titleImageView setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height+20)))];//leave 20px to status bar
    [self addSubview:titleImageView];
}

- (void)setTitleTextView:(NSAttributedString *)text {
    if (titleLabelView) {
        [titleLabelView removeFromSuperview];
        titleLabelView = nil;
    }
    titleLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height-20)];
    titleLabelView.textAlignment = NSTextAlignmentCenter;
    titleLabelView.attributedText = text;
    [self addSubview:titleLabelView];
}

- (void)enableRightBtn {
    rightBtn.enabled = YES;
}

- (void)disableRightBtn {
    rightBtn.enabled = NO;
}

- (void)buttonClicked:(UIControl *)sender {
    if (sender.tag == 1) {
        [self.delegate leftBtnClicked];
    } else if (sender.tag == 2) {
        [self.delegate rightBtnClicked];
    }
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

@end
