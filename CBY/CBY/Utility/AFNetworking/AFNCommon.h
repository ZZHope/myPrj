//
//  AFNCommon.h
//  51CBY
//
//  Created by SJB on 15/1/30.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#ifndef _1CBY_AFNCommon_h
#define _1CBY_AFNCommon_h

//头文件
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"

//#define kBaseUrl  @"http://www.51cby.cn/api/app/"
#define kBaseUrl  @"http://192.168.0.123/cbynew/api/app/"
//#define kBaseUrl  @"http://192.168.0.115/51cby/api/app/"
#define kBasePubUrl @"http://www.51cby.cn/"  //更换机油的前缀

#define kBannerImageUrl  @"http://www.51cby.cn/images/banner/"
#define kInterfaceName @"interfaceName"
#define kUserID  @"user_id"

#define registerPhoneUrl  @"http://www.51cby.cn/ajax_mobile_check.php"
//#define registerPhoneUrl  @"http://192.168.0.123/cbynew/ajax_mobile_check.php"

//获取图片的地址
#define kImageUrl @"http://www.51cby.cn/%@"

//获取购物车信息
#define kShoppingCart [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_cart.php"]

//获取收获信息    服务日期    服务时间  获取所有服务 根据服务获取商品 私人定制请求地址
#define kShareUrl [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_service.php"]
//提交到购物车

#define kPutCart [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_cart.php"]

//提交订单

#define kOrderUrl [NSString stringWithFormat:@"%@%@",kBaseUrl,@"api_order.php"]
#endif
