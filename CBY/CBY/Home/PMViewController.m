//
//  PMViewController.m
//  51CBY
//
//  Created by SJB on 15/4/17.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "PMViewController.h"

#define kWidth  self.view.bounds.size.width
#define kHeight self.view.bounds.size.height

@interface PMViewController ()

@property(nonatomic, strong)UIScrollView *scrollView;

@end

@implementation PMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*navigation*/
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    textlabel.text = self.title;
    self.navigationItem.titleView = textlabel;
    
    //scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.scrollView.contentSize = CGSizeMake(kWidth, kHeight*3.5);
    
    //显示介绍
    //pm显示简介
     NSString *strPM = @"PM2.5介绍\r\t随着全国各地空气出现严重污染，pm2.5屡屡爆表，我国多个城市发生雾霾天气。越来越多的人开始关注一个原本陌生的术语——pm2.5。那么，到底pm2.5是什么意思?\r\tpm为英文particulate matter的缩写，翻译成中文叫做颗粒物。pm2.5是指大气中直径小于或等于2.5微米的颗粒物，有时也被称作入肺颗粒物。我们日常常见的雾霾天气大 多数情况下就是由pm2.5造成的。\r\t虽然pm2.5在大气中的含量极少，但是，由于质量小，携带病毒及有害物质时间长、传输渠道多样、移动距离较远、对人 体造成的危害较大，pm2.5的确是名符其实的隐型杀手!有数据显示，由于不明白pm2.5是什么意思，对pm2.5的危害不够重视，2010年北京、上海两地因PM2.5污染致死的人数分别为2349人和2980人，远远高于当地交通意外死亡人数。\r\t一份来自美国nasa的图标显示，我国pm2.5的含量甚至一度超过撒哈拉沙漠，成为名符其实的厚德载雾国。\r\t----- 以上来自百度百科.参考网址：http://baike.baidu.com/view/4251816.htm";
    
//      CGSize sizePM = [strPM sizeWithAttributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:(12.0+(kHeight-kWidth)*0.01)]}];
    // NSStringDrawingTruncatesLastVisibleLine = 1 << 5, // Truncates and adds the ellipsis character to the last visible line if the text doesn't fit into the bounds specified. Ignored if NSStringDrawingUsesLineFragmentOrigin is not also set.
//    NSStringDrawingUsesLineFragmentOrigin = 1 << 0, // The specified origin is the line fragment origin, not the base line origin
//    NSStringDrawingUsesFontLeading = 1 << 1, // Uses the font leading for calculating line heights
//    NSStringDrawingUsesDeviceMetrics = 1 << 3,
    CGRect sizePM = [strPM boundingRectWithSize:CGSizeMake(kWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:(12.0+(kHeight-kWidth)*0.01)]} context:nil];
    
    UILabel *PmLabel = [self labelWithFrame:CGRectMake(20, 5, kWidth-40, sizePM.size.height+40) Text:strPM andAttrColor:[UIColor orangeColor] local:0 length:8];
    [self.scrollView addSubview:PmLabel];
    
    //甲醛介绍
    
    NSString *strJiaquan =@"甲醛清理介绍\r甲醛如何产生以及降低车内甲醛含量的措施和改善方法:\r车内空气中的甲醛是来自:\r1．用作车内装饰的胶合板、细木工板、中密度纤维板和刨花板等人造板材，由于目前生产装饰板使用的胶粘剂以脲醛树脂为主，板材中残留的和未参与反应的甲醛会逐渐向周围环境释放，是形成车内空气中甲醛的主体。\r2．用人造板制造的家具，一些厂家为了追求高额利润，使用不合适的板材，在粘接贴面材料时再使用劣质胶水，结果顾客买回家去，等于买回了一个小型废气排放站。3．含有甲醛成分并有可能向外界散发的其他各类装饰材料，比如贴墙布、贴墙纸、化纤地毯、泡沫塑料、油漆和涂料等。\r4．燃烧后会散发甲醛的某些材料，比如香烟及一些有机材料。\r\r车内空气中甲醛浓度的大小与以下几个因素有关：\r1．车室内温度\r2．车内相对湿度\r3．车内材料的装载度（即每立方米车内空间的甲醛散发材料表面积）\r4．车内换气数（即车内空气流通量）。在高温、高湿、负压和高负载条件下会加剧散发的力度。实测数据说明.\r在一定条件下，汽车小环境内空气中甲醛浓度可聚集到标准允许水平以上，而且释放期比较长，日本横滨国立大学的研究表明，甲醛的释放期为3-15年。\r5．尽量采用低甲醛含量和不含甲醛的车内装饰品，这是降低车内空气中甲醛含量的根本。\r6．即使在选购生活家具时，应选择刺激性气味较小的产品，因为刺激性气味越大，说明甲醛释放量越高。同时，要注意查看家具用的刨花板是否全部封边。有条件的家庭，可将新买的家具空置一段时间再用。\r7．保持车内空气流通。这是清除车内甲醛行之有效的办法，可选用有效的空气换气装置，或者在车外空气好的时候打开窗户通风，有利于车内材料的甲醛散发和排出。\r8．合理控制调节车内温度和相对湿度，甲醛这种物质是一种缓慢挥发性物质，随着温度的升高，挥发得会更快一些。\r9．车内甲醛含量比较高的，可请车内环境检测专家进行检测，可以了解车内空气中甲醛的超标程度，以便采取相应的治理措施。车内环境检测中心有一些降低车内甲醛的措施和治理方法，可以根据车内空气污染程度加以选择。\r\r世界各国室内空气甲醛含量国际环保标准：\r《室内装饰装修材料人造板其制品中甲醛释放限量》国家质量监督检验检疫总局在2001年2月10日发布了《室内装饰装修材料人造板及其制品中甲醛释放限量》的国家标准,将于2002年7月1日开始执行.\r其中第五章室内装饰装修材料人造板及其制品中甲醛释放限量值5mg/L为强制性条款,规定在2002年7月1日起市场上停止销售不符合国家标准的产品.\r德国／DIN68763生产规定,一般甲醛释放量应为：E1小于10mg/100g、E2小于10-30mg/10g、E3小于30-60mg/100g；\r日本／规定F1级小于0.5mg/L、F2级0.5-5mg/L、F3级5-10mg/L(毫克/升)；\r我国／GB／T14732-93国标规定了游离甲醛释放量小于40mg/100g；\r中华人民共和国国家标准《居室空气中甲醛的卫生标准》规定：居室空气中甲醛的最高容许浓度为0.08毫克／立方米.\r----- 以上信息来自中华人民共和国国家质量监督检验检疫总局";
    
    CGRect sizeJQ = [strJiaquan boundingRectWithSize:CGSizeMake(kWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:(12.0+(kHeight-kWidth)*0.01)]} context:nil];
    
    
    UILabel *JQLabel = [self labelWithFrame:CGRectMake(20, CGRectGetMaxY(PmLabel.frame)+10, kWidth-40, sizeJQ.size.height+120) Text:strJiaquan andAttrColor:[UIColor orangeColor] local:0 length:6];
    [self.scrollView addSubview:JQLabel];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.scrollView];
    
}

-(UILabel *)labelWithFrame:(CGRect)frame Text:(NSString *)text andAttrColor:(UIColor *)color local:(int)local length:(int)lengh
{
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:frame];
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.font = [UIFont boldSystemFontOfSize:(12.0+(kHeight-kWidth)*0.01)];
    introduceLabel.textAlignment = NSTextAlignmentLeft;
    introduceLabel.numberOfLines = 0;
    introduceLabel.text = text;
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(0.5, 1);
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc]initWithString:introduceLabel.text];
    [strAttr addAttributes:@{NSShadowAttributeName:shadow} range:NSMakeRange(0, introduceLabel.text.length)];
    
    [strAttr addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(local, lengh)];//不同的颜色
    introduceLabel.attributedText = strAttr;
    [self.scrollView addSubview:introduceLabel];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.scrollView];
    return introduceLabel;
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
