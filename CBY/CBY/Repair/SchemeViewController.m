//
//  SchemeViewController.m
//  51CBY
//
//  Created by SJB on 15/4/1.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "SchemeViewController.h"
#import "DirectAddressViewController.h"
#import "ShoppingCarController.h"
#import "CustomButton.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "ConfirmationOrderController.h"
#import "AFNCommon.h"
#import "CbyUserSingleton.h"
#import "SchemeNewCell.h"
#import "UIImageView+WebCache.h"
#import "serviceSchemeCell.h"
#import "ChangeJYViewController.h"

#define kWidth  self.view.frame.size.width
#define kHeight self.view.frame.size.height

#define kMargin  (kWidth-4*77)*0.2



@interface SchemeViewController ()

//单例
@property (strong, nonatomic) CbyUserSingleton *schemInfo;

@property (strong, nonatomic) UITableView *tableView;

//UI
@property(strong, nonatomic) UILabel *priceLabel;

@property(strong, nonatomic) NSMutableArray *flagArr;

//数据存储
@property(strong, nonatomic) NSMutableArray *goodsArrM;
@property(strong, nonatomic) NSMutableDictionary *serviceDic4Ever;

//商品
@property(nonatomic, strong) NSMutableArray *careGoodsArrM;
@property(nonatomic, strong) NSMutableDictionary *serviceDicM;

@property(nonatomic, strong) NSMutableArray *commitArrM;

//取出要提交的服务和商品
@property(strong, nonatomic) NSMutableArray *goodsIDArrM;



@end


@implementation SchemeViewController

- (void)viewDidLoad {
    
    //右视图
    
    
    UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [userBtn setTitle:@"自备材料" forState:UIControlStateNormal];
    userBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [userBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userBtn addTarget:self action:@selector(prepareGoodsOwn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:userBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.title = @"我要车保养";
    //titleLabel
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font= [UIFont boldSystemFontOfSize:20.0f];
    self.navigationItem.titleView = titleLabel;
    
    [super viewDidLoad];
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-80-49) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //底部view
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-80-49, kWidth, 80)];
    bottomView.backgroundColor = [UIColor colorWithRed:217/255.0 green:215/255.0 blue:215/255.0 alpha:1.0f];
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 160, 50)];
    self.priceLabel.text = @"总价:￥";
    self.priceLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.priceLabel.textColor = [UIColor redColor];
    [bottomView addSubview:self.priceLabel];
    
    UIButton *commitOrder = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-110, 5, 90, 50)];
    commitOrder.backgroundColor = [UIColor redColor];
    [commitOrder setTitle:@"确认订单" forState:UIControlStateNormal];
    [commitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitOrder.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [commitOrder addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchUpInside];
    commitOrder.layer.cornerRadius = 3.0f;
    commitOrder.clipsToBounds = YES;
    [bottomView addSubview:commitOrder];
    
    [self.view addSubview:bottomView];
    //单例
    _schemInfo = [CbyUserSingleton shareUserSingleton];
    
    
    //数据源
    _goodsArrM = [NSMutableArray array];//存放商品
    _serviceDic4Ever = [NSMutableDictionary dictionary]; //存放可选的服务
    
    _careGoodsArrM = [NSMutableArray array];
    _serviceDicM = [NSMutableDictionary dictionary];
    _goodsIDArrM = [NSMutableArray array];
    _commitArrM = [NSMutableArray array];//提交的时候又要分开提交
    
    
    _flagArr = [NSMutableArray array];

    
    for (int i=0; i<3; i++) {
        [self.flagArr addObject:@NO];
        
    }
    [self.flagArr replaceObjectAtIndex:0 withObject:@YES];
    
    //下拉刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadServiceData)];
    
    [self.tableView.header beginRefreshing];

}


-(void)navigation
{
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    textlabel.text = self.carString;
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
}

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    //显示价格，实时更新
    [self caculatePrice];
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.careGoodsArrM.count;
    }else{
        return self.serviceDicM.count;//服务是一个的情况，否则返回不只是这个值，与甲醛和PM2.5无关
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identifier = @"SchemeCellNew";
    static NSString *identifier2 = @"cell2";
    if (indexPath.section == 0) {
        SchemeNewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (nil == cell) {
            NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:@"SchemeNewCell"owner:self options:nil];
            cell = cellArr[0];
        }
        
        cell.nameLabel.text = [self.careGoodsArrM[indexPath.row]  objectForKey:@"catName"];
       
        
        if ([self.careGoodsArrM[indexPath.row] objectForKey:@"goods_id"] != nil) {
            [cell.schemeImgView sd_setImageWithURL:[self.careGoodsArrM[indexPath.row] objectForKey:@"original_img"] placeholderImage:[UIImage imageNamed:@"holder"] options:SDWebImageLowPriority];
            
        }else{
            cell.schemeImgView.image = [UIImage imageNamed:@"holder"];
            cell.changeBtn.enabled = NO;
        }
        //cell.schemeImgView
        
        if ( [self.careGoodsArrM[indexPath.row] objectForKey:@"goods_id"] && ![[self.careGoodsArrM[indexPath.row] objectForKey:@"goods_weight"] isEqualToString:@"0"]) {
            cell.detailName.text = [NSString stringWithFormat:@"%@(%dL)",[self.careGoodsArrM[indexPath.row]  objectForKey:@"goods_short_name"],[[self.careGoodsArrM[indexPath.row] objectForKey:@"goods_weight"] intValue]*[[self.careGoodsArrM[indexPath.row] objectForKey:@"number"] intValue]];
        }else{
            cell.detailName.text = [self.careGoodsArrM[indexPath.row] objectForKey:@"goods_short_name"];
        }
       
        if ([self.careGoodsArrM[indexPath.row] objectForKey:@"goods_id"]&&[[self.careGoodsArrM[indexPath.row] objectForKey:@"catKeywords"] isEqualToString:@"SID_JY"]) {
            [cell.changeBtn setTitle:@"更换" forState:UIControlStateNormal];
            [cell.changeBtn setImage:nil forState:UIControlStateNormal];
            cell.changeBtn.tag = 3001;

        }
        
        if ([[self.careGoodsArrM[indexPath.row] objectForKey:@"catKeywords"] isEqualToString:@"SID_KL"]){
            cell.changeBtn.tag = 3002;
            
            if ([[self.careGoodsArrM[indexPath.row] objectForKey:@"cat_id"]isEqualToString:@"34"]&&[self.careGoodsArrM[indexPath.row] objectForKey:@"goods_id"]){
                
                [cell.changeBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                [cell.changeBtn setTitle:@"" forState:UIControlStateNormal];
                
            }else{
            
                if ([self.careGoodsArrM[indexPath.row] objectForKey:@"goods_id"] == nil) {
                    [cell.changeBtn setImage:nil forState:UIControlStateNormal];
                    [cell.changeBtn setTitle:@"" forState:UIControlStateNormal];
                    cell.changeBtn.enabled = NO;

                }else{
                   [cell.changeBtn setImage:[UIImage imageNamed:@"不选中"] forState:UIControlStateNormal];
                }
                
            }
        }
        
        if ([[self.careGoodsArrM[indexPath.row] objectForKey:@"catKeywords"] isEqualToString:@"SID_KTL"]) {
            cell.changeBtn.tag = 3003;
            
            if ([[self.careGoodsArrM[indexPath.row] objectForKey:@"cat_id"]isEqualToString:@"29"]&&[self.careGoodsArrM[indexPath.row] objectForKey:@"goods_id"]) {
                
                [cell.changeBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                [cell.changeBtn setTitle:@"" forState:UIControlStateNormal];
                
            }else{
                if ([self.careGoodsArrM[indexPath.row] objectForKey:@"goods_id"] == nil) {
                    [cell.changeBtn setImage:nil forState:UIControlStateNormal];
                    [cell.changeBtn setTitle:@"" forState:UIControlStateNormal];
                    cell.changeBtn.enabled = NO;
                    
                }else{
                    [cell.changeBtn setImage:[UIImage imageNamed:@"不选中"] forState:UIControlStateNormal];
                }
                

               
            }

        }
        if ([[self.careGoodsArrM[indexPath.row] objectForKey:@"catKeywords"] isEqualToString:@"SID_JL"]) {
            [cell.changeBtn setImage:nil forState:UIControlStateNormal];
            [cell.changeBtn setTitle:@"" forState:UIControlStateNormal];
            cell.changeBtn.enabled = NO;
        }
        [cell.changeBtn addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        serviceSchemeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"serviceSchemeCell" owner:self options:nil];
            cell =  cellArr[0];
        }
        
        //取出所有的服务

        NSMutableArray *tempArr= [NSMutableArray array];
        for (int i = 0; i< self.serviceDicM.allKeys.count; i++) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[[self.serviceDicM objectForKey:self.serviceDicM.allKeys[i]]objectForKey:@"catName"] forKey:@"catName"];
            [dic setObject:[[self.serviceDicM objectForKey:self.serviceDicM.allKeys[i]] objectForKey:@"goods_short_name"] forKey:@"goodsName"];
         
            [tempArr addObject:dic];
            
        }
        
        cell.serviceName.text = [tempArr[indexPath.row] objectForKey:@"catName"];
        cell.serviceDetail.text = [tempArr[indexPath.row] objectForKey:@"goodsName"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }
   
}


//设置Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100.0f;
    }else{
       return 80;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 160.0f;
    }else{
        return 2.0f;
    }
    
}





-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160)];
    view.backgroundColor = [UIColor colorWithRed:217/255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
    UIButton *btnCommon;
    UIButton *btnClean;
    UIButton *btnPM;

    if (![self.flagArr[0] boolValue] ) {
         btnCommon = [self btnWithFrame:CGRectMake(kMargin, 10, 77, 80) imgName:@"常规保养" title:@"常规保养" tag:1001];
       
    }else{
        btnCommon = [self btnWithFrame:CGRectMake(kMargin, 10, 77, 80) imgName:@"常规保养确认" title:@"常规保养" tag:1001];
     
        btnCommon.layer.borderColor = [UIColor orangeColor].CGColor;
    }
   
    if (![self.flagArr[1] boolValue]) {
         btnClean = [self btnWithFrame:CGRectMake(CGRectGetMaxX(btnCommon.frame)+kMargin, 10, 77, 80) imgName:@"甲醛清除" title:@"甲醛清除" tag:1002];
      
    }else{
        btnClean = [self btnWithFrame:CGRectMake(CGRectGetMaxX(btnCommon.frame)+kMargin, 10, 77, 80) imgName:@"甲醛清除确认" title:@"甲醛清除" tag:1002];
        btnClean.layer.borderColor = [UIColor orangeColor].CGColor;
      
    }
    if ( ![self.flagArr[2] boolValue]) {
        
        btnPM = [self btnWithFrame:CGRectMake(CGRectGetMaxX(btnClean.frame)+kMargin, 10, 77, 80) imgName:@"防护" title:@"PM2.5防护" tag:1003];
    }else{
        btnPM = [self btnWithFrame:CGRectMake(CGRectGetMaxX(btnClean.frame)+kMargin, 10, 77, 80) imgName:@"PM防护确认" title:@"PM2.5防护" tag:1003];
        btnPM.layer.borderColor = [UIColor orangeColor].CGColor;
    }
   
    UIButton *btn56 = [self btnWithFrame:CGRectMake(CGRectGetMaxX(btnPM.frame)+kMargin, 10, 76.5, 80) imgName:@"车检" title:@"56项车检" tag:1004];
    btn56.layer.borderColor = [UIColor orangeColor].CGColor;
    [view addSubview:btnClean];
    [view addSubview:btnPM];
    [view addSubview:btn56];
    [view addSubview:btnCommon];
    
    
    //分割线
    UIView *breakLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btnClean.frame)+10, kWidth, 15)];
    breakLine.backgroundColor = [UIColor whiteColor];
    
    //label
    UILabel *goodLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(breakLine.frame)+5, 60, 40)];
    goodLabel.text = @"商 品";
    goodLabel.font = [UIFont systemFontOfSize:20.0f];
    goodLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(goodLabel.frame)+80, CGRectGetMaxY(breakLine.frame)+5, 60, 40)];
    detailLabel.text = @"明 细";
    detailLabel.font = [UIFont systemFontOfSize:20.0f];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:breakLine];
    [view addSubview:goodLabel];
    [view addSubview:detailLabel];
    
    return view;
    }else{
        return nil;
    }
}

//------------------------------------分割线--------------------------------------

#pragma mark - 切换服务数据源（4个模块）
-(void)changeGoodsInfo:(UIButton *)sender
{

    if (sender.tag != 1004) {
        if ([self.flagArr[sender.tag-1001] boolValue]) {
            [self.flagArr replaceObjectAtIndex:(sender.tag-1001) withObject:@NO];
            if (sender.tag == 1001) {
                if ([self.serviceDicM.allKeys containsObject:@"servicesInfo"]) {
                    [self.serviceDicM removeObjectForKey:@"servicesInfo"];
                    [self.careGoodsArrM removeAllObjects];
                }
 
            }else if(sender.tag == 1002){
                
                if ([self.serviceDicM.allKeys containsObject:@"jiaquan"]) {
                    [self.serviceDicM removeObjectForKey:@"jiaquan"];
                }

            }else{
                if ([self.serviceDicM.allKeys containsObject:@"pm25"]) {
                    [self.serviceDicM removeObjectForKey:@"pm25"];
                }
            }
            
        }else{
            [self.flagArr replaceObjectAtIndex:(sender.tag-1001) withObject:@YES];
            if (self.serviceDic4Ever.count) {
                
                if (sender.tag == 1001) {
                    
                    [self.serviceDicM setObject:[self.serviceDic4Ever objectForKey:@"servicesInfo"] forKey:@"servicesInfo"];
                    for (NSDictionary *dic in self.goodsArrM) {
                        [self.careGoodsArrM addObject:dic];
                    }
                    
                }else if (sender.tag == 1002){
                    [self.serviceDicM setObject:[self.serviceDic4Ever objectForKey:@"jiaquan"]  forKey:@"jiaquan"];
                }else{
                    
                    [self.serviceDicM setObject:[self.serviceDic4Ever objectForKey:@"pm25"]  forKey:@"pm25"];
                }
                

            }else{
                [self.tableView.header beginRefreshing];
            }
            
        }
        
        [self.tableView reloadData];

    }else{
        return;
    }
}


-(void)changeStatus:(UIButton *)sender
{
    switch (sender.tag) {
        case 3001://更换机油
            
        {
            ChangeJYViewController *JYVC = [[ChangeJYViewController alloc] init];
            JYVC.carIdJY = self.schemInfo.carID;
            NSString *strJY;
            for (NSDictionary *dic in self.careGoodsArrM) {
                if ([[dic objectForKey:@"catKeywords"] isEqualToString:@"SID_JY"]) {
                   strJY = [dic objectForKey:@"goods_weight"];
                }
            }
            JYVC.weightJY = strJY;
            
            [JYVC changeJYInfo:^(NSDictionary *dic) {
                //合并显示
                
                
                for (int i=0 ; i<self.careGoodsArrM.count; i++) {
                    
                    if ([[self.careGoodsArrM[i] objectForKey:@"catKeywords"] isEqualToString:@"SID_JY"]) {
                        
                        NSMutableDictionary *dicM =[NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"together"]];
                        [dicM setObject:@"SID_JY" forKey:@"catKeywords"];
                        [dicM setObject:[self.careGoodsArrM[i] objectForKey:@"catName"] forKey:@"catName"];
                        [dicM setObject:[[dic objectForKey:@"together"] objectForKey:@"shop_price"] forKey:@"tradePrice"];
                        [dicM setObject:[self.careGoodsArrM[i] objectForKey:@"number"] forKey:@"number"];
                        [dicM setObject:[self.careGoodsArrM[i] objectForKey:@"goods_weight"] forKey:@"goods_weight"];
                        
                        [self.careGoodsArrM replaceObjectAtIndex:i withObject:dicM];
                    }

                }
                
                
                //分离提交
                for (NSString *key in [[dic objectForKey:@"depart"] allKeys]) {
                    for (int i=0;i<self.careGoodsArrM.count;i++) {
                        if ([[self.commitArrM[i] objectForKey:@"catKeywords"] isEqualToString:@"SID_JY"]&&[key isEqualToString: [NSString stringWithFormat:@"%@L",[self.commitArrM[i] objectForKey:@"goods_weight"]]]) {
                            
                            NSMutableDictionary *dicMDepart =[NSMutableDictionary dictionaryWithDictionary:[[dic objectForKey:@"depart"] objectForKey:key]];
                            [dicMDepart setObject:@"SID_JY" forKey:@"catKeywords"];
                            [dicMDepart setObject:[dicMDepart objectForKey:@"shop_price"] forKey:@"tradePrice"];
                            [dicMDepart setObject:[self.commitArrM[i] objectForKey:@"number"] forKey:@"number"];
                            [self.commitArrM replaceObjectAtIndex:i withObject:dicMDepart];
                        }
                    }
                    
                }
        
            
                [self.tableView reloadData];
                
            }];
            [self.navigationController pushViewController:JYVC animated:YES];
        }
            
            break;
        case 3002://选择空滤
        {
           
            for (int i = 0;i<self.careGoodsArrM.count;i++) {
                if ([[self.careGoodsArrM[i] objectForKey:@"catKeywords"]isEqualToString:@"SID_KL"]) {
                    
                     NSMutableDictionary *dicKL = [NSMutableDictionary dictionaryWithDictionary:self.careGoodsArrM[i]];
                    if ([[dicKL objectForKey:@"cat_id"] isEqualToString:@"34"]) {
                        [dicKL setObject:@"0" forKey:@"cat_id"];
                    }else{
                        [dicKL setObject:@"34" forKey:@"cat_id"];
                    }
                    
                    [self.careGoodsArrM replaceObjectAtIndex:i withObject:dicKL];
                    [self.tableView reloadData];
                    return;
                }
            }
        }
            
            break;

        case 3003://选择空调滤
            
        {
            for (int i = 0;i<self.careGoodsArrM.count;i++) {
                if ([[self.careGoodsArrM[i] objectForKey:@"catKeywords"]isEqualToString:@"SID_KTL"]) {
                    
                    NSMutableDictionary *dicKL = [NSMutableDictionary dictionaryWithDictionary:self.careGoodsArrM[i]];
                    if ([[dicKL objectForKey:@"cat_id"] isEqualToString:@"29"]) {
                        [dicKL setObject:@"0" forKey:@"cat_id"];
                    }else{
                        [dicKL setObject:@"29" forKey:@"cat_id"];
                    }
                    
                    [self.careGoodsArrM replaceObjectAtIndex:i withObject:dicKL];
                    [self.tableView reloadData];
                    return;
                }
            }

        }
            
            break;

            
        default:
            break;
    }
}


#pragma mark -- 数据
-(void)loadServiceData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getservicegoods",
                                @"car_id":self.schemInfo.carID,
                                @"serviceid":@"SID_JY,SID_JL,SID_KL,SID_KTL"
                                };
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];
        
       
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            
            //避免重复添加
            [self.serviceDic4Ever removeAllObjects];
            [self.careGoodsArrM removeAllObjects];
            [self.goodsArrM removeAllObjects];
            [self.serviceDicM removeAllObjects];
            [self.commitArrM removeAllObjects];
            
            NSMutableArray *JYArrM = [NSMutableArray array];
            for (NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"goodsInfo"]) {
                
                if ([[dic  objectForKey:@"catKeywords"] isEqualToString:@"SID_JY"]) {
                    
                    [JYArrM addObject:dic];

                    
                }else{
                    
                    [self.careGoodsArrM addObject:dic];
                    [self.goodsArrM addObject:dic];
                }
   
                [self.commitArrM addObject:dic];
            }
            
            int JYNum = 0;
            float JYPrice = 0.00f;
            NSMutableDictionary *dicMJY = [NSMutableDictionary dictionaryWithDictionary:JYArrM[0]];
            
            for (NSDictionary *dicJY in JYArrM) {
                JYNum += [[dicJY objectForKey:@"goods_weight"]intValue]*[[dicJY objectForKey:@"number"]intValue];
                JYPrice += [[dicJY objectForKey:@"tradePrice"] floatValue]*[[dicJY objectForKey:@"number"] intValue];
                
            }
            
            [dicMJY setObject:[NSString stringWithFormat:@"%d",JYNum] forKey:@"goods_weight"];
            [dicMJY setObject:[NSString stringWithFormat:@"%f",JYPrice] forKey:@"tradePrice"];
            [dicMJY setObject:@"1" forKey:@"number"];
            
            [self.careGoodsArrM insertObject:dicMJY atIndex:0];
            [self.goodsArrM insertObject:dicMJY atIndex:0];
            
            //服务
            
            [self.serviceDic4Ever setObject:[[responseObject objectForKey:@"data"] objectForKey:@"jiaquan"]forKey:@"jiaquan"];
            [self.serviceDic4Ever setObject:[[responseObject objectForKey:@"data"] objectForKey:@"pm25"] forKey:@"pm25"];
            [self.serviceDic4Ever setObject:[[responseObject objectForKey:@"data"] objectForKey:@"servicesInfo"][0] forKey:@"servicesInfo"];//这个键的值是一个数组，与其他不一致，取值要注意
            [self.serviceDicM setObject:[[responseObject objectForKey:@"data"] objectForKey:@"servicesInfo"][0] forKey:@"servicesInfo"];
            
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.tableView.header endRefreshing];
        
        NSLog(@"error:%@",error);
        
    }];
}


#pragma mark - 封装的Button
-(UIButton *)btnWithFrame:(CGRect)frame imgName:(NSString *)imgName title:(NSString *)title tag:(NSInteger)tag
{
    
    UIImage *imgBtn = [UIImage imageNamed:imgName];
    
    CustomButton *addOilButton = [[CustomButton alloc]initWithFrame:frame];
    addOilButton.tag = tag;
    addOilButton.rateFloat = 0.70;
    [addOilButton setImage:imgBtn forState:UIControlStateNormal];
    [addOilButton setTitle:title forState:UIControlStateNormal];
    addOilButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    addOilButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addOilButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addOilButton.backgroundColor = [UIColor whiteColor];
    addOilButton.layer.borderColor = [UIColor whiteColor].CGColor;
    addOilButton.layer.borderWidth = 2.0f;
    [addOilButton addTarget:self action:@selector(changeGoodsInfo:) forControlEvents:UIControlEventTouchUpInside];
    return addOilButton;
    
}


#pragma mark -- 提交订单
-(void)commitOrder
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if (self.loopFlag == 1) {//未登录状态的提交流程
       //提交的商品数据
        NSMutableArray *paraArr = [NSMutableArray array];
        for (NSDictionary *tempDic in self.goodsIDArrM) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[tempDic objectForKey:@"goods_id"] forKey:@"goods_id"];
            [dic setObject:[tempDic objectForKey:@"number"] forKey:@"goods_number"];
            //[dic setObject:self.schemInfo.userID forKey:@"user_id"];
            [dic setObject:self.schemInfo.carID forKey:@"car_id"];
            [paraArr addObject:dic];
        }

        
        DirectAddressViewController *direcVC = [[DirectAddressViewController alloc]init];
        direcVC.priceLabelText = self.priceLabel.text;
        direcVC.commitGoods= paraArr;
        [self.navigationController pushViewController:direcVC animated:YES];
    }else{
        [self commitToShoppingCart];
    }
}

#pragma mark -- 计算价格
-(void)caculatePrice
{
    [self.goodsIDArrM removeAllObjects];
    float price = 0.00f;
    for (NSDictionary *dic in self.careGoodsArrM) {
        
        price += [[dic objectForKey:@"tradePrice"] floatValue] * [[dic objectForKey:@"number"] intValue];
        if ([dic objectForKey:@"goods_id"]) {//goods_id不为0
            [self.goodsIDArrM addObject:@{@"goods_id":[dic objectForKey:@"goods_id"],@"catKeywords":[dic objectForKey:@"catKeywords"],@"tradePrice":[dic objectForKey:@"tradePrice"],@"number":[dic objectForKey:@"number"],}];
        }
        
        if ([[dic objectForKey:@"catKeywords"]isEqualToString:@"SID_KTL"] && ![[dic objectForKey:@"cat_id"] isEqualToString:@"29"]) {
            price -= [[dic objectForKey:@"tradePrice"] floatValue]* [[dic objectForKey:@"number"] intValue];
            [self.goodsIDArrM removeObject:@{@"goods_id":[dic objectForKey:@"goods_id"],@"catKeywords":[dic objectForKey:@"catKeywords"],@"tradePrice":[dic objectForKey:@"tradePrice"],@"number":[dic objectForKey:@"number"]}];
            
        }
        if ([[dic objectForKey:@"catKeywords"]isEqualToString:@"SID_KL"] && ![[dic objectForKey:@"cat_id"] isEqualToString:@"34"]) {
            price -= [[dic objectForKey:@"tradePrice"] floatValue] *[[dic objectForKey:@"number"] intValue];
            [self.goodsIDArrM removeObject:@{@"goods_id":[dic objectForKey:@"goods_id"],@"catKeywords":[dic objectForKey:@"catKeywords"],@"tradePrice":[dic objectForKey:@"tradePrice"],@"number":[dic objectForKey:@"number"]}];
            
        }
        
    }
    
    //服务的价格
    for (int i = 0; i< self.serviceDicM.allKeys.count; i++) {
    
        price += [[[self.serviceDicM objectForKey:self.serviceDicM.allKeys[i]]objectForKey:@"tradePrice"]floatValue];
        [self.goodsIDArrM addObject:@{@"goods_id":[[self.serviceDicM objectForKey:self.serviceDicM.allKeys[i]] objectForKey:@"goods_id"],@"catKeywords":@"service",@"tradePrice":[[self.serviceDicM objectForKey:self.serviceDicM.allKeys[i]] objectForKey:@"tradePrice"],@"number":@"1"}];
        
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"总价:￥%0.2f",price];
   
}



#pragma mark -- 提交购物车
-(void)commitToShoppingCart
{
    
  
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    //提交购物车
    NSArray *arrI= [NSArray arrayWithArray:self.goodsIDArrM];
    
    for (NSDictionary *dicTemp in arrI) {
        if ([[dicTemp objectForKey:@"catKeywords"] isEqualToString:@"SID_JY"]) {
           
            [self.goodsIDArrM removeObject:dicTemp];
        }
    }
    for (NSDictionary *dicOrigin in self.commitArrM) {
        if ([[dicOrigin objectForKey:@"catKeywords"] isEqualToString:@"SID_JY"]) {
            [self.goodsIDArrM addObject:dicOrigin];
        }
    }
    
    NSMutableArray *paraArr = [NSMutableArray array];
    for (NSDictionary *dicCommit in self.goodsIDArrM) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[dicCommit objectForKey:@"goods_id"] forKey:@"goods_id"];
        [dic setObject:[dicCommit objectForKey:@"number"] forKey:@"goods_number"];
        [dic setObject:self.schemInfo.userID forKey:@"user_id"];
        [dic setObject:self.schemInfo.carID forKey:@"car_id"];
        [paraArr addObject:dic];
    }

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_cart.php"];
    
    NSDictionary *parameter = @{kInterfaceName:@"putcart",
                                @"goods_info":paraArr};
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
  
    
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            ShoppingCarController *shopCartVC = [[ShoppingCarController alloc]init];
            [self.navigationController pushViewController:shopCartVC animated:YES];
            
        }
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"cart error:%@",error);
    }];
   
    
}

#pragma mark -- 自备材料
-(void)prepareGoodsOwn
{
    for (int i=0; i<self.flagArr.count; i++) {
        if ([self.flagArr[i] boolValue]) {
            [self.flagArr replaceObjectAtIndex:i withObject:@NO];
        }
    }
    [self.careGoodsArrM removeAllObjects];
    [self.serviceDicM removeAllObjects];
     [self.serviceDicM setObject:[self.serviceDic4Ever objectForKey:@"servicesInfo"] forKey:@"servicesInfo"];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
