//
//  AboutMeViewController.m
//  51CBY
//
//  Created by SJB on 14/12/19.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "AboutMeViewController.h"
#import "AddressViewController.h"
#import "CarBareViewController.h"
#import "SettingViewController.h"
#import "OrderViewController.h"
#import "ManageAddressController.h"
#import "ShoppingCarController.h"
#import "CbyUserSingleton.h"
#import "LoginViewController.h"


#define kOwnerFirstImageName @"imageName"
#define kFirstText       @"ownerText"

#define width self.view.bounds.size.width
#define height self.view.bounds.size.height

typedef NS_ENUM(NSInteger, BUTTONTYPE) {
    BUTTONTYPE_MARKET = 1001,
    BUTTONTYPE_MODEL,
    BUTTONTYPE_ORDER
};


@interface AboutMeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataInfoArr;
@property(nonatomic, strong) UIView *backView;
@property(nonatomic, strong) NSArray *controllerNameList;
@property(nonatomic, strong) CbyUserSingleton *userInfo;

@end

@implementation AboutMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        /*navigation*/
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textlabel.text = @"我的";
        textlabel.font = [UIFont boldSystemFontOfSize:20];
        textlabel.textAlignment = NSTextAlignmentCenter;
        textlabel.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = textlabel;
        

        /*tabbar*/
        
        UIImage *homeImg = [UIImage imageNamed:@"我的2"];
        [homeImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *grayHome = [UIImage imageNamed:@"我的"];
        grayHome = [grayHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:nil image:grayHome selectedImage:[homeImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.tabBarItem = homeItem;
        self.tabBarController.tabBar.tintColor = [UIColor yellowColor];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        
        
        /*准备数据*/
        _dataInfoArr = [NSArray array];
        self.dataInfoArr = @[@{kOwnerFirstImageName:@"shoppingBare",kFirstText :@"购物车"},@{kOwnerFirstImageName :@"myOrder",kFirstText :@"我的订单"},@{kOwnerFirstImageName:@"addressMange",kFirstText :@"收货信息管理"},@{kOwnerFirstImageName:@"carBare",kFirstText :@"我的车型库"}];
        _controllerNameList = [NSArray array];
        self.controllerNameList = @[@"ShoppingCarController",@"OrderViewController",@"ManageAddressController",@"CarBareViewController"];

        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //user
    _userInfo = [CbyUserSingleton shareUserSingleton];
    if (!self.userInfo.isLogin) {
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }

    /*tableView*/

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height-80) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];

    //self.view = self.tableView;
    
    //右视图
    UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [userBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [userBtn addTarget:self action:@selector(settingApp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:userBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    /*headerView*/
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 180)];
    self.backView.backgroundColor = [UIColor whiteColor];
    //topview
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -300, width, 390)];
    topView.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"ownerHeader"];
    //[image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    topView.image = image;
    [self.backView addSubview:topView];
    
    UIButton *midButton = [[UIButton alloc] initWithFrame:CGRectMake((width-80)*0.5, CGRectGetMaxY(topView.frame)-40, 80, 80)];
    [midButton setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
    [midButton setImage:[UIImage imageNamed:@"car2"] forState:UIControlStateNormal];
    midButton.layer.cornerRadius = 40;
    midButton.clipsToBounds = YES;
    [self.backView addSubview:midButton];
    
    UILabel *themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(midButton.frame)-10, CGRectGetMaxY(midButton.frame)+2, 100, 30)];
    themeLabel.font = [UIFont systemFontOfSize:15.0f];
    if (self.userInfo.isLogin) {
        themeLabel.text = self.userInfo.userName;
    }else{
        themeLabel.text = @"我是小宝";
    }
    
    //themeLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    themeLabel.textAlignment = NSTextAlignmentCenter;
    themeLabel.textColor = [UIColor blackColor];
    
    [self.backView addSubview:themeLabel];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    /*navigation*/
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}



#pragma mark -- tableView delegate/data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataInfoArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.dataInfoArr[indexPath.row] objectForKey:kFirstText];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    cell.imageView.image = [UIImage imageNamed:[self.dataInfoArr[indexPath.row] objectForKey:kOwnerFirstImageName]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (self.userInfo.isLogin) {
         /*懒加载的方法*/
         NSString *temp = self.controllerNameList[indexPath.row];
         UIViewController *VC = [[NSClassFromString(temp) alloc] init];
         //if (indexPath.row == 0) {
         VC.hidesBottomBarWhenPushed = YES;
         //}
         [self.navigationController pushViewController:VC animated:YES];

     }else{
        
         LoginViewController *loginVC = [[LoginViewController alloc] init];
         [self presentViewController:loginVC animated:YES completion:nil];
     }
}


//应用设置

-(void)settingApp:(UIBarButtonItem *)sender
{
    
    SettingViewController *settintVC = [[SettingViewController alloc]init];
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"应用设置";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    settintVC.navigationItem.titleView = textlabel;
    [self.navigationController pushViewController:settintVC animated:YES];
}
@end
