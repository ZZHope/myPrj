//
//  CbyUserSingleton.h
//  51CBY
//
//  Created by SJB on 15/2/7.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CbyUserSingleton : NSObject

@property(nonatomic, copy) NSString *phoneNum;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, assign) BOOL isLogin;

//订单页面的信息

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *province;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *street;
@property(nonatomic, copy) NSString *provinceID;
@property(nonatomic, copy) NSString *cityID;
@property(nonatomic, copy) NSString *streetID;
@property(nonatomic, copy) NSString *serviceDate;
@property(nonatomic, copy) NSString *hourTime;
@property(nonatomic, copy) NSString *detailAddress;


//评分页面
@property(nonatomic, copy) NSString *carAge;
@property(nonatomic, copy) NSString *carJurney;
@property(nonatomic, copy) NSString *carCare;
@property(nonatomic, copy) NSString *carUnfrozen;
@property(nonatomic, copy) NSString *carPower;
@property(nonatomic, copy) NSString *carLine;
@property(nonatomic, copy) NSString *carTire;
@property(nonatomic, copy) NSString *carRain;
@property(nonatomic, copy) NSString *carEngin;
@property(nonatomic, copy) NSString *carRepair;

//车型信息
@property(nonatomic, copy) NSString *brand;
@property(nonatomic, copy) NSString *brandID;
@property(nonatomic, copy) NSString *model;
@property(nonatomic, copy) NSString *modelID;
@property(nonatomic, copy) NSString *discharge;
@property(nonatomic, copy) NSString *dischargeID;
@property(nonatomic, copy) NSString *boughtYear;
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *carID;


//加油优惠
@property(nonatomic, copy) NSString *oilHistoryTime;
@property(nonatomic, copy) NSString *ticketHistoryTime;

//收货地址信息
@property(nonatomic, copy) NSString *addressName; //收货人姓名
@property(nonatomic, copy) NSString *addressPhoneNum; //收货人电话



+(CbyUserSingleton *)shareUserSingleton;

@end
