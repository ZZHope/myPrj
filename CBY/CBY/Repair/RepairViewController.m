//
//  RepairViewController.m
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "RepairViewController.h"

#import "CarModelsView.h"
#import "SchemeViewController.h"
#import "CheckViewController.h"
#import "YearViewController.h"
#import "CarBareViewController.h"

#import "DBCommon.h"
#import "CbyDataBaseManager.h"
#import "AFNCommon.h"
#import "CbyUserSingleton.h"

#import "CustomButton.h"

#import "LoginViewController.h"

#define Width self.view.frame.size.width
#define Height self.view.frame.size.height

//UITextField的文本
#define Text @"选择我的车型"

//-------------------------------------------------------------------------------------------------
@interface RepairViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) UIButton *startBtn;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) NSArray *array;

@property (copy, nonatomic)NSString *carId;

#pragma mark - 创建功能按钮

@property (strong, nonatomic) UIButton *smallBtn;               //小保养

@property (strong, nonatomic) UIButton *phoneCallBtn;     //空调滤清器

@property (strong, nonatomic) UIButton *privateCustom;          //私人定制
@property (strong, nonatomic) CbyUserSingleton *pairInfo;
@end

static NSString *carString;

@implementation RepairViewController

BOOL showBig = 1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textlabel.text = @"保养";
        textlabel.font = [UIFont boldSystemFontOfSize:20];
        textlabel.textAlignment = NSTextAlignmentCenter;
        textlabel.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = textlabel;
        
        UIImage *baoyangSel = [UIImage imageNamed:@"保养2"];
        [baoyangSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *grayBaoyang = [UIImage imageNamed:@"保养"];
        grayBaoyang = [grayBaoyang imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:nil image:grayBaoyang selectedImage:[baoyangSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.tabBarItem = homeItem;
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    /*navigation*/
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.translucent = NO;
    UIImage *image = [UIImage imageNamed:@"背景"];
    self.view.layer.contents = (id) image.CGImage;
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    _dic = [NSDictionary dictionary];
    
    //user
    
    _pairInfo = [CbyUserSingleton shareUserSingleton];
    
#pragma mark - 建立选择车型TextField
    _textField = [[UITextField alloc]initWithFrame:CGRectMake((Width-250)*0.5, 10, 250, 40)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = Text;
    self.textField.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.textField.textColor = [UIColor blackColor];
    UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
    imgv.frame = CGRectMake(100, 50, 20, 30);
    self.textField.rightView=imgv;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    
    [self.view addSubview:self.textField];
    [self theFunctionButton];
}

#pragma mark - 服务项目控件
-(void)theFunctionButton
{
    UIImage *luoPan = [UIImage imageNamed:@"罗盘"];
   
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2,CGRectGetMaxY(self.textField.frame)+(Height-Width-50)*0.1,(Width-4), (Width-4))];//(Height-49-60-(Width-4))
    self.imageView.image = luoPan;
    self.imageView.layer.cornerRadius = (Width-4)*0.5;
    self.imageView.clipsToBounds = YES;
    self.imageView.userInteractionEnabled=YES;

    
        _privateCustom = [self btnWithFrame:CGRectMake(((Width-4)-53)*0.5, ((Width-4)*0.5-110)*0.5, 60, 110) image:@"私人定制" tag:1008 title:@"免费车检"];
        [self.imageView addSubview:self.privateCustom];
        
      
        
        _smallBtn = [self btnWithFrame: CGRectMake(((Width-4)*0.5-60)*0.5+(Width-4)*0.5,(Width-4)*0.5, 80, 100) image:@"常规保养root" tag:1002 title:@"常规保养"];
        [self.imageView addSubview:self.smallBtn];
        
       
        
        _phoneCallBtn = [self btnWithFrame:CGRectMake(((Width-4)*0.5-100)*0.5,(Width-4)*0.5-10, 80, 120) image:@"电话预约" tag:1007 title:@"电话预约"];
        [self.imageView addSubview:self.phoneCallBtn];
        
    
        
        _startBtn = [self btnWithFrame:CGRectMake(((Width-4)-110)*0.5, ((Width-4)*0.5-77*0.5), 110, 77) image:nil tag:1009 title:nil];
        [self.startBtn setBackgroundImage:[UIImage imageNamed:@"汽车"] forState:UIControlStateNormal];
        [self.imageView addSubview:self.startBtn];
    

    [self.view addSubview:self.imageView];
    
}

#pragma mark － 保养项目跳转功能
-(void)tiaoZhuan:(UIButton *)sender
{
  
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"保养";
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    SchemeViewController* sc = [[SchemeViewController alloc]init];
    sc.hidesBottomBarWhenPushed = YES;
    self.pairInfo.carID= self.carbackID;
    sc.carString = self.textField.text;
    CarModelsView *cmv = [[CarModelsView alloc]init];
        
    
        switch (sender.tag) {
                
                //小保养
            case 1002:
            {

                if (self.carbackID != nil) {
                    
                    NSDictionary *dic = [NSDictionary dictionary];
                    dic = @{@"interfaceName":@"getservicegoods",
                            @"serviceid":@"SID_JY,SID_JL",
                            @"car_id":self.carbackID};
                    sc.strUrl = kShareUrl;
                    sc.parameter = dic;
                    
                    [self.navigationController pushViewController:sc animated:YES];

                }else {
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"interfaceName":@"getservicegoods",
                                                    @"serviceid":@"SID_JY,SID_JL"}];
                    cmv.dic = dic;
                    [self.navigationController pushViewController:cmv animated:YES];
                }
                
            }
                break;
                
  
            //其它
            case 1007:
            {
                
                //打电话
                UIAlertView *alertPhone = [[UIAlertView alloc]initWithTitle:nil message:@"致电我要车保养，为爱车保养" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertPhone.tag = 5000;
                [alertPhone show];

                
            }
                break;
                //免费车检
            case 1008:
            {
                
                CheckViewController *checkVC = [[CheckViewController alloc]init];
                [self.navigationController pushViewController:checkVC animated:YES];
                
                
            }
                
           
                
                break;
    
    case 1009:
        {
        
        if (showBig == 1) {
            showBig = 0;
            
            [UIView animateWithDuration:0.1 animations:^{

               
                self.startBtn.frame = CGRectMake(((Width-4)-160)*0.5, (Width-120)*0.5,160 ,120);
               
                
         
                self.smallBtn.frame = CGRectMake(162, 162, 0, 0);
              
                self.phoneCallBtn.frame = CGRectMake(162, 162, 0, 0);
              
                self.privateCustom.frame = CGRectMake(162, 162, 0, 0);
                
            }];

        }else {
            showBig = 1;
            
                [UIView animateWithDuration:0.1 animations:^{
                    
                self.privateCustom.frame = CGRectMake(((Width-4)-53)*0.5, ((Width-4)*0.5-110)*0.5, 60, 110);
                   
                    
                _smallBtn.frame = CGRectMake(((Width-4)*0.5-60)*0.5+(Width-4)*0.5,(Width-4)*0.5, 80, 100);
                    
                    
                   
                _phoneCallBtn.frame = CGRectMake(((Width-4)*0.5-100)*0.5,(Width-4)*0.5, 80, 100);
                    
                    
                _startBtn.frame = CGRectMake(((Width-4)-120)*0.5, ((Width-4)*0.5-27), 120, 87);

                }];
                
        }
        
        }
                
            default:
                
                break;
        }
    }



#pragma mark  － 选择车型的第一响应者
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"选择车型" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"选择新车型",@"去车型库", nil];
    [alertView show];
    
    return NO;
}

#pragma mark － UIButton封装
-(UIButton *)btnWithFrame:(CGRect)frame image:(NSString*)imageName tag:(int) tag title:(NSString *)title
{
    CustomButton* btn = [[CustomButton alloc]initWithFrame:frame];
    
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitle:@"" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(tiaoZhuan:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    
    return btn;
}


#pragma mark -- 选择车型来源
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5000) {//打电话提示软件
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
            {
                //打电话
                UIWebView*telWebview;
                if (telWebview == nil) {
                    telWebview = [[UIWebView alloc] init];
                }
                
                NSURL *telURL =[NSURL URLWithString:@"tel:4008218100"];
                [telWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                
                [[UIApplication sharedApplication]openURL:telURL];
                //记得添加到view上
                [self.view addSubview:telWebview];

            }
                break;
                
            default:
                break;
        }
        
    }else{
        
        switch (buttonIndex) {
            case 2:
            {
                
               

                //跳转到车型选择的页面
                if ([CbyUserSingleton shareUserSingleton].isLogin) {
                    
                    
                    CarBareViewController *carBareVC = [[CarBareViewController alloc]init];
                    carBareVC.needReturnInfo = 1;
                    [carBareVC returnCareBareInfo:^(NSDictionary *carBareInfo) {
                        
                        self.textField.text = [carBareInfo objectForKey:@"text"];
                        self.carbackID = [carBareInfo objectForKey:@"carId"];
                    }];
                    
                    [self.navigationController pushViewController:carBareVC animated:YES];

                }else{
                    LoginViewController *logVC = [[LoginViewController alloc]init];
                    [self presentViewController:logVC animated:YES completion:^{
                        CarBareViewController *carBareVC = [[CarBareViewController alloc]init];
                        carBareVC.needReturnInfo = 1;
                        [carBareVC returnCareBareInfo:^(NSDictionary *carBareInfo) {
                            
                            self.textField.text = [carBareInfo objectForKey:@"text"];
                            self.carbackID = [carBareInfo objectForKey:@"carId"];
                        }];
                        
                        [self.navigationController pushViewController:carBareVC animated:YES];
                        
                    }];
                }
                
            }
                break;
            case 1:
            {
                CarModelsView* cmv = [[CarModelsView alloc]init];
                [self.navigationController pushViewController:cmv animated:YES];
            }
                break;
                
            case 0:
                break;
            default:
                break;
        }

    }
}

@end
