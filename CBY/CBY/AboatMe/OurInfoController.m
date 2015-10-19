//
//  OurInfoController.m
//  51CBY
//
//  Created by SJB on 15/4/8.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "OurInfoController.h"



#define kWidth  self.view.bounds.size.width
#define kHeight  self.view.bounds.size.height

@interface OurInfoController ()

@end

@implementation OurInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*navigation*/
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = self.title;
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
    
    //页面背景图片设置
    
    UIImage *img = [[UIImage imageNamed:@"our"]resizableImageWithCapInsets:UIEdgeInsetsMake(400, 239, 267, 239) resizingMode:UIImageResizingModeStretch];
    self.view.layer.contents = (id)img.CGImage;
    
    //imgview
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((kWidth-200)*0.5, 10, 200, 100)];
    imgView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:imgView];
    
    
    //label显示简介
    
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imgView.frame)+5, kWidth-40, kHeight-49-44-imgView.bounds.size.height)];
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.font = [UIFont boldSystemFontOfSize:(11.0+(kHeight-kWidth)*0.01)];
    introduceLabel.textAlignment = NSTextAlignmentLeft;
    introduceLabel.numberOfLines = 0;
    introduceLabel.text = @"\t2014年，【我要车保养】正式进入汽车后服务市场，秉承用户出行安全为己任，以服务透明、价格透明为宗旨，为广大车主会员提供上门保养汽车服务。汽车的维修保养市场，长期处于4S店垄断、街边小铺为辅的局面。【我要车保养】提供给车主会员们多一种选择，使车主明白消费，了解自己的车，了解保养。\r\t车主会员通过微信、网站等便捷方式轻松下单以后，【我要车保养】将会派出专业技术人员，按照约定时间和地点为用户车辆提供优质、贴心的上门保养服务。【我要车保养】通过安全透明的服务、诚实透明的价格、带给车主会员满意舒心的养车体验，从而开创了全新的汽车售后服务模式。\r\r\t公司电话：400-8218100\r\t公司地址：上海市浦东新区茂兴路90号仁恒广场3楼";
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(0.5, 1);
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc]initWithString:introduceLabel.text];
    [strAttr addAttributes:@{NSShadowAttributeName:shadow} range:NSMakeRange(0, introduceLabel.text.length)];
    introduceLabel.attributedText = strAttr;
    [self.view addSubview:introduceLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
