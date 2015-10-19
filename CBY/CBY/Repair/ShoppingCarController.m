//
//  ShoppingCarController.m
//  51CBY
//
//  Created by SJB on 15/1/26.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "ShoppingCarController.h"
#import "SchemeCell.h"
#import "GoodsCell.h"
#import "ServiceCell.h"
#import "ConfirmationOrderController.h"

#import "CustomButton.h"
#import "UIImageView+WebCache.h"

#import "AFNetworking.h"
#import "AFNCommon.h"
#import "ConfirmationOrderController.h"
#import "CbyUserSingleton.h"

#define Width self.view.bounds.size.width

@interface ShoppingCarController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//购物车总数据源
@property (strong, nonatomic) NSMutableArray *ShopCartlist;

@property (strong, nonatomic) NSMutableArray *allGoods;
@property (strong, nonatomic) NSMutableArray *numberArr;

@property (strong, nonatomic)CbyUserSingleton *cartUserInfo;

//选择车型商品的信息加入该数组中
@property (strong, nonatomic) NSMutableArray *allGoodsArray;

//选中车型
@property(strong, nonatomic) NSMutableArray *chooseFlagM;

@end

@implementation ShoppingCarController

-(void)navigation
{
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"购物车";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self navigation];
    
    //userInfo
    _cartUserInfo = [CbyUserSingleton shareUserSingleton];
    
    
    
    _ShopCartlist = [NSMutableArray array];
    
    _allGoods = [NSMutableArray array];

    _numberArr = [NSMutableArray array];
    
    _allGoodsArray = [NSMutableArray array];
    _chooseFlagM = [NSMutableArray array];
    
    /*下拉刷新*/

    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [self refreshCartData];
        
    }];
    [self.tableView.header beginRefreshing];
        
    
}
 /*
  关于数据源的解析思路：
  将每个车型的车型信息，服务和商品占三个section，，取值分别用3的余数，这样更合理。
  鉴于下面的方法也能实现功能，也好理解，就没有更改，之后更改
  
  
  */

#pragma mark - Table view data source

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    
    return self.ShopCartlist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return ([[self.ShopCartlist[section] objectForKey:@"services"] count] + [[self.ShopCartlist[section] objectForKey:@"goods"] count]);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"SchemeCell";
    static NSString *identify = @"GoodsCell";
    static NSString *ident = @"ServiceCell";
    
    
    
    if (indexPath.row < [[self.ShopCartlist[indexPath.section] objectForKey:@"services"] count]) {
        
         if (indexPath.row == 0) {//第0个带有服务字样的label
                ServiceCell *cell = (ServiceCell*)[tableView dequeueReusableCellWithIdentifier:ident];
       
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ServiceCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kImageUrl,[[self.ShopCartlist[indexPath.section] objectForKey:@"services"][0] objectForKey:@"original_img"]]];
            [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
            
            cell.name.text = [[self.ShopCartlist[indexPath.section] objectForKey:@"services"][0] objectForKey:@"goods_name"];
             cell.name.font = [UIFont systemFontOfSize:15.0f];
            

             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else {//之后的不带服务字样的服务内容
            SchemeCell *cell = (SchemeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
            
                if (cell == nil) {
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SchemeCell" owner:self options:nil];//加载自定义cell的xib文件
                    cell = [array objectAtIndex:0];
                }

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kImageUrl,[[self.ShopCartlist[indexPath.section] objectForKey:@"services"][indexPath.row] objectForKey:@"original_img"]]];
            [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
            
            cell.name.text = [[self.ShopCartlist[indexPath.section] objectForKey:@"services"][indexPath.row] objectForKey:@"goods_name"];
              cell.name.font = [UIFont systemFontOfSize:15.0f];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (indexPath.row == [[self.ShopCartlist[indexPath.section] objectForKey:@"services"] count]) {//商品的第一个cell
        
        GoodsCell *cell = (GoodsCell*)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GoodsCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kImageUrl,[[self.ShopCartlist[indexPath.section] objectForKey:@"goods"][0] objectForKey:@"original_img"]]];
        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
        
        cell.name.text = [NSString stringWithFormat:@"%@(%@个)", [[self.ShopCartlist[indexPath.section] objectForKey:@"goods"][0] objectForKey:@"goods_name"],[[self.ShopCartlist[indexPath.section] objectForKey:@"goods"][0] objectForKey:@"goods_number"]];
        

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        SchemeCell *cell = (SchemeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];//复用cell
        
        if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SchemeCell" owner:self options:nil];//加载自定义cell的xib文件
                cell = [array objectAtIndex:0];
            }

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kImageUrl,[[self.ShopCartlist[indexPath.section] objectForKey:@"goods"][indexPath.row-[[self.ShopCartlist[indexPath.section] objectForKey:@"services"] count]] objectForKey:@"original_img"]]];
        
        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
        
        cell.name.text = [NSString stringWithFormat:@"%@(%@)", [[self.ShopCartlist[indexPath.section] objectForKey:@"goods"][indexPath.row-[[self.ShopCartlist[indexPath.section] objectForKey:@"services"] count]] objectForKey:@"goods_name"],[[self.ShopCartlist[indexPath.section] objectForKey:@"goods"][indexPath.row-[[self.ShopCartlist[indexPath.section] objectForKey:@"services"] count]] objectForKey:@"goods_number"]];   // ！！！这里取值的序数，[indexPath.row-[[self.ShopCartlist[indexPath.section] objectForKey:@"services"] count]]，要用好。解决了由于写死而显示不正常的问题
        

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    
    
   
}

#pragma mark - header的显示
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
  
    
    
    for (int i = 0; i < self.ShopCartlist.count; i++) {
        
        if (section == i) {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
            
            UIView *carView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
            carView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];

            [headerView addSubview:carView];
            
            
            //选择车型商品信息按钮
            UIButton *choiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
            
            choiceBtn.tag = 1+i;
            if (self.chooseFlagM.count && [self.chooseFlagM[i] boolValue]) {
                 [choiceBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
            }else{
                 [choiceBtn setImage:[UIImage imageNamed:@"不选中"] forState:UIControlStateNormal];
            }
           
            
            [choiceBtn addTarget:self action:@selector(choiceButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [headerView addSubview:choiceBtn];
            
            
            //车型名称
            UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(choiceBtn.frame)+5, 5, 195, 30)];
            carName.text = [NSString stringWithFormat:@"%@ %@ %@ %@",[[self.ShopCartlist[i] objectForKey:@"carinfo"] objectForKey:@"brand_name"],[[self.ShopCartlist[i] objectForKey:@"carinfo"] objectForKey:@"type_name"],[[self.ShopCartlist[i] objectForKey:@"carinfo"] objectForKey:@"engines"],[[self.ShopCartlist[i] objectForKey:@"carinfo"] objectForKey:@"builddate"]];
            
            carName.font = [UIFont systemFontOfSize:15.0];
            carName.textColor = [UIColor blackColor];
            [headerView addSubview:carName];
            
            //删除车型商品信息
            UIButton *relsesCar = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headerView.frame)-110, 5, 100, 30)];
            
            [relsesCar setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
            [relsesCar setTitle:@"清除该车型商品" forState:UIControlStateNormal];
            relsesCar.tag = section;
            [relsesCar.titleLabel setTextColor:[UIColor blackColor]];
            relsesCar.titleLabel.font = [UIFont systemFontOfSize: 13.0];
            //button点击事件 删除该车型和商品
            [relsesCar addTarget:self action:@selector(deletesGoods:) forControlEvents:UIControlEventTouchUpInside];
            
            [headerView addSubview:relsesCar];

            return headerView;
        }
        
    }
    
    return nil;
}

#pragma mark - 设置cell和header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *serviceArr = [NSMutableArray array];
    
    for (NSDictionary *dic in [self.ShopCartlist[indexPath.section] objectForKey:@"services"]) {
        [serviceArr addObject:dic];
    }

    if (indexPath.row == 0) {
        return 130;
    }
    if (indexPath.row == (int)serviceArr.count) {
        return 130;
    }
    return 88;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    for (int i = 0; i < self.ShopCartlist.count; i++) {
        if (section == i) {
            return 40;
        }
    }
    
    return 0;
}

#pragma mark - 选择的车型商品信息的点击事件
- (void)choiceButton:(UIButton *)sender {
     [self.allGoodsArray removeAllObjects];
    [self.chooseFlagM removeAllObjects];
    //选中的标志位,单选
    
    for (int i= 0; i<self.ShopCartlist.count; i++) {
        [self.chooseFlagM addObject:@NO];
    }
   
 
    [self.chooseFlagM replaceObjectAtIndex:(sender.tag-1) withObject:@YES];
    [self.allGoodsArray addObject:self.ShopCartlist[sender.tag-1]];
    [self.tableView reloadData];
    
#pragma mark - 商品总价
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.allGoodsArray.count; i++) {
        for (NSDictionary *dic in [self.allGoodsArray[i] objectForKey:@"goods"]) {
            [arr addObject:[dic objectForKey:@"goods_price"]];
        }
        for (NSDictionary *dic in [self.allGoodsArray[i] objectForKey:@"services"]) {
            [arr addObject:[dic objectForKey:@"goods_price"]];
        }
    }
    
    float num;
    for (int i = 0; i < arr.count; i++) {
        num += [arr[i] floatValue];
    }
    
    self.price.text = [NSString stringWithFormat:@"¥%.2f",num]; //关于价格的显示，只有在选择车型后才会显示商品价格，默认为零
    
}

#pragma mark - 删除该车型全部信息
- (void)deletesGoods:(UIButton *)sender {
    
    
    [self deleteCarInfoFromServerWithCarId:[[self.ShopCartlist[sender.tag] objectForKey:@"carinfo"] objectForKey:@"car_id"] count:sender.tag];
}

//删除服务器商品
-(void)deleteCarInfoFromServerWithCarId:(NSString *)carID count:(NSInteger)count
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_cart.php"];
    NSDictionary *parameter = @{kInterfaceName:@"deletecart",
                                @"action":@"deleteByCar",
                                @"carId":carID,
                                @"userId":self.cartUserInfo.userID};
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([[responseObject  objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self.ShopCartlist removeObject:self.ShopCartlist[count]];
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"deleteCar error:%@",error);
    }];
    
}

#pragma mark - 提交订单
- (IBAction)ConfirmationOfOrder:(UIButton *)sender {
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    
    if (self.allGoodsArray.count != 0) {
        
        ConfirmationOrderController *coc = [[ConfirmationOrderController alloc]init];
        
        coc.shopCartlist = self.allGoodsArray;
        coc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:coc animated:YES];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"e温馨提示～" message:@"您还没有选择商品，请您选择商品后再试！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

#pragma mark -- 刷新购物车信息

-(void)refreshCartData
{
    
     [self performSelector:@selector(stopRefreshingCart) withObject:self afterDelay:5.0f];
    
    NSString *strUrl = kShoppingCart;
    AFHTTPRequestOperationManager  *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"interfaceName":@"getcart",
                                @"user_id":self.cartUserInfo.userID};
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.tableView.header endRefreshing];
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            [self.ShopCartlist removeAllObjects];
            NSArray *key = [[responseObject objectForKey:@"data"] allKeys];
            
            for (int i = 0; i < key.count; i++) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data"] objectForKey:key[i]]];
                
                [self.ShopCartlist addObject:dic];
            }
            

            [self.tableView reloadData];
        }else if ([[responseObject objectForKey:@"status"] isEqualToString:@"empty"]){
            
            
             [self.tableView.header endRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       
        [self.tableView.header endRefreshing];
        NSLog(@"错误 %@",error);
    }];

}


//停止刷新
-(void)stopRefreshingCart
{
    [self.tableView.header endRefreshing];
}

@end
