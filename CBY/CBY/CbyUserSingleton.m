//
//  CbyUserSingleton.m
//  51CBY
//
//  Created by SJB on 15/2/7.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "CbyUserSingleton.h"

@implementation CbyUserSingleton
static CbyUserSingleton *userInfo;

+(id)allocWithZone:(struct _NSZone *)zone
{
    static CbyUserSingleton *userInfo;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
       
        userInfo = [super allocWithZone:zone];
    });
    
    return userInfo;
}


+(CbyUserSingleton *)shareUserSingleton
{
    if (!userInfo) {
        userInfo = [[CbyUserSingleton alloc]init];
    }
    return userInfo;
}

-(id)init
{
    self = [super init];
    if (self) {
        
        //个人信息
        [self initWithPhoneNum:@"" userID:@"0" isLogin:NO userName:@"" addressName:@"" addressPhoneNum:@"" province:@"" city:@"" street:@"" provinceID:@"" cityID:@"" streetID:@"" serviceDate:@"" hourTime:@"" detailAddress:@"" oilHistoryTime:@"" ticketHistoryTime:@""];
        //车况信息
        [self initWithcarAge:@"" carJurney:@"" carCare:@"" carUnfrozen:@"" carPower:@"" carLine:@"" carTire:@"" carRain:@"" carEngin:@"" carRepair:@""];
        
        //车型信息
        [self initWithBrand:@"" brandID:@"" model:@"" modelID:@"" dischage:@"" dischargeID:@"" boughtYear:@"" imageName:@"" carID:@""];
    }
    return self;
    
   }

//便利初始化个人信息
-(void)initWithPhoneNum:(NSString *)phoneNum
                 userID:(NSString *)userID
                isLogin:(BOOL)isLogin
               userName:(NSString *)userName
            addressName:(NSString *)addressName
        addressPhoneNum:(NSString *)addressPhoneNum
               province:(NSString *)province
                   city:(NSString *)city
                 street:(NSString *)street
             provinceID:(NSString *)provinceID
                 cityID:(NSString *)cityID
               streetID:(NSString *)streetID
            serviceDate:(NSString *)serviceDate
               hourTime:(NSString *)hourTime
          detailAddress:(NSString *)detailAddress
         oilHistoryTime:(NSString *)oilHistoryTime
      ticketHistoryTime:(NSString *)ticketHistoryTime

{
    _phoneNum = [[NSString alloc] initWithString:phoneNum];
    _userID = [[NSString alloc]initWithString:userID];
    _userName = [[NSString alloc]initWithString:userName];
    _addressName = [[NSString alloc] initWithString:addressName];
    _addressPhoneNum = [[NSString alloc] initWithString:addressPhoneNum];
    _province = [[NSString alloc]initWithString:province];
    _city = [[NSString alloc]initWithString:city];
    _street = [[NSString alloc]initWithString:street];
    _provinceID = [[NSString alloc]initWithString:provinceID];
    _cityID = [[NSString alloc]initWithString:cityID];
    _streetID = [[NSString alloc]initWithString:streetID];
    _serviceDate = [[NSString alloc] initWithString:serviceDate];
    _hourTime = [[NSString alloc]initWithString:hourTime];
    _detailAddress = [[NSString alloc]initWithString:detailAddress];
    _oilHistoryTime = [[NSString alloc]initWithString:oilHistoryTime];
    _ticketHistoryTime = [[NSString alloc] initWithString:ticketHistoryTime];
}


//车况评分
-(void)initWithcarAge:(NSString *)carAge
            carJurney:(NSString *)carJurney
              carCare:(NSString *)carCare
          carUnfrozen:(NSString *)unfrozen
             carPower:(NSString *)power
              carLine:(NSString *)line
              carTire:(NSString *)carTire
              carRain:(NSString *)carRain
             carEngin:(NSString *)carEngin
            carRepair:(NSString *)carRepair
{
    _carAge = [[NSString alloc]initWithString:carAge];
    _carJurney = [[NSString alloc]initWithString:carJurney];
    _carCare = [[NSString alloc]initWithString:carCare];
    _carUnfrozen = [[NSString alloc]initWithString:unfrozen];
    _carPower = [[NSString alloc]initWithString:power];
    _carLine = [[NSString alloc]initWithString:line];
    _carTire = [[NSString alloc]initWithString:carTire];
    _carRain = [[NSString alloc]initWithString:carRain];
    _carEngin = [[NSString alloc]initWithString:carEngin];
    _carRepair = [[NSString alloc] initWithString:carRepair];
}


//车型信息
-(void)initWithBrand:(NSString *)brand
             brandID:(NSString *)brandID
               model:(NSString *)model
             modelID:(NSString *)modelID
            dischage:(NSString *)discharge
         dischargeID:(NSString *)dischargeID
          boughtYear:(NSString *)boughtYear
           imageName:(NSString *)imageName
               carID:(NSString *)carID
{
    _brand = [[NSString alloc]initWithString:brand];
    _brandID = [[NSString alloc] initWithString:brandID];
    _model = [[NSString alloc]initWithString:model];
    _modelID = [[NSString alloc ]initWithString:modelID];
    _discharge = [[NSString alloc] initWithString:discharge];
    _dischargeID = [[NSString alloc] initWithString:dischargeID];
    _boughtYear = [[NSString alloc] initWithString:boughtYear];
    _imageName = [[NSString alloc] initWithString:imageName];
    _carID = [[NSString alloc] initWithString:carID];
}


-(id)copy
{
    return self;
}

@end
