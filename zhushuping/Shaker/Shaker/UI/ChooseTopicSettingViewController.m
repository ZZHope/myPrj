//
//  ChooseTopicSettingViewController.m
//  Shaker
//
//  Created by Leading Chen on 15/4/7.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "ChooseTopicSettingViewController.h"
#import "ColorHandler.h"
#import "Contants.h"
#import "UIImage+Blur.h"

@interface ChooseTopicSettingViewController ()

@end

@implementation ChooseTopicSettingViewController {
    NavigationBar *navigationBar;
    UIView *bottomView;
    UIImageView *contentView;
    UIImageView *settingImage1;
    UIImageView *settingImage2;
    UIImageView *settingImage3;
    UILabel *settingLabel1;
    UILabel *settingLabel2;
    UILabel *settingLabel3;
    NSInteger currentSettingIndex;
    NSInteger limitNum;
    UITapGestureRecognizer *tapGesture;
    UIView *peopleView;
    UIView *maskView;
    UITextField *peopleField;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildNavigationBar];
}

- (void)buildNavigationBar {
    self.navigationController.navigationBarHidden = YES;
    navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
    [navigationBar setLeftBtn:[UIImage imageNamed:@"cancelIcon"]];
    [navigationBar setRightBtn:[UIImage imageNamed:@"detemineIcon"]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"设置参与人数"];
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
    self.view.backgroundColor = [UIColor lightGrayColor];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    currentSettingIndex = 2;
    limitNum = 0;
    [self buildView];
}

- (void)buildView {
    contentView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-285)/2, 7+64, 285, 440)];
    if (_contentImage) {
        contentView.image = _contentImage;
    } else {
        contentView.image = [UIImage imageNamed:@"layout1_285440"];
    }
    [self.view addSubview:contentView];
    [self buildBottomiew];
}

- (void)buildBottomiew {
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-150, viewWidth, 150)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label1 = [self buildLabel:@"设置参与人数" :[UIColor lightGrayColor] :[UIFont systemFontOfSize:15]];
    [label1 setFrame:CGRectMake(8, 14, label1.bounds.size.width, label1.bounds.size.height)];
    [bottomView addSubview:label1];
    
    UIImage *topic_setting_check_u = [UIImage imageNamed:@"topic_setting_check_u"];
    UIImage *topic_setting_check_h = [UIImage imageNamed:@"topic_setting_check_h"];
    UIImage *topic_setting_people_u = [UIImage imageNamed:@"topic_setting_people_u"];
    UIImage *topic_setting_people_h = [UIImage imageNamed:@"topic_setting_people_h"];
    
    
    float kSetMargin = 10.0;
    float kSetBtnWith = (viewWidth-4*kSetMargin)*0.33;
    
    UIControl *ctl1 = [[UIControl alloc] initWithFrame:CGRectMake(kSetMargin, 70, kSetBtnWith, 40)];//126
    ctl1.tag = 1;
    [ctl1 addTarget:self action:@selector(chooseSetting:) forControlEvents:UIControlEventTouchUpInside];
    settingImage1 = [[UIImageView alloc] initWithImage:topic_setting_check_u highlightedImage:topic_setting_check_h];
    [settingImage1 setFrame:CGRectMake(0, 10, 20, 20)];
    [ctl1 addSubview:settingImage1];
    
    
    
    settingLabel1 = [self buildLabel:@"仅自己参与" :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:14]];
    [settingLabel1 setFrame:CGRectMake(29, 14, settingLabel1.bounds.size.width, settingLabel1.bounds.size.height)];//(29, 14, settingLabel1.bounds.size.width, settingLabel1.bounds.size.height)
    [ctl1 addSubview:settingLabel1];
    
    UIControl *ctl2 = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ctl1.frame)+kSetMargin, 70,kSetBtnWith, 40)];
    ctl2.tag = 2;
    [ctl2 addTarget:self action:@selector(chooseSetting:) forControlEvents:UIControlEventTouchUpInside];
    settingImage2 = [[UIImageView alloc] initWithImage:topic_setting_check_u highlightedImage:topic_setting_check_h];
    [settingImage2 setFrame:CGRectMake(0, 10, 20, 20)];
    [settingImage2 setHighlighted:YES];
    [ctl2 addSubview:settingImage2];
    settingLabel2 = [self buildLabel:@"不限人数" :[UIColor blackColor] :[UIFont systemFontOfSize:14]];
    [settingLabel2 setFrame:CGRectMake(29, 14, settingLabel2.bounds.size.width, settingLabel2.bounds.size.height)];
    [ctl2 addSubview:settingLabel2];
    
    UIControl *ctl3 = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ctl2.frame)+kSetMargin, 70, kSetBtnWith, 40)];
    ctl3.tag = 3;
    [ctl3 addTarget:self action:@selector(chooseSetting:) forControlEvents:UIControlEventTouchUpInside];
    settingImage3 = [[UIImageView alloc] initWithImage:topic_setting_people_u highlightedImage:topic_setting_people_h];
    [settingImage3 setFrame:CGRectMake(0, 10, 20, 20)];
    [ctl3 addSubview:settingImage3];
    settingLabel3 = [self buildLabel:@"设定人数" :[ColorHandler colorWithHexString:@"#a7a7a7"] :[UIFont systemFontOfSize:14]];
    [settingLabel3 setFrame:CGRectMake(29, 14, settingLabel3.bounds.size.width, settingLabel3.bounds.size.height)];
    [ctl3 addSubview:settingLabel3];
    
    [bottomView addSubview:ctl1];
    [bottomView addSubview:ctl2];
    [bottomView addSubview:ctl3];
}

- (void)chooseSetting:(UIControl *)ctl {
    if (ctl.tag == 1) {
        currentSettingIndex = 1;
        [settingImage1 setHighlighted:YES];
        [settingImage2 setHighlighted:NO];
        [settingImage3 setHighlighted:NO];
        settingLabel1.textColor = [UIColor blackColor];
        settingLabel2.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
        settingLabel3.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    } else if (ctl.tag == 2) {
        currentSettingIndex = 2;
        [settingImage1 setHighlighted:NO];
        [settingImage2 setHighlighted:YES];
        [settingImage3 setHighlighted:NO];
        settingLabel1.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
        settingLabel2.textColor = [UIColor blackColor];
        settingLabel3.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
    } else if (ctl.tag == 3) {
        currentSettingIndex = 3;
        [settingImage1 setHighlighted:NO];
        [settingImage2 setHighlighted:NO];
        [settingImage3 setHighlighted:YES];
        settingLabel1.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
        settingLabel2.textColor = [ColorHandler colorWithHexString:@"#a7a7a7"];
        settingLabel3.textColor = [UIColor blackColor];
        [self buildPeopleView];
    }
}

- (void)buildPeopleView {
    maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.layer.contents = (id)[self getBlurImageWithCGRect:self.view.frame].CGImage;
    [self.view addSubview:maskView];
    
    peopleView = [[UIView alloc] initWithFrame:CGRectMake((viewWidth-312)/2, 130, 312, 169)];
    peopleView.backgroundColor = [UIColor whiteColor];
    peopleField = [[UITextField alloc] initWithFrame:CGRectMake(88, 50, 80, 14)];
    peopleField.delegate = self;
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:@"输入人数"];
    [placeHolder addAttribute:NSForegroundColorAttributeName value:[ColorHandler colorWithHexString:@"#a7a7a7"] range:NSMakeRange(0, placeHolder.length)];
    [placeHolder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, placeHolder.length)];
    peopleField.attributedPlaceholder = placeHolder;
    peopleField.textColor = [ColorHandler colorWithHexString:@"#414141"];
    peopleField.font = [UIFont systemFontOfSize:14];
    peopleField.keyboardType = UIKeyboardTypeDecimalPad;
    [peopleView addSubview:peopleField];
    
    UILabel *peopleLabel = [self buildLabel:@"人参与话题" :[ColorHandler colorWithHexString:@"#414141"] :[UIFont systemFontOfSize:14]];
    [peopleLabel setFrame:CGRectMake(160, 50, peopleLabel.bounds.size.width, peopleLabel.bounds.size.height)];
    [peopleView addSubview:peopleLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(7, 114, 144, 40)];
    cancelBtn.layer.borderColor = [ColorHandler colorWithHexString:@"#a7a7a7"].CGColor;
    cancelBtn.layer.borderWidth = 0.6f;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[ColorHandler colorWithHexString:@"#a7a7a7"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSetPeople) forControlEvents:UIControlEventTouchUpInside];
    [peopleView addSubview:cancelBtn];
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 114, 144, 40)];
    confirmBtn.backgroundColor = [ColorHandler colorWithHexString:@"#00d8a5"];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmSetPeople) forControlEvents:UIControlEventTouchUpInside];
    [peopleView addSubview:confirmBtn];
    [self.view addSubview:peopleView];
    [self textFieldDidBeginEditing:peopleField];
}

- (void)cancelSetPeople {
    [peopleView removeFromSuperview];
    [maskView removeFromSuperview];
}

- (void)confirmSetPeople {
    if ([peopleField.text integerValue] > 99) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置人数" message:@"限制人数最大为99人" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        settingLabel3.text = [[NSString alloc] initWithFormat:@"99人参与"];
    } else {
        settingLabel3.text = [[NSString alloc] initWithFormat:@"%@人参与",peopleField.text];
    }
    [peopleView removeFromSuperview];
    [maskView removeFromSuperview];
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

- (void)resignKeyBoard {
    [peopleField resignFirstResponder];
    [maskView removeGestureRecognizer:tapGesture];
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
    if (currentSettingIndex == 1) {
        limitNum = 0;
    } else if (currentSettingIndex == 2) {
        limitNum = 99;
    } else if (currentSettingIndex == 3) {
        limitNum = [peopleField.text integerValue];
    }
    [self.delegate didChooseSetting:limitNum];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [maskView addGestureRecognizer:tapGesture];
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self resignKeyBoard];
}


#pragma mark -- 点击屏幕返回

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
