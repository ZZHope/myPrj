//
//  CommonSenseViewController.m
//  51CBY
//
//  Created by SJB on 15/1/5.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "CommonSenseViewController.h"
#import "CommonSenseCell.h"
#import "CbyUserSingleton.h"
#import "AFNetworking.h"
#import "AFNCommon.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "CommonseDetailController.h"



#define Width self.view.bounds.size.width
#define Height self.view.bounds.size.height
#define kImage @"image"
#define kTitle  @"title"
#define kFocus  @"focus_status"
#define kTime  @"time"
#define kDetailTitle  @"content"
#define kInfoId   @"info_id"
#define kFocusId  @"focus_id"


@interface CommonSenseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) CbyUserSingleton *commUser;
@property(nonatomic,strong) UISegmentedControl *segment;

@property(nonatomic,strong) NSMutableArray *finalArr;

@end

BOOL isFocus ;

@implementation CommonSenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*navigation*/
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"小常识";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    

    /*数据源*/
    self.finalArr = [NSMutableArray array];
    
    /*tableView*/
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-49) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    /*segment*/
     _segment = [[UISegmentedControl alloc]initWithItems:@[@"驾车",@"保养",@"关注"]];
     [self.segment addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    //self.segment.tintColor = [UIColor colorWithRed:128/255.0 green:126/255.0 blue:126/255.0 alpha:1.0f];
    self.segment.tintColor = [UIColor whiteColor];
    [self.segment setBackgroundImage:[UIImage imageNamed:@"浅蓝.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segment setBackgroundImage:[UIImage imageNamed:@"深蓝.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    NSDictionary *selectedAtt  = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    
    [self.segment setTitleTextAttributes:selectedAtt forState:UIControlStateSelected];
    
    //userInfo
    _commUser = [CbyUserSingleton shareUserSingleton];
    
    
    //刷新
    //下拉刷新设置
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadCommonseData)];
    [self.tableView.header setTitle:@"小保正在为您刷新。。。" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header beginRefreshing];
    
    //上拉刷新,加载更多数据
    self.tableView.footer.stateHidden = YES;
    self.tableView.footer.automaticallyRefresh = NO;

    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"加载更多 ..." forState:MJRefreshFooterStateRefreshing];
    
    // 设置字体
    self.tableView.footer.font = [UIFont systemFontOfSize:17];

}

#pragma mark -- tableView Datasource  / delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.finalArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellID";
    CommonSenseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        
        NSArray *cellArr =  [[NSBundle mainBundle] loadNibNamed:@"CommonSenseCell" owner:self options:nil];
        cell = [cellArr objectAtIndex:0];
        
        
    }
    
    [cell.imgview sd_setImageWithURL:[self.finalArr[indexPath.row] objectForKey:kImage] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
    cell.titleLabel.text = [self.finalArr[indexPath.row]objectForKey:kTitle];
    cell.detailLabel.text = [self.finalArr[indexPath.row]objectForKey:kDetailTitle ];
    cell.focusBtn.flag = [[self.finalArr[indexPath.row] objectForKey:kFocus ]boolValue];
    [cell.focusBtn addTarget:self action:@selector(focusAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.focusBtn.tag = indexPath.row+1000;
    
    [cell.timeLabel setTitle:[self.finalArr[indexPath.row] objectForKey:kTime] forState:UIControlStateNormal];
   
    [cell.timeLabel setImage:[[[UIImage imageNamed:@"时间"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    cell.timeLabel.userInteractionEnabled = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, Width, 40)];

    /*segment*/
    self.segment.frame = CGRectMake(0,5, Width, 30);
 
    [bgView addSubview:self.segment];
 
    return bgView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    CommonseDetailController *detailVC = [[CommonseDetailController alloc] init];
    detailVC.commonInfoId = [self.finalArr[indexPath.row] objectForKey:kInfoId];
    detailVC.title = @"详细信息";
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark -- custom 

//segment用于切换数据源
-(void)changeDataSource:(UISegmentedControl *)segment
{
            switch (segment.selectedSegmentIndex) {
            case 0:
            {
                [self.tableView.header beginRefreshing];
                
                
            }
                break;
                
            case 1:
            {
                [self.tableView.header beginRefreshing];


            }
                break;
                
            case 2:
            {

                [self.tableView.header beginRefreshing];
            }
                break;
            default:
                break;
        }


    
}



#pragma mark --
// target -action

-(void)focusAction:(MYFocusButton *)sender
{
   NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.finalArr[sender.tag-1000]];
   
    if (sender.flag) {
        sender.flag = NO;


        [self cancelCareWithFocusId:[dic objectForKey:kFocusId]];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:kFocus];
      
        
      
    }else{
        sender.flag = YES;
 
        [self addCareCommonseWithInfoId:[dic objectForKey:kInfoId] andTag:(sender.tag-1000)];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kFocus];
     



    }
    
    
    self.finalArr[sender.tag-1000] = dic;
  
    
    
}


#pragma mark -- 小常识 数据

-(void)loadCommonseData
{
    switch (self.segment.selectedSegmentIndex) {
        case 0:
            [self loadCommonSenseDataWithPara:@"2"];
            break;
        case 1:
            [self loadCommonSenseDataWithPara:@"1"];
            break;
        case 2:
            [self loadCommonSenseDataWithPara:@"3"];
            break;
 
        default:
            break;
    }
}

-(void)loadCommonSenseDataWithPara:(NSString *)paraStr     //保养 1， 驾车2，  关注 3
{
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_knowledge.php"];
    NSDictionary *parameter = @{kUserID:self.commUser.userID,
                                @"operation":paraStr};

    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            [self.finalArr removeAllObjects];
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                [self.finalArr addObject:dic];
            }
            [self.tableView reloadData];
        }
        
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        NSLog(@"commsense error:%@",error);
    }];
    
    
}

//加关注
-(void)addCareCommonseWithInfoId:(NSString *)infoID andTag:(NSInteger)tag
{
    if (self.commUser.isLogin) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_knowledge.php"];
        NSDictionary *parameter = @{@"operation":@"7",
                                    @"user_id":self.commUser.userID,
                                    @"infoId":infoID};
        [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.finalArr[tag]];
                [dic setObject:[responseObject objectForKey:@"focus_id"] forKey:@"focus_id"];
                self.finalArr[tag] = dic;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"common care error:%@",error);
        }];
    }else{
        
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
}

//取消关注
-(void)cancelCareWithFocusId:(NSString *)focusId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_knowledge.php"];
    NSDictionary *parameter = @{@"operation":@"8",
                                @"focusId":focusId};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"common cancelCare error:%@",error);
    }];

}


//上拉加载更多
-(void)loadMoreData
{
    switch (self.segment.selectedSegmentIndex) {
        case 0:
            [self loadMoreCommonSenseDataWithPara:@"2"];
            break;
        case 1:
            [self loadMoreCommonSenseDataWithPara:@"1"];
            break;
        case 2:
            [self loadMoreCommonSenseDataWithPara:@"3"];
            break;
            
        default:
            break;
    }

}

-(void)loadMoreCommonSenseDataWithPara:(NSString *)paraStr     //保养 1， 驾车2，  关注 3
{
    if (self.finalArr.count) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_knowledge.php"];
        NSDictionary *parameter = @{kUserID:self.commUser.userID,
                                    @"operation":paraStr,
                                    @"minId":[[self.finalArr lastObject] objectForKey:kInfoId]};
        
        [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.tableView.footer endRefreshing];
         
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                
                for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                    [self.finalArr addObject:dic];
                }
                [self.tableView reloadData];
            }
            
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView.footer endRefreshing];
            NSLog(@"commsense more error:%@",error);
        }];

    }
    
    
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
