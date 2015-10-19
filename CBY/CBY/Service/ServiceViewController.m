//
//  ServiceViewController.m
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "ServiceViewController.h"

#define Width self.view.bounds.size.width
#define Height self.view.bounds.size.height

#define scrollHeight  (self.scrollView.contentSize.height-580.0)

@interface ServiceViewController ()

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)UIScrollView *scrollView;
@end

@implementation ServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        /*navigation*/
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textlabel.text = @"服务";
        textlabel.font = [UIFont boldSystemFontOfSize:20];
        textlabel.textAlignment = NSTextAlignmentCenter;
        textlabel.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = textlabel;
        
        /*tabBar*/
        UIImage *serviceSelect = [UIImage imageNamed:@"流程2"];
        [serviceSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *grayService= [UIImage imageNamed:@"流程"];
        grayService = [grayService imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:nil image:grayService selectedImage:[serviceSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.tabBarItem = homeItem;
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];

        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    /*navigation*/
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(Width, Height*4.15);
    self.scrollView.pagingEnabled = NO;
    
    [self ServiceProcess];
    [self TheReservationService];
    [self TheCustomerToConfirm];
    [self OnSiteService];
    [self MaintenanceServices];
    [self TheEntireVehicleDetection];
    [self AcceptanceOfPayment];
    [self ScanCodeEvaluation];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    [self.view addSubview:self.scrollView];
    
}

#pragma mark - 扫码评价
-(void)ScanCodeEvaluation
{
    UIImageView *tempImageView = (UIImageView *)[self.scrollView viewWithTag:7];
   
    UILabel *image = [self labelWithFrame:CGRectMake(5, CGRectGetMaxY(tempImageView.frame)+10, 50, 50) title:@"5\r扫码评价" radius:25.0];
    image.font = [UIFont systemFontOfSize:12.0f];
    [self.scrollView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, CGRectGetMaxY(tempImageView.frame)+10, Width-80, 50)];
    label.text = @"在订单上扫描微信二维码并对技师的服务进行评价，订单完成。";
    label.font = [UIFont fontWithName:@"Arial" size:15];
    label.numberOfLines = 2;
    [self.scrollView addSubview:label];
    
    UIImageView *image1 = [self imageWithFrame:CGRectMake(5, CGRectGetMaxY(image.frame)+10, Width-10, scrollHeight*0.135) image:@"2-13.jpg"];
    [self.scrollView addSubview:image1];
    
}

#pragma mark - 验收付款
-(void)AcceptanceOfPayment
{
    UIImageView *tempImageView = (UIImageView *)[self.scrollView viewWithTag:6];
    UILabel *image = [self labelWithFrame:CGRectMake(5, CGRectGetMaxY(tempImageView.frame)+10, 50, 50) title:@"4\r验收付款" radius:25.0f];
     image.font = [UIFont systemFontOfSize:12.0f];
    [self.scrollView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, CGRectGetMaxY(tempImageView.frame)+10, self.view.frame.size.width-80, 50)];
    label.text = @"验收并付款。(已线上支付的情况，只需签字验收。)";
    label.font = [UIFont fontWithName:@"Arial" size:15];
    label.numberOfLines = 2;
    [self.scrollView addSubview:label];
    
    UIImageView *image1 = [self imageWithFrame:CGRectMake(5, CGRectGetMaxY(image.frame)+10, Width-10, scrollHeight*0.085) image:@"2-12.jpg"];
    image1.tag = 7;
    [self.scrollView addSubview:image1];
}

#pragma mark - 全车检测
-(void)TheEntireVehicleDetection
{
    UIImageView *tempImageView = (UIImageView *)[self.scrollView viewWithTag:5];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(tempImageView.frame)+10, 60, 50)];
    label.text = @"全车检测";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 2;
    [self.scrollView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, CGRectGetMaxY(tempImageView.frame)+10, self.view.frame.size.width-70-70, 50)];
    label1.text = @"保养完毕之后，对您的爱车进行九大类57项检查。";
    label1.font = [UIFont fontWithName:@"Arial" size:15];
    label1.numberOfLines = 2;
    [self.scrollView addSubview:label1];
    
    UIImageView *image1 = [self imageWithFrame:CGRectMake(5, CGRectGetMaxY(label1.frame)+10, Width-10, scrollHeight*0.155) image:@"2-11.jpg"];
    image1.tag = 6;
    [self.scrollView addSubview:image1];
}

#pragma mark - 保养服务
-(void)MaintenanceServices
{
    UIImageView *tempImageView = (UIImageView *)[self.scrollView viewWithTag:4];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(tempImageView.frame)+10, 60, 50)];
    label.text = @"保养服务";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 2;
    [self.scrollView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, CGRectGetMaxY(tempImageView.frame)+10, Width-70-70, 50)];
    label1.text = @"技师布置场地后，根据您所订购的服务，依次保养。";
    label1.font = [UIFont fontWithName:@"Arial" size:15];
    label1.numberOfLines = 2;
    [self.scrollView addSubview:label1];
    
    UIImageView *image1 = [self imageWithFrame:CGRectMake(5, CGRectGetMaxY(label1.frame)+10, Width-10, scrollHeight*0.125) image:@"2-10.jpg"];
    image1.tag = 5;
    [self.scrollView addSubview:image1];

}

#pragma mark - 3.现场服务
-(void)OnSiteService
{
    UIImageView *tempImageView = (UIImageView *)[self.scrollView viewWithTag:3];
    UILabel *image = [self labelWithFrame:CGRectMake(5, CGRectGetMaxY(tempImageView.frame)+10, 50, 50) title:@"3\r现场服务" radius:25.0f];
     image.font = [UIFont systemFontOfSize:12.0f];
    [self.scrollView addSubview:image];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, CGRectGetMaxY(tempImageView.frame)+10, 60, 50)];
    label.text = @"货品确认";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 2;
    [self.scrollView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, CGRectGetMaxY(tempImageView.frame)+10, Width-70-70, 50)];
    label1.text = @"到达约定地点，确认货物包装完好并当面拆验。";
    label1.font = [UIFont fontWithName:@"Arial" size:15];
    label1.numberOfLines = 2;
    [self.scrollView addSubview:label1];
    
    UIImageView *image1 = [self imageWithFrame:CGRectMake(5, CGRectGetMaxY(image.frame)+10, Width-10, scrollHeight*0.125) image:@"2-9.jpg"];
    image1.tag = 4;
    [self.scrollView addSubview:image1];
}

#pragma mark - 2.客户确认
-(void)TheCustomerToConfirm
{
    UIImageView *tempImageView = (UIImageView *)[self.scrollView viewWithTag:2];
    UILabel *image = [self labelWithFrame:CGRectMake(5, CGRectGetMaxY(tempImageView.frame)+10, 50, 50) title:@"2\r客服确认" radius:25.0f];
     image.font = [UIFont systemFontOfSize:12.0f];
    [self.scrollView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, CGRectGetMaxY(tempImageView.frame)+10, Width-80, 50)];
    label.text = @"订单成功后，服务日期前一天客服会电话提醒您服务时间。";
    label.font = [UIFont fontWithName:@"Arial" size:15];
    label.numberOfLines = 2;
    [self.scrollView addSubview:label];
    
    UIImageView *image1 = [self imageWithFrame:CGRectMake(5, CGRectGetMaxY(image.frame)+10, Width-10, scrollHeight*0.115) image:@"2-8.jpg"];
    image1.tag = 3;
    [self.scrollView addSubview:image1];
}

#pragma mark - 1.预约服务
-(void)TheReservationService
{
    UIImageView *tempImageView = (UIImageView *)[self.scrollView viewWithTag:1];
    UILabel *image = [self labelWithFrame:CGRectMake(5, CGRectGetMaxY(tempImageView.frame)+10, 50, 50) title:@"1\r预约服务" radius:25.0f];
     image.font = [UIFont systemFontOfSize:12.0f];
    [self.scrollView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, CGRectGetMaxY(tempImageView.frame)+10, Width-80, 50)];
    label.text = @"登录我要车保养51cby.cn，预定上门保养，提交订单";
    label.font = [UIFont fontWithName:@"Arial" size:15];
    label.numberOfLines = 2;
    [self.scrollView addSubview:label];
    
    UIImageView *image1 = [self imageWithFrame:CGRectMake(5, CGRectGetMaxY(image.frame)+10, Width-10, scrollHeight*0.105) image:@"2-7.jpg"];
    image1.tag = 2;
    [self.scrollView addSubview:image1];
}

#pragma mark - 服务流程
-(void)ServiceProcess
{
    
    UILabel *image1 = [self labelWithFrame:CGRectMake((Width-80)*0.5, 20, 80, 80) title:@"2\r客服确认" radius:40.0f];
    [self.scrollView addSubview:image1];

    UILabel *image = [self labelWithFrame:CGRectMake(Width/2-130, 20, 80, 80) title:@"1\r预约服务" radius:40.0f];
    [self.scrollView addSubview:image];
    
    UILabel *image2 = [self labelWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+10, 20, 80, 80) title:@"3\r现场服务" radius:40.0];
    [self.scrollView addSubview:image2];
    
    UILabel *image3 = [self labelWithFrame:CGRectMake(Width/2-85, CGRectGetMaxY(image2.frame)+20, 80, 80) title:@"4\r验收服务" radius:40.0f];
    [self.scrollView addSubview:image3];
    
    UILabel *image4 = [self labelWithFrame:CGRectMake(CGRectGetMaxX(image3.frame)+10, CGRectGetMaxY(image2.frame)+20, 80, 80) title:@"5\r扫描评价" radius:40.0f];
    image4.tag = 1;
    [self.scrollView addSubview:image4];
}


#pragma mark - 封装的imageView方法

#pragma mark - 封装的imageView方法
-(UIImageView *)imageWithFrame:(CGRect)frame image:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
//    UIImage *image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(125, 153, 125, 153) resizingMode:UIImageResizingModeStretch];
    [imageView setImage:[UIImage imageNamed:imageName]];
    return imageView;
}


-(UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title radius:(CGFloat)radius
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [UIColor colorWithRed:247/255.0 green:131/255.0 blue:7/255.0 alpha:1.0];
    label.text = title;
    label.layer.cornerRadius = radius;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 2;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
