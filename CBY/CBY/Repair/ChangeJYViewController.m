//
//  ChangeJYViewController.m
//  51CBY
//
//  Created by SJB on 15/4/8.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "ChangeJYViewController.h"
#import "AFNCommon.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "OrderTableViewCell.h"


#define kWidth  self.view.bounds.size.width
#define kHeight self.view.bounds.size.height

@interface ChangeJYViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;


//data
@property(nonatomic,strong) NSMutableArray *JYDataArrM;

@end

@implementation ChangeJYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kWidth, kHeight-50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    //数据源
    _JYDataArrM = [NSMutableArray array];
    
    //请求数据
    [self changeJY];
    
}




#pragma mark -- datasource/delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.JYDataArrM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self.JYDataArrM[section] allKeys]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellID";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
        cell = arr[0];
    }
    
    NSMutableArray *tempArrM = [NSMutableArray array];
    
    for (NSString *key in [self.JYDataArrM[indexPath.section] allKeys]) {
        
        [tempArrM addObject:[self.JYDataArrM[indexPath.section] objectForKey:key]];
    }

    [cell.imgViewOrder sd_setImageWithURL:[tempArrM[indexPath.row] objectForKey:@"original_img"] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
    cell.textOrder.numberOfLines = 2;
    cell.textOrder.text = [NSString stringWithFormat:@"%@L\t￥%@" ,[tempArrM[indexPath.row] objectForKey:@"goods_weight"],[tempArrM[indexPath.row] objectForKey:@"shop_price"]];
    
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kWidth-90, 40)];
    NSString *firstKey = [self.JYDataArrM[section] allKeys][0];
    label.text = [NSString stringWithFormat:@"%@" ,[[self.JYDataArrM[section] objectForKey:firstKey] objectForKey:@"goods_short_name"]];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor blackColor];
    [bgView addSubview:label];
    UIButton *btn= [[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, CGRectGetMinY(label.frame), 60, 40)];
    [btn setTitle:@"选择" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    btn.tag =section+1000;
    [btn addTarget:self action:@selector(selectChangeOil:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:btn];
    return bgView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark -- 更换机油
-(void)changeJY
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBasePubUrl,@"ajax_public.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getOilBrand",
                                @"carId":self.carIdJY};
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                [self.JYDataArrM addObject:dic];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"change oil error :%@",error);
    }];
    
}


#pragma mark -- return changeJY
-(void)changeJYInfo:(ReturnJYBlock)changeJYInfo
{
    self.changeJYInfo = changeJYInfo;
}

#pragma mark -- 选择
-(void)selectChangeOil:(UIButton *)sender
{
    NSDictionary *dic = [NSDictionary dictionary]; // [self.JYDataArrM[sender.tag-1000]];
    dic = self.JYDataArrM[sender.tag-1000];
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"4L"]];
    float price = 0;
    price = [[[dic objectForKey:@"1L"] objectForKey:@"shop_price"] floatValue]*([self.weightJY intValue]%4)+[[[dic objectForKey:@"4L"] objectForKey:@"shop_price"] floatValue]*([self.weightJY intValue]/4);
    [dicM setObject:[NSString stringWithFormat:@"%f",price] forKey:@"shop_price"];
    
    //加在一块的和分开的商品
    NSDictionary *totleDic = @{@"depart":dic,@"together":dicM};
    
    if (self.changeJYInfo) {
        self.changeJYInfo(totleDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
