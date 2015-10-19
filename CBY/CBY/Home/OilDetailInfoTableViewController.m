//
//  OilDetailInfoTableViewController.m
//  51CBY
//
//  Created by SJB on 15/3/4.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "OilDetailInfoTableViewController.h"
#import "AFNCommon.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "OilDetaiTableViewCell.h"
#import "MapViewController.h"

@interface OilDetailInfoTableViewController ()
@property(nonatomic, strong) NSDictionary *detailDic;
@property(nonatomic, strong) UIImageView *imgView;

@end

@implementation OilDetailInfoTableViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //header
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    
    //tableView
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //右视图，加载地图导航
    
    UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [userBtn setTitle:@"去这里" forState:UIControlStateNormal];
    userBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [userBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userBtn addTarget:self action:@selector(goMap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:userBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //数据
    _detailDic = [NSDictionary dictionary];
    
    //获取加油优惠详细信息
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *detailUrl;
    NSDictionary *parameter;
    if ([self.loopFlag isEqualToString:@"1"]) {
        
        detailUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_oil.php"];
        parameter = @{kInterfaceName:@"getDetail",
                      @"promote_id":self.promte};
    }else{
        detailUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_charge.php"];
        parameter = @{kInterfaceName:@"getDetail",
                                @"charge_id":self.promte};
    }
   [manager POST:detailUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
       if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
           self.detailDic = [responseObject objectForKey:@"data"];
           [self.tableView reloadData];
       }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"error:%@",error);
       
   }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    OilDetaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (nil == cell) {
       
        NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:@"OilDetaiTableViewCell" owner:self options:nil];
        cell = cellArr[0];
        
    }

    cell.oilTitleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    cell.detailOilLabel.textColor = [UIColor colorWithRed:250/255.0 green:152/255.0 blue:47/255.0 alpha:1.0];
    cell.detailOilLabel.numberOfLines = 0;
    cell.detailOilLabel.font = [UIFont systemFontOfSize:12.0f];
    
    if (indexPath.row == 0) {
        
        cell.oilTitleLabel.text = [self.detailDic objectForKey:@"station_name"];
        cell.detailOilLabel.text = [self.detailDic objectForKey:@"promote_title"];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:250/255.0 green:152/255.0 blue:47/255.0 alpha:1.0];
        
    }else if(indexPath.row == 1){
        
        cell.oilTitleLabel.text = @"加油详情:";
       
        cell.detailOilLabel.text = [self.detailDic objectForKey:@"promote_content"];
    
    }else{
        
        cell.oilTitleLabel.text = [NSString stringWithFormat:@"%@(%@)",[self.detailDic objectForKey:@"station_name"],[self.detailDic objectForKey:@"plate_name"]];
      
        cell.detailOilLabel.text = [NSString stringWithFormat:@"%@%@%@" ,[self.detailDic objectForKey:@"province_name"],[self.detailDic objectForKey:@"city_name"],[self.detailDic objectForKey:@"address"]];
        cell.detailOilLabel.textColor = [UIColor colorWithRed:129/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self.imgView sd_setImageWithURL:[self.detailDic objectForKey:@"station_img"] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
    
    return self.imgView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return (self.view.bounds.size.height*0.15);
    }else if (indexPath.row == 1){
        return (self.view.bounds.size.height*0.2);
    }else{
        return (self.view.bounds.size.height*0.15);
    }
}


#pragma mark -- 加载地图
-(void)goMap
{
    MapViewController *mapViewVC = [[MapViewController alloc] init];
    mapViewVC.title = @"地图";
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = mapViewVC.title;
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    mapViewVC.navigationItem.titleView = textlabel;
    
    //将目的地址传给地图
    mapViewVC.destinationAddress = [NSString stringWithFormat:@"%@%@%@" ,[self.detailDic objectForKey:@"province_name"],[self.detailDic objectForKey:@"city_name"],[self.detailDic objectForKey:@"address"]];

    [self.navigationController pushViewController:mapViewVC animated:YES];
}

@end
