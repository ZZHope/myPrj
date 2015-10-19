//
//  SettingViewController.m
//  51CBY
//
//  Created by SJB on 15/1/7.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "SettingViewController.h"
#import "InfoTableViewCell.h"
#import "SJBManager.h"
#import "CbyUserSingleton.h"
#import "LoginViewController.h"
#import "OurInfoController.h"
#import "AFNetworking.h"
#import "AFNCommon.h"

#define kWidth   self.view.bounds.size.width

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *secretArr;
@property(nonatomic,strong) NSMutableArray *detailInfoArr;
@property(nonatomic, copy) NSString *currentVersion;

@property(nonatomic,strong) CbyUserSingleton *settingInfo;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.view.bounds.size.height-100) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // 数据

    self.secretArr = [NSArray array];
    self.secretArr = @[@"当前版本",@"关于我们"];
    self.detailInfoArr = [NSMutableArray array];
    
    
    //当前版本号
    NSString *key = (NSString *)kCFBundleVersionKey;
   // 加载程序中info.plist文件(获得当前软件的版本号)
    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[key];
    self.currentVersion = currentVersionCode;
    
//单例
    _settingInfo = [CbyUserSingleton shareUserSingleton];
    
    
//返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

#pragma mark -- tableView delegate / datasource



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return self.secretArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cellID";
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.secretArr[indexPath.row];
    if (indexPath.row == 0) {

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        label.text = [NSString stringWithFormat:@"v%.1f" ,[self.currentVersion floatValue]];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textColor = [UIColor lightGrayColor];
        cell.accessoryView = label;
    }
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth , 60)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,10,kWidth , 40)];
         btn.enabled = YES;
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn ];
    if (!self.settingInfo.isLogin) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        btn.enabled = NO;
    }
      
        return bgView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

        return 100.0f;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        OurInfoController *ourVC = [[OurInfoController alloc]init];
        ourVC.title = @"关于我们";
        ourVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ourVC animated:YES];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- textField


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark- target - action
-(void)logout:(UIButton *)sender
{
    self.settingInfo.isLogin = NO;
    self.settingInfo.userID = @"0";
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"successLogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"successLogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [SJBManager prsentSJBControllerWithType:SJBControllerTypeMainView];
   
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
