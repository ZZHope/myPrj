//
//  DBCommon.h
//  51CBY
//
//  Created by SJB on 15/1/13.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#ifndef _1CBY_DBCommon_h
#define _1CBY_DBCommon_h

#define kUserTable  @"cby_ios_client_userCommon"
#define kCarTable  @"cby_ios_client_carInfo"


//car table
#define CARI   @"i"    //i表示每条数据的id号
#define CAR_N   @"n"    //名字
#define CAR_P   @"p"    //对应i的id号 如果一致，该p的内容就是i下的子元素 0为车型品牌
#define IMAGE   @"img"//车型图片
#define CAR_S   @"s"    //车型的首字母
#define CAR_R   @"r"    //判断是否热门
#define DISP    @"disp" //0表示不显示该车型 1为显示该车型
#define ID      @"car_id"//选择完车型信息后生成该车型的唯一ID号
#define CAR_VERSION  @"version"
#define OrderID @"orderID"




//user Table

#define kSerialID  @"userSerialID"
#define kName @"name"
#define kCarID  @"carId"
#define kRegion @"region"
#define kPlate  @"plate"
#define kMobile @"mobile"
#define kBirthday @"birthday"
#define kSex    @"sex"
#define kAddress @"address"
#define kEmail  @"email"
#define kBrand  @"brand"
#define kModel  @"model"
#define kDischage @"discharge"
#define kYearTime @"yearTime"
#define kcarInfo_version @"carInfo_version"
#define kServiceTime  @"serviceTime"


/*CREATE TABLE "cby_ios_client_userCommon" (userSerialID varchar PRIMARY KEY,region varchar,plate varchar,name varchar,mobile varchar,birthday date,sex integer,address varchar,email varchar,brand varchar,model varchar,discharge varchar,yearTime varchar,"carInfo_version" varchar)*/



#endif
