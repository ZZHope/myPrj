//
//  51cbyDataBaseManager.h
//  51CBY
//
//  Created by SJB on 15/1/13.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FMDatabase.h"


#define kDataBaseName  @"51cby"

/*表名字宏定义*/


@interface CbyDataBaseManager : NSObject

{
    NSString *_dbPath;
}

@property(nonatomic, strong) FMDatabase *cbyDB;

//通过单利创建数据库
+(instancetype)shareInstance;

//创建表
-(void)creatTable:(NSString *)tableName;

//保存车信息
-(void)saveCarInfoToDB:(NSString *)tableName withColumns:(NSDictionary *)dictionary;
-(void)saveCarVersionToDB:(NSString *)tableName withColumns:(NSString *)str;


//从数据库取出信息
//取出用户信息
//-(NSArray *)userInfoQueryFromDB:(NSString *)tableName withColumn:(NSDictionary *)dictionary;


/*车信息选择*/
//取出车信息
-(NSArray *)carInfoQueryFromDB:(NSString *)tableName withColumn:(NSDictionary *)dictionary;

//取出车品牌信息
-(NSArray *)carBrandQueryFromDB:(NSString *)tableName;
//取出车型信息
-(NSArray *)carModelQueryFromDB:(NSString *)tableName withPID:(NSString *)str;
//取出排量
-(NSArray *)carDisChargeQueryFromDB:(NSString *)tableName withPID:(NSString *)str;
//取出年份
-(NSArray *)carYearQueryFromDB:(NSString *)tableName withPID:(NSString *)str;
//取出热门车型
-(NSArray *)carPopularQueryFromDB:(NSString *)tableName;


//删除缓存
-(void)deleteCacheFromDB;

//关闭数据库
-(void)close;

@end
