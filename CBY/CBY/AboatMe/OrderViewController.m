//
//  OrderViewController.m
//  51CBY
//
//  Created by SJB on 15/1/8.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "OrderViewController.h"

#import "AFNetworking.h"
#import "AFNCommon.h"
#import "CbyUserSingleton.h"
#import "UIImageView+WebCache.h"
#import "OrderTableViewCell.h"

#define kWidth self.view.bounds.size.width


@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySC;
@property (weak, nonatomic) IBOutlet UIImageView *mobileImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CbyUserSingleton *userOrderInfo;

//数据存储
@property (strong, nonatomic) NSMutableArray *orderListArrM;
@property (strong, nonatomic) NSMutableArray *carDescriptionM;
//存放展开状态的数组

@property (strong, nonatomic) NSMutableArray *showGoodsFlag;
@property (strong, nonatomic) NSMutableArray *showServiceFlag;



@end

int pageFlag = 0;
int pageFlagUnFinish = 0;



@implementation OrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self navigation];
    [self segement];
    
    //user
    _userOrderInfo = [CbyUserSingleton shareUserSingleton];
    
    _mobileImage.frame = CGRectMake((self.view.frame.size.width/2)/2, 35, 100, 3);
    self.tableView.backgroundColor = [UIColor whiteColor];
    
   //刷新
    //下拉刷新设置
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [self loadOrderDataFromSever];
    }];
    
    [self.tableView.header setTitle:@"小保正在为您刷新。。。" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header beginRefreshing];
    
    
    self.tableView.footer.stateHidden = YES;
    self.tableView.footer.automaticallyRefresh = NO;
    
    //上拉刷新
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
    [self loadMoreData];
        
    }];
    
    // 设置文字
    [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"加载更多 ..." forState:MJRefreshFooterStateRefreshing];
    [self.tableView.footer setTitle:@"数据已经全部加载完" forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    self.tableView.footer.font = [UIFont systemFontOfSize:17];
    
    // 设置颜色
//    self.tableView.footer.textColor = [UIColor grayColor];
    
    
    //数据源
    _orderListArrM = [NSMutableArray array];
    _carDescriptionM = [NSMutableArray array];
    
    _showGoodsFlag = [NSMutableArray array];
    _showServiceFlag = [NSMutableArray array];
   
}


- (void)navigation {
    /*navigation*/
    
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"我的订单";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
}

#pragma mark - segement选择器
-(void)segement{
    
    //self.mySC.momentary = YES;//取消点击时的背景色
    
    self.mySC.tintColor = [UIColor whiteColor];
    
    [self.mySC setBackgroundImage:[UIImage imageNamed:@"segement.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mySC setBackgroundImage:[UIImage imageNamed:@"segement.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    //设置SC的样式
    NSDictionary *att  = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:14]};
    [self.mySC setTitleTextAttributes:att forState:UIControlStateNormal];
    
    NSDictionary *selectedAtt  = @{NSForegroundColorAttributeName: [UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.mySC setTitleTextAttributes:selectedAtt forState:UIControlStateSelected];
    
   self.mySC.selectedSegmentIndex = 0;
}


//线条移动的位置
-(void)moveImage:(NSTimer*)timer{
    
    UISegmentedControl *sender = timer.userInfo;
    [UIView animateWithDuration:.2 animations:^{
        self.mobileImage.center = CGPointMake(sender.selectedSegmentIndex*(self.view.frame.size.width/2) +(self.view.frame.size.width/2)/2, self.mobileImage.center.y);
    }];
}




#pragma mark -- table datasource / delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return self.orderListArrM.count*3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSMutableArray *arrGoods = [NSMutableArray array];
    NSMutableArray *arrService = [NSMutableArray array];
    
  
  
    
    
    if (section%3 == 0) {
        return 0;
    }else if (section%3 == 1) {
        
        if (self.showServiceFlag.count && [self.showServiceFlag[section] boolValue]) {
        for (NSString *key in  [[self.orderListArrM[(section/3)] objectForKey:@"car"] allKeys]) {
                for (NSDictionary *dic in [[[self.orderListArrM[(section/3)] objectForKey:@"car"] objectForKey: key] objectForKey:@"service"]) {
                    [arrService addObject:dic];
                }
                
            }

        return arrService.count;

        }else{
            
            return 0;
        }
    }else{
        if (self.showGoodsFlag.count &&[self.showGoodsFlag[section] boolValue]) {
            for (NSString *key in  [[self.orderListArrM[(section/3)] objectForKey:@"car"] allKeys]) {
                for (NSDictionary *dic in [[[self.orderListArrM[(section/3)] objectForKey:@"car"] objectForKey: key] objectForKey:@"goods"]) {
                    [arrGoods addObject:dic];
                }
                
            }

        return arrGoods.count;
        }else{
            return 0;
        }
        
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString * identifier = @"cellID";
    
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
        
        cell = cellArr[0];
        
    }
    if (indexPath.section %3 == 1) {
        
        for (NSString *key in  [[self.orderListArrM[(indexPath.section/3)] objectForKey:@"car"] allKeys]) {
            
            
            NSDictionary *dic  = [[[self.orderListArrM[(indexPath.section/3)] objectForKey:@"car"] objectForKey: key] objectForKey:@"service"][indexPath.row];
            
                [cell.imgViewOrder sd_setImageWithURL:[dic objectForKey:@"original_img"] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];//
                cell.textOrder.text = [dic objectForKey:@"goods_name"];
            
            
        }
        

    }
    if (indexPath.section%3 == 2) {
        
        
        for (NSString *key in  [[self.orderListArrM[(indexPath.section/3)] objectForKey:@"car"] allKeys]) {
            
            NSDictionary *dic = [[[self.orderListArrM[(indexPath.section/3)] objectForKey:@"car"] objectForKey: key] objectForKey:@"goods"][indexPath.row];
           
            [cell.imgViewOrder sd_setImageWithURL:[dic objectForKey:@"original_img"] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
            
            
            cell.textOrder.text = [dic objectForKey:@"goods_name"];
            
            
        }


        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 120.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
 
    if (section%3 == 0) {
        return 60.0f;
    }else {
        return 50.0f;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section%3 == 2) {
        return 140.0f;
    }else{
        
        return 1.0f;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section%3 == 0 ) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        imgView.image = [UIImage imageNamed:@"OrderCar"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10, 10, kWidth-60, 40)];
        
        if (self.orderListArrM.count) {
            
            for (NSString *key in  [[self.orderListArrM[(section/3)] objectForKey:@"car"] allKeys]) {
                
                NSDictionary *carDic = [NSDictionary dictionaryWithDictionary:[[self.orderListArrM[(section/3)] objectForKey:@"car"] objectForKey: key]];
                    
                    label.text = [carDic objectForKey:@"car"];
                
                
                
            }

        }
        
        
        //label.text = [NSString stringWithFormat:@"%@",];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:15.0f];
        [bgView addSubview:imgView];
        [bgView addSubview:label];
        return bgView;
    }else if(section%3 == 1){
        
         UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, kWidth-40, 40)];
        [btn setTitle:@"服务" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        UIImage *img = [[UIImage imageNamed:@"ShowDetail"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 310) resizingMode:UIImageResizingModeStretch];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showService:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+section;
        [bgView addSubview:btn];

        return bgView;
    }else{
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, kWidth-40, 40)];
        [btn setTitle:@"材料" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        UIImage *img = [[UIImage imageNamed:@"ShowDetail"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 179) resizingMode:UIImageResizingModeStretch];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [btn addTarget:self action:@selector(showGoods:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2000+section;
        [bgView addSubview:btn];
        return bgView;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section%3 == 2) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 160, 40)];
        label.font = [UIFont systemFontOfSize:15.0f];
        
        for (NSString *key in  [[self.orderListArrM[(section/3)] objectForKey:@"car"] allKeys]) {
            
            label.text = [NSString stringWithFormat:@"共%ld个服务%ld个商品",[[[[self.orderListArrM[(section/3)] objectForKey:@"car"] objectForKey: key] objectForKey:@"service"] count],[[[[self.orderListArrM[(section/3)] objectForKey:@"car"] objectForKey: key] objectForKey:@"goods"] count]];
            
        }

        
        
        
        [bgView addSubview:label];
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+1, kWidth-40, 40)];
        timeLabel.font = [UIFont systemFontOfSize:15.0f];
        timeLabel.text = [NSString stringWithFormat:@"服务时间 %@", [self.orderListArrM[(section/3)] objectForKey:@"service_time"]];
        
        [bgView addSubview:timeLabel];
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, 10, kWidth-200, 40)];
        priceLabel.text = [NSString stringWithFormat:@"实付:￥%@",[self.orderListArrM[(section/3)] objectForKey:@"total_fee"]];
         [bgView addSubview:priceLabel];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(timeLabel.frame)+2, kWidth-40, 2)];
        line.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [bgView addSubview:line];
       
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-100, CGRectGetMaxY(line.frame)+2, 80, 40)];
        if ([[self.orderListArrM[(section/3)] objectForKey:@"pay_status"]isEqualToString:@"0"]) {
            statusLabel.text = @"进行中";
        }else if (![[self.orderListArrM[(section/3)] objectForKey:@"pay_status"]isEqualToString:@"0"]&& ![[self.orderListArrM[(section/3)] objectForKey:@"order_status"]isEqualToString:@"1"]){
            statusLabel.text = @"已付款";
            
        }else{
            statusLabel.text = @"已完成";
        }
       
        statusLabel.layer.cornerRadius = 5.0f;
        statusLabel.clipsToBounds = YES;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.backgroundColor = [UIColor lightGrayColor];
        statusLabel.textColor = [UIColor whiteColor];
        statusLabel.font = [UIFont systemFontOfSize:18.0f];
        [bgView addSubview:statusLabel];
        return bgView;

    }else{
        return nil;
    }
    
}

#pragma mark -- segment

- (IBAction)changeAction:(UISegmentedControl *)sender {
    //打开timer移动线条
    [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(moveImage:) userInfo:sender repeats:NO];
    
    switch (sender.selectedSegmentIndex) {
        case 0:{
            

            
            [self.tableView.header beginRefreshing];
            
        }
            
            break;
            
        case 1:{
            
            
            [self.tableView.header beginRefreshing];

            
        }
            
            break;
            
        default:
            break;
    }
    
}


#pragma mark -- 刷新数据

//下拉刷新获取新数据
//获取已完成的数据
-(void)loadOrderDataFromSever
{
    
    NSString *strUrl = kOrderUrl;
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter;
    if (self.mySC.selectedSegmentIndex == 0) {
                parameter = @{@"interfaceName":@"getOrderList",
                      @"user_id":self.userOrderInfo.userID,
                      @"minId":@"0",
                      @"operation":@"finish"//noFinish
                      
                      };
   
    }else{
        
        
        parameter = @{@"interfaceName":@"getOrderList",
                      @"user_id":self.userOrderInfo.userID,
                      @"minId":@"0",
                      @"operation":@"noFinish"//noFinish
                      };
    }
    
   
    
    [manager POST:strUrl parameters :parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];
        
    
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.orderListArrM removeAllObjects];
            [self.showGoodsFlag removeAllObjects];
            [self.showServiceFlag removeAllObjects];
            [self.tableView reloadData];
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"order_list_info"] count]) {
                
                
                for (NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"order_list_info"]) {
                    
                    [self.orderListArrM addObject:dic];
                    [self.tableView reloadData];
                    
                }
                
                //记录展开与否的状态
                //
                for (int i =0; i<self.orderListArrM.count*3; i++) {
                    [self.showServiceFlag addObject:@NO];
                }
                for (int i =0; i<self.orderListArrM.count*3; i++) {
                    [self.showGoodsFlag addObject:@NO];
                }
               
               
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        NSLog(@"error %@",error);
    }];
    

}

//上拉刷新获取已完成的数据
-(void)loadMoreData
{
   
   

    NSString *strUrl = kOrderUrl;
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter;
    if (self.mySC.selectedSegmentIndex == 0) {
        if (self.orderListArrM.count) {
            pageFlag = [[[self.orderListArrM lastObject] objectForKey:@"order_id"] intValue];
        }else{
            pageFlag =0;
        }

        
        parameter = @{@"interfaceName":@"getOrderList",
                      @"user_id":self.userOrderInfo.userID,
                      @"minId":[NSString stringWithFormat:@"%d",pageFlag],
                      @"operation":@"noFinish"//noFinish
                      };

        
    }else{
        //获取未完成的数据

        if (self.orderListArrM.count) {
            pageFlagUnFinish = [[[self.orderListArrM lastObject] objectForKey:@"order_id"] intValue];
        }else{
            pageFlagUnFinish =0;
        }

        parameter = @{@"interfaceName":@"getOrderList",
                      @"user_id":self.userOrderInfo.userID,
                      @"minId":[NSString stringWithFormat:@"%d",pageFlagUnFinish],
                      @"operation":@"noFinish"//noFinish
                      };

    }
    
    [manager POST:strUrl parameters :parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.tableView.footer endRefreshing];
      
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
           

            if ([[[responseObject objectForKey:@"data"] objectForKey:@"order_list_info"] count]) {
                
                
                for (NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"order_list_info"]) {
                    
                    [self.orderListArrM addObject:dic];
                    for (int i =0; i<3; i++) {
                        [self.showServiceFlag addObject:@NO];
                    }
                    for (int i =0; i<3; i++) {
                        [self.showGoodsFlag addObject:@NO];
                    }

                    [self.tableView reloadData];
                    
                }
                
                
                
            }
        }

        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.footer endRefreshing];
        NSLog(@"order error %@",error);
    }];

}


#pragma mark -- 展开
-(void)showService:(UIButton *)sender
{
   
    if ([self.showServiceFlag[sender.tag-1000] boolValue]) {
        [self.showServiceFlag replaceObjectAtIndex:(sender.tag-1000) withObject:@NO];
    }else{
        [self.showServiceFlag replaceObjectAtIndex:(sender.tag-1000) withObject:@YES];
    }
    [self.tableView reloadData];
}

-(void)showGoods:(UIButton *)sender
{
    if ([self.showGoodsFlag[sender.tag-2000] boolValue]) {
        [self.showGoodsFlag replaceObjectAtIndex:(sender.tag-2000) withObject:@NO];
    }else{
        [self.showGoodsFlag replaceObjectAtIndex:(sender.tag-2000) withObject:@YES];
    }

    
    [self.tableView reloadData];

    
}

@end