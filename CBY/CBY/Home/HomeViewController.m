//
//  HomeViewController.m
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "MYScrollView.h"
#import "CustomButton.h"
#import "CarModelsView.h"
#import "SJBManager.h"
#import "ValueControllerTableViewController.h"
#import "HomeServiceController.h"
#import "OilDiscountViewController.h"
#import "CommonSenseViewController.h"
#import "CheckViewController.h"
#import "RegViewController.h"
#import "AFNetworking.h"
#import "AFNCommon.h"
#import "UIImageView+WebCache.h"
#import "CbyDataBaseManager.h"
#import "DBCommon.h"
#import "CbyUserSingleton.h"
#import <QuartzCore/QuartzCore.h>
#import "RepairViewController.h"
#import "PMViewController.h"



#define kImageName  @"imageurl"
#define kLoopFlag  @"action"


#define kBrand @"brand"
#define kModel @"model"

#define Width self.view.bounds.size.width
#define Height self.view.bounds.size.height
#define windowHeight [[UIApplication sharedApplication].delegate window].bounds.size.height
#define kTempHeight  view.bounds.size.height
#define kRGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define kFont  12.0f

typedef NS_ENUM(NSInteger, BUTTONTYPE) {
    BUTTONTYPE_FREE = 2001,
    BUTTONTYPE_OILADD,
    BUTTONTYPE_TICKET,
    BUTTONTYPE_COMMONSENSE
};


@interface HomeViewController () <MYScrollViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate >
@property(nonatomic,strong) UIPageControl *pageControl;

@property(nonatomic,strong) NSArray *imgArr;
@property(nonatomic,strong) UIView *viewShow;
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) NSMutableArray *imgName;
@property(nonatomic,strong) UIImageView *discountImgView;
@property(nonatomic,assign) float rate;
//@property(nonatomic,strong) UILabel *scoreLabel;
@property(nonatomic, strong) NSArray *menuListArr;//跳转页面数组

@property(nonatomic, strong) UIImageView *serviceImgView;
@property(nonatomic, copy) NSString *oilBageNum;
//@property(nonatomic, copy) NSString *ticketBageNum;


//请求的数据存放
@property(nonatomic, strong) NSMutableArray *brandArr;
@property(nonatomic, strong) NSMutableArray *brandI;
@property(nonatomic, strong) NSMutableArray *modelArr;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *tempModel;//临时存放取出来的车型数据

//刷新控件
@property(nonatomic, strong) UIRefreshControl *refreshControl;



@property(nonatomic,strong) NSArray *carArr;

@property (nonatomic, strong) MYScrollView *myScrollView;

@property (nonatomic, strong) NSTimer *timer;


@property(nonatomic, strong) CbyUserSingleton *userInfo;


@end


int loopFlag = 0;

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        /*navigation*/
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textlabel.text = @"我要车保养";
        textlabel.font = [UIFont boldSystemFontOfSize:20];
        textlabel.textAlignment = NSTextAlignmentCenter;
        textlabel.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = textlabel;
        

        //右视图

        
        UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
        [userBtn setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
        [userBtn addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:userBtn];
        self.navigationItem.rightBarButtonItem = rightItem;


        
        
        /*tabbar*/

         UIImage *homeImg = [UIImage imageNamed:@"首页2"];
        [homeImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       
        UIImage *grayHome = [UIImage imageNamed:@"首页"] ;
        grayHome = [grayHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:nil image:grayHome selectedImage:[homeImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.tabBarItem = homeItem;
        self.tabBarController.tabBar.tintColor = [UIColor yellowColor];
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
    
  //显示tabbar
    
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //再次进来走这个方法，继续刷新
   
    [self refreshNewSource];
    
    

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*tableView*/
    
    //单例
    _userInfo = [CbyUserSingleton shareUserSingleton];
    

    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width,(Height-0.2*Height)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView ];
    
    /*下拉刷新*/
    _imgName = [NSMutableArray array];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.frame = CGRectMake((Width-80)*0.5, 20, 80, 40);
    refreshControl.tintColor = [UIColor lightGrayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新中。。。"];
    [refreshControl addTarget:self action:@selector(refreshNewSource) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.refreshControl isRefreshing];
    [self.tableView addSubview:self.refreshControl];
    
    

    //badge   有更新的话会显示提醒坐标，没有的话不显示,不能在tableView的方法中创建，否则返回来提醒依然会存在
    
    _oilBadge = [self badgeLabelWithFrameX:Width*0.6-10 title:self.oilBageNum];
    
    //_ticketBage = [self badgeLabelWithFrameX:Width*0.9-5 title:self.ticketBageNum];

    
  
   
    //数据源
  
    self.menuListArr = @[@"CheckViewController",@"OilDiscountViewController",@"PMViewController",@"HomeServiceController",@"CommonSenseViewController",@"RepairViewController",@"ServiceViewController"];

}


#pragma mark--
#pragma mark 页面分块设置
-(void)bannerSettingWithView:(UIView *)view
{
    /*banner 上得滚动试图*/
    _myScrollView = [[MYScrollView alloc]initWithFrame:CGRectMake(0, 0, Width,120) Image:self.imgArr];
    self.myScrollView.myDelegate = self;

    [view addSubview:self.myScrollView];

}


#pragma mark -
#pragma mark on timer method call back

//页面跳转
#pragma mark- MYScrollView delegate
-(void)tapImageLoopToViewController
{

     
    loopFlag = (int)self.myScrollView.startContent;
     NSInteger tempNum = [[self.imgName[loopFlag] objectForKey:kLoopFlag] integerValue] ;
     UIViewController *VC = [[NSClassFromString(self.menuListArr[tempNum]) alloc] init];
     [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark -- /*优惠信息*/


-(void)discountInfoWithView:(UIView *)view
{
    //背景图片

    _discountImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, 90+20)];
    self.discountImgView.userInteractionEnabled = YES;
    
    
    //三种优惠信息的button
    //免费检测
    UIButton *addOilBtn = [self btnWithFrame:CGRectMake(5, 15, Width*0.3, 80) imgName:@"jiance"title:@"免费车检"];
    addOilBtn.titleLabel.textColor = [UIColor redColor];
    [addOilBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    addOilBtn.tag = BUTTONTYPE_FREE;
    [self.discountImgView addSubview:addOilBtn];

    
    //加油优惠  contentRect.size.width
    UIButton *ticketBtn = [self btnWithFrame:CGRectMake(CGRectGetMaxX(addOilBtn.frame), 15, Width*0.3, 80) imgName:@"jiayou" title:@"加油优惠"];
    ticketBtn.tag = BUTTONTYPE_OILADD;
    [self.discountImgView addSubview:ticketBtn];
    
    
    //充值优惠（已更改）
    //甲醛检测介绍
    UIButton *commonSense = [self btnWithFrame:CGRectMake(CGRectGetMaxX(ticketBtn.frame)+13, 15, Width*0.3, 80) imgName:@"JQpm25" title:@"车内污染"];
    commonSense.tag = BUTTONTYPE_TICKET;
    [self.discountImgView addSubview:commonSense];
    
    
    //分割线
    UIView *line1 = [self lineViewWithFrameX:Width*0.32];
    [view addSubview:line1];
    
    UIView *line2 = [self lineViewWithFrameX:2*Width*0.33];
    [view addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), Width, 1)];
    line3.backgroundColor = [UIColor colorWithRed:219/255.0 green:216/255.0 blue:216/255.0 alpha:1.0f];

    [view addSubview:line3];
    
    
    
    
    [view addSubview:self.discountImgView];

    
}

//btn封装
-(UIButton *)btnWithFrame:(CGRect)frame imgName:(NSString *)imgName title:(NSString *)title
{
    
    UIImage *imgBtn = [UIImage imageNamed:imgName];
    
    CustomButton *addOilButton = [[CustomButton alloc]initWithFrame:frame];
    addOilButton.rateFloat = 0.9;
    [addOilButton setImage:imgBtn forState:UIControlStateNormal];
    [addOilButton setTitle:title forState:UIControlStateNormal];
    addOilButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    addOilButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addOilButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addOilButton addTarget:self action:@selector(responseSender:) forControlEvents:UIControlEventTouchUpInside];
    return addOilButton;
    
}



//线条
-(UIView *)lineViewWithFrameX:(CGFloat)x
{

    UIView *lineVew = [[UIView alloc]initWithFrame:CGRectMake(x, 0, 1, 110+20)];
    lineVew.backgroundColor = [UIColor colorWithRed:219/255.0 green:216/255.0 blue:216/255.0 alpha:1.0f];
    return lineVew;
    
}

//bage
-(UIButton *)badgeLabelWithFrameX:(CGFloat) x  title:(NSString *)title
{
    UIButton *btnBadge = [[UIButton alloc]initWithFrame:CGRectMake(x,75, 20, 20)];
    btnBadge.layer.cornerRadius = 10;
    [btnBadge setTitle:title forState:UIControlStateNormal];
    btnBadge.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btnBadge setTitleColor:[UIColor colorWithRed:245/255.0 green:244/255.0 blue:241/255.0 alpha:1.0f] forState:UIControlStateNormal];
    btnBadge.backgroundColor = [UIColor redColor];
    return btnBadge;
}

#pragma mark --- /*预约保养*/

-(void)bookServiceWithView:(UIView *)view
{
    //背景图片
    
    UIImageView *tempView = self.discountImgView;
    _serviceImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, Width, Height-CGRectGetMaxY(tempView.frame))];
    self.serviceImgView.backgroundColor = [UIColor whiteColor];
    self.serviceImgView.userInteractionEnabled = YES;
    
    
    //button
    
    CGFloat kMarginWid = 20;//间距
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kMarginWid, 120*0.1, Width*0.6, 120*0.5)];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;//切角
    UIImage *bgImg = [UIImage imageNamed:@"bg"];
    [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:bgImg forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    //btn 上的图片设置
    
    UIImage *carImg = [UIImage imageNamed:@"car2"];
    [btn setImage:carImg forState:UIControlStateNormal];
    [btn setTitle:@"预约\r上门保养" forState:UIControlStateNormal];
    btn.titleLabel.numberOfLines = 2;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onHomeService:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img = [UIImage imageNamed:@"changshi"];

    UIButton *commonSense = [self btnWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+20, CGRectGetMinY(btn.frame), 60, 60) imgName:nil title:@"小常识"];
    commonSense.titleLabel.font = [UIFont systemFontOfSize:12.0f];
   


    [commonSense setImage:img forState:UIControlStateNormal];
    [self.serviceImgView addSubview:commonSense];
    commonSense.tag = BUTTONTYPE_COMMONSENSE;
    
    [self.serviceImgView addSubview:btn];
    [view addSubview:self.serviceImgView];
}


#pragma mark --- /*中间小车设置方法*/


-(void)carShowWithView:(UIView *)view
{
    /*背景设置 */
     _viewShow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 100)];
    self.viewShow.backgroundColor = [UIColor colorWithRed:88/255.0 green:164/255.0 blue:241/255.0 alpha:1.0f];
    self.viewShow.userInteractionEnabled = YES;
    [view addSubview:self.viewShow];
    
    /*线条设置*/
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(30, 70, Width-40, 3)];
    self.line.backgroundColor = [UIColor whiteColor];

    //渐变色
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    gradient.frame = CGRectMake(0, 0, Width-40, 3);
    gradient.colors = @[(id)[UIColor whiteColor].CGColor,(id)kRGB(204, 204, 204).CGColor,(id)kRGB(119, 119, 119).CGColor,(id)kRGB(34, 34, 34).CGColor];
    [self.line.layer insertSublayer:gradient atIndex:0];
    
    [self.viewShow addSubview:self.line];
    
    //label
    
    UILabel *labelPerfect = [self labelWithFrame:CGRectGetMinX(self.line.frame)+CGRectGetWidth(self.line.frame)*0.1 Text:@"良好"];
    [self.viewShow addSubview:labelPerfect];
    
    UILabel *labelWell = [self labelWithFrame:CGRectGetMinX(self.line.frame)+CGRectGetWidth(self.line.frame)*0.35 Text:@"建议保养"];
    [self.viewShow addSubview:labelWell];
    UILabel *labelWeak = [self labelWithFrame:CGRectGetMinX(self.line.frame)+CGRectGetWidth(self.line.frame)*0.75 Text:@"急需保养"];
    [self.viewShow addSubview:labelWeak];
    
  
    /*小车显示*/
    
    
   
    //初始化小车
    UIImageView *carView = [[UIImageView alloc]init];

    carView.frame = CGRectMake(10*(1+self.rate), CGRectGetMinY(self.line.frame)-52, 83, 52);
  
    carView.tag = 4001;
    carView.image = [UIImage imageNamed:@"car"];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(valueShowDetail:)];
    
    carView.userInteractionEnabled = YES;
    [carView addGestureRecognizer:tapGesture];

    [self.viewShow addSubview:carView];
    
    //评分显示
    UIImageView *imgScoreView = [[UIImageView alloc]initWithFrame:CGRectMake(Width-80, 5, 54, 54)];
    imgScoreView.layer.borderColor = [UIColor whiteColor].CGColor;
    imgScoreView.layer.borderWidth = 2.0f;
    imgScoreView.layer.cornerRadius = 27;
    imgScoreView.clipsToBounds = YES;
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,7, 50, 40)];
   scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    scoreLabel.text = [NSString stringWithFormat:@"%.0f分",(100-self.rate/0.4)];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [imgScoreView addSubview:scoreLabel];
    
    [self.viewShow addSubview:imgScoreView];


    
}

#pragma mark-- 自定义label
-(UILabel *)labelWithFrame:(float)frameX Text:(NSString *)text
{
    UILabel *labelPerfect = [[UILabel alloc] initWithFrame:CGRectMake(frameX, CGRectGetMaxY(self.line.frame)+3, 50, 30)];
    labelPerfect.text = text;
    labelPerfect.font = [UIFont systemFontOfSize:12.0f];
    labelPerfect.textColor = [UIColor whiteColor];
    labelPerfect.textAlignment = NSTextAlignmentCenter;
    return labelPerfect;
}

#pragma mark -- target- action

//上门保养事件
-(void)onHomeService:(UIButton *)sender
{

    
        HomeServiceController *modalVc = [[HomeServiceController alloc] init];
        /*navigation*/
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textlabel.text = @"上门保养";
        textlabel.font = [UIFont boldSystemFontOfSize:20];
        textlabel.textAlignment = NSTextAlignmentCenter;
        textlabel.textColor = [UIColor whiteColor];
        modalVc.navigationItem.titleView = textlabel;
        modalVc.labelText = textlabel.text;
        
        //隐藏bottomBar
        modalVc.hidesBottomBarWhenPushed = YES;
       
    [self.navigationController pushViewController:modalVc animated:YES];
    
    
}

//优惠按钮响应事件
-(void)responseSender:(UIButton *)sender
{
    switch (sender.tag) {
        case BUTTONTYPE_FREE:
        {
            
            CheckViewController *checkVC = [[CheckViewController alloc]init];
            //隐藏bottomBar
            checkVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:checkVC animated:YES];
            
        }
            break;
            
        case BUTTONTYPE_OILADD:
        {
            self.oilBageNum = @"0";
            [self.oilBadge removeFromSuperview];
            OilDiscountViewController *oilVC = [[OilDiscountViewController alloc]init];
            //隐藏bottomBar
            oilVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:oilVC animated:YES];
        }
            break;
            
        case BUTTONTYPE_TICKET:
        {
            PMViewController *pmVC =[[PMViewController alloc]init];
            pmVC.hidesBottomBarWhenPushed = YES;
            pmVC.title = @"空气质量检测介绍";
            [self.navigationController pushViewController:pmVC animated:YES];
            
        }
            break;

        case BUTTONTYPE_COMMONSENSE:
        {
            CommonSenseViewController *commonSenseVC = [[CommonSenseViewController alloc]init];
            //隐藏bottomBar
            commonSenseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commonSenseVC animated:YES];
        }
            break;

        default:
            break;
    }
}

//登录
-(void)onLogin:(UIButton *)sender
{

   
    if (self.userInfo.isLogin) {
        
        self.tabBarController.selectedIndex = 3;
        
    }else{
    
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

//评分

-(void)valueShowDetail:(UITapGestureRecognizer *)gesture
{
    ValueControllerTableViewController *valueDetail = [[ValueControllerTableViewController alloc]init];
    valueDetail.tempDic = self.valueDic;

    [valueDetail returnScore:^(int scoreShow) {
        if (scoreShow == 0) {
           // self.scoreLabel.text = @"0分";
            self.rate = 0.0f;
            [self.tableView reloadData];
        }else{
       // self.scoreLabel.text = [NSString stringWithFormat:@"%d分",scoreShow];
            self.rate = (100-scoreShow)*0.4;
            [self.tableView reloadData];
        }
        
        
    }];
    valueDetail.title = @"车况评估";
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = valueDetail.title;
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    valueDetail.navigationItem.titleView = textlabel;
    [self.navigationController pushViewController:valueDetail animated:YES];
    
}




#pragma mark -- tableView delegate/dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row == 0) {
        [self carShowWithView:cell.contentView];
    }else if(indexPath.row == 1){
        
        [self discountInfoWithView:cell.contentView];
    }else{
        
        [self bookServiceWithView:cell.contentView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 130;
    }else if (indexPath.row == 0){
        return 100;
        
    }else{
        
        return 120;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 120)];
    if (self.imgArr.count) {
        [self bannerSettingWithView:view];
    }else{
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:view.frame];
        imgView.image = [UIImage imageNamed:@"holder"];
        [view addSubview:imgView];
    }
    
    return view;
}


#pragma mark --刷新数据

-(void)refreshNewSource
{
    
    
    //scrollView
  
    [self performSelector:@selector(stopRefreshing) withObject:self afterDelay:5.0f];
    
    //请求banner图片
    AFHTTPRequestOperationManager *managerBanner = [AFHTTPRequestOperationManager manager];
 
    
    NSString *bannerUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_banner.php"];
    [managerBanner POST:bannerUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject  objectForKey:@"status"] isEqualToString:@"ok"]) {
        
            
            [self.imgName removeAllObjects];
            
            for (NSDictionary *dic in [responseObject objectForKey:@"bannerlist"]) {
                
                [self.imgName addObject:dic];
                
            }
            self.imgArr = self.imgName;
            
            
           
            [self.tableView reloadData];
            
            [self.refreshControl endRefreshing];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"banner error:%@",error);
               
    }];
    
    if (self.userInfo.isLogin) {
     
        //请求加油优惠数量
        
         AFHTTPRequestOperationManager *managerOil= [AFHTTPRequestOperationManager manager];
        NSString *oilUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
        NSDictionary *parameterOil = @{kInterfaceName:@"updateNumber",
                                       @"historyTime":self.userInfo.oilHistoryTime
                                       };
        
        
        [managerOil POST:oilUrl parameters:parameterOil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
           
            self.oilBageNum = [responseObject objectForKey:@"number"];
            
            if ([self.oilBageNum isEqualToString:@"0"]){
                [self.oilBadge removeFromSuperview];
                
            }else {
                [self.oilBadge setTitle:self.oilBageNum forState:UIControlStateNormal];
                [self.discountImgView addSubview:self.oilBadge];
                
            }
            
      
            

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"oil Error:%@",error);
            
        }];
        
//        //请求充值优惠的接口
//        
//         AFHTTPRequestOperationManager *managerTicket = [AFHTTPRequestOperationManager manager];
//        NSString *TicketUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_charge.php"];
//        NSDictionary *parameterTicket = @{kInterfaceName : @"updateNumber",
//                                          @"historyTime": self.userInfo.ticketHistoryTime
//                                          };
//        
//        
//        [managerTicket POST:TicketUrl parameters:parameterTicket success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//                
//                self.ticketBageNum = [responseObject objectForKey:@"number"];
//                
//                if ([self.ticketBageNum isEqualToString:@"0"]) {
//                    
//                    [self.ticketBage removeFromSuperview];
//                }else
//                {
//                    [self.ticketBage setTitle:self.ticketBageNum forState:UIControlStateNormal];
//                    [self.discountImgView addSubview:self.ticketBage];
//                }
//
//            
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            NSLog(@"Ticket error:%@",error);
//            
//        }];
//
        
    }
    
}


//停止刷新按钮
-(void)stopRefreshing
{
    [self.refreshControl endRefreshing];
}


@end
