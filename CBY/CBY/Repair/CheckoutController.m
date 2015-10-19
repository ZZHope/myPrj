//
//  CheckoutController.m
//  51CBY
//
//  Created by SJB on 15/1/4.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "CheckoutController.h"
#import "ShoppingCarController.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderViewController.h"

#import "AFNetworking.h"
#import "AFNCommon.h"
#import "CbyUserSingleton.h"


@interface CheckoutController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) NSMutableArray *tempArr;
@property (weak, nonatomic) IBOutlet UIButton *PayButton;
@property (weak, nonatomic) IBOutlet UILabel *PriceOrder;

@property (copy, nonatomic)NSString *privateKey;//支付宝私钥，从服务器请求
@property (copy, nonatomic)NSString *partner;
@property (copy, nonatomic)NSString *seller;
@end

int tempflag = 0;

@implementation CheckoutController
-(void)navigation
{
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    textlabel.text = @"支付方式";
    textlabel.font = [UIFont boldSystemFontOfSize:20];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = textlabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigation];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tempArr = [NSMutableArray array];
    [self.tempArr addObject:@"0"];
    [self.tempArr addObject:@"0"];
    [self.tempArr addObject:@"0"];
    
    self.PriceOrder.text = self.finalPrice;
    
    [self.PayButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    

    
}

#pragma mark -
#pragma mark   ==============产生随机订单号==============

//- (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand((int)time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}



#pragma mark =============选择支付方式================


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return 1;
       
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    //给Cell的右视图增加一个button
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    UIImage *image = [UIImage imageNamed:@"不选中"];
    [btn setImage:image forState:UIControlStateNormal];
    
    btn.tag = indexPath.section;
    [btn addTarget:self action:@selector(clickChangeButtonImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = btn;
    
    if (indexPath.section == 0 ) {
        cell.textLabel.text = @"支付宝支付";
        cell.imageView.image = [UIImage imageNamed:@"alipay"];
    }else if (indexPath.section == 1 ) {
        cell.textLabel.text = @"货到现金支付";
        cell.imageView.image = [UIImage imageNamed:@"货到付款"];
    }else {
        
         cell.textLabel.text = @"货到POS机支付";
        cell.imageView.image = [UIImage imageNamed:@"pos机"];
    }
   
    
    if ([self.tempArr[indexPath.section] isEqualToString:@"0"]) {
        [btn setImage:[UIImage imageNamed:@"不选中"] forState:UIControlStateNormal];
    }else {
        [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

-(void)clickChangeButtonImage:(UIButton *)sender
{
    self.PayButton.enabled = YES;
    self.PayButton.backgroundColor = [UIColor redColor];
    [self.tempArr replaceObjectAtIndex:tempflag withObject:@"0"];
    
    self.button = sender;

    [self.tempArr replaceObjectAtIndex:sender.tag withObject:@"1"];
    tempflag = (int)sender.tag;
    [self.tableView reloadData];
    

}



#pragma mark =====取消选中Cell的高亮状态
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark -- 支付
- (void)pay
{
    if (tempflag == 0) {
        
        [self getPrivateInfo];
    }else{
        
        [self directPayMoney];
    }
    
}

//支付宝支付
-(void)aliPayEvent
{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = self.partner; //@"2088611883253191";
    NSString *seller = self.seller;//@"zhuyafu@jbridge-g.com";
    NSString *privateKey = self.privateKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络不给力，请稍后再试"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    Order *order = [[Order alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.orderCode;
    
    order.productName = @"保养服务";
    order.productDescription = self.orderDescription;
    order.amount = self.finalPrice;
    order.notifyURL = kBaseUrl;// https://192.168.0.123/PHP-UTF-8/notity_url.php  notify_url=http://www.xxx.com/notify_alipay.asp 注意：www.XXX.com是您网站的域名，也可以用ip地址代替
    order.service = @"mobile.securitypay.pay";
    
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"51CBY";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            /*返回的格式
             {
             memo = "";
             result = "";
             resultStatus = 6001;//9000-订单成功，8000-正在处理， 4000 - 订单支付失败， 6001 - 用户中途取消， 6002-网络连接中断
             }
             */
            
            if ([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"]) {
                
                [self payStatusInfoWithStatus:2 paidMoney:self.finalPrice];
            }else{
                [self payStatusInfoWithStatus:0 paidMoney:@"0"];
            }
        }];
    }

}

//货到付款
-(void)directPayMoney
{
  
    self.PayButton.enabled = NO;
    self.PayButton.backgroundColor = [UIColor lightGrayColor];
    [self payStatusInfoWithStatus:0 paidMoney:@"0"];
}

#pragma mark-- 获取私钥和账户信息
-(void)getPrivateInfo
{
    
    
  
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_orderPay.php"];
    NSDictionary *parameter = @{kInterfaceName:@"getKey"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            self.privateKey = [[responseObject objectForKey:@"data"] objectForKey:@"key"];
            self.seller = [[responseObject objectForKey:@"data"]objectForKey:@"seller"];
            self.partner = [[responseObject objectForKey:@"data"] objectForKey:@"partner"];
            [self aliPayEvent];
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
}

//提交支付状态

-(void)payStatusInfoWithStatus:(int)status paidMoney:(NSString *)money
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_orderPay.php"];
    NSDictionary *parameter = @{kInterfaceName:@"putPay",
                                @"orderId":self.orderCode,
                                @"payStatus":[NSNumber numberWithInt:status],
                                @"moneyPaid":money};
    
    [manager POST:strUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
  
        if ([CbyUserSingleton shareUserSingleton].isLogin) {
            OrderViewController *orderVC = [[OrderViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];

        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"订单提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"pay status eror:%@",error);
    }];
    
}

@end
