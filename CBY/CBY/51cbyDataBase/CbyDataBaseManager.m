//
//  51cbyDataBaseManager.m
//  51CBY
//
//  Created by SJB on 15/1/13.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "CbyDataBaseManager.h"
#import "DBCommon.h"



static CbyDataBaseManager *cbyDBManager;

@interface CbyDataBaseManager()

@property(nonatomic, strong) NSMutableDictionary *dic4Data;

@end


@implementation CbyDataBaseManager

//通过单例，创建数据库管理

+(instancetype)shareInstance
{
    static dispatch_once_t  onceToken;
    
     //当第一个参数如果没有被初始过 则第二个参数(block)块将会被调用一次，反之，则代码将不会被调用
    //保证线程安全
    dispatch_once(&onceToken, ^{
        cbyDBManager = [[CbyDataBaseManager alloc]init];
    });
    return cbyDBManager;
}

-(id)init
{
    
    //初始化数据库
    if (self = [super init]) {
        
//        //数据库路径
        
        _dbPath = [self copyFileToDocument:@"cbyDB"];
        
        
        self.cbyDB = [FMDatabase databaseWithPath:_dbPath];
        
    [self.cbyDB open];
    }
    return self;
    
    
}

-(void)creatTable:(NSString *)tableName
{
    //创建表
    
    if ([self.cbyDB open]) {
        if ([tableName isEqualToString:kUserTable]) {
            //创建cby_ios_client_userCommon表
            NSString *sqlCreat = [NSString stringWithFormat:@"CREATE TABLE  IF NOT EXISTS '%@' (userSerialID INTEGER  PRIMARY KEY AUTOINCREMENT, region  VARCHAR,plate VARCHAR,name VARCHAR,mobile VARCHAR,birthday date,sex integer,address VARCHAR,email VARCHAR,brand VARCHAR,model VARCHAR,discharge VARCHAR,yearTime date,serviceTime VARCHAR,carInfo_version VARCHAR,carID VARCHAR)",kUserTable];
            [self.cbyDB executeUpdate:sqlCreat];

        }else{
            //创建cby_ios_client_carInfo表
            NSString *sqlCreatCarTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER  PRIMARY KEY AUTOINCREMENT, '%@' VARCHAR, '%@' VARCHAR, '%@' VARCHAR, '%@' VARCHAR, '%@' VARCHAR, '%@' INTEGER, '%@' INTEGER, '%@' TEXT,'%@' VARCHAR)", kCarTable,OrderID, CARI, CAR_N, CAR_P, IMAGE, CAR_S, CAR_R, DISP, ID,CAR_VERSION];
            
            [self.cbyDB executeUpdate:sqlCreatCarTable];
        }
    
    }
    

}


/*#define CARI   @"i"    //i表示每条数据的id号
 #define CAR_N   @"n"    //名字
 #define CAR_P   @"p"    //对应i的id号 如果一致，该p的内容就是i下的子元素 0为车型品牌
 #define IMAGE   @"img"//车型图片
 #define CAR_S   @"s"    //车型的首字母
 #define CAR_R   @"r"    //判断是否热门
 #define DISP    @"disp" //0表示不显示该车型 1为显示该车型
 #define ID      @"car_id"//选择完车型信息后生成该车型的唯一ID号
 #define CAR_VERSION  @"version"
 #define  OrderID @"orderID"
*/

//保存车信息
-(void)saveCarInfoToDB:(NSString *)tableName withColumns:(NSDictionary *)dictionary
{
    [self.cbyDB open];
    NSMutableString *insertSQL = [[NSMutableString alloc]initWithString:@"INSERT INTO "];
    [insertSQL appendString:tableName];
       if ([tableName isEqualToString:kCarTable]) {
            [insertSQL appendString:@ "(i,n,p,img,s,r,disp,car_id,version ) VALUES (?,?,?,?,?,?,?,?,?)"];
           
        
        BOOL isOK = [self.cbyDB executeUpdate:insertSQL,
                     [dictionary objectForKey:CARI],
                     [dictionary objectForKey:CAR_N],
                     [dictionary objectForKey:CAR_P],
                     [dictionary objectForKey:IMAGE],
                     [dictionary objectForKey:CAR_S],
                     [dictionary objectForKey:CAR_R],
                     [dictionary objectForKey:DISP],
                     [dictionary objectForKey:ID],
                     [dictionary objectForKey:CAR_VERSION]
                     
                     ];
        
        if (!isOK) {
            NSLog(@"保存失败%@",[self.cbyDB lastErrorMessage]);
        }else{
           
        }
    }else{
        
        NSLog(@"输入表名有误");
    }

}

//插入一个字段
-(void)saveCarVersionToDB:(NSString *)tableName withColumns:(NSString *)str
{
    [self.cbyDB open];
//    NSMutableString *insertSQL = [[NSMutableString alloc]initWithString:@"UPDATE "];
//    [insertSQL appendString:tableName];
    
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@' ",kCarTable,@"version",str];
    if ([tableName isEqualToString:kCarTable]) {
        //[insertSQL appendString:@ "SET version = str"];
        
        
        BOOL isOK = [self.cbyDB executeUpdate:updateSql];
        
        if (!isOK) {
            NSLog(@"保存失败%@",[self.cbyDB lastErrorMessage]);
        }else{
            NSLog(@"保存成功");
        }
    }else{
        
        NSLog(@"输入表名有误");
    }
    
}


//取出车型完整信息

-(NSArray *)carInfoQueryFromDB:(NSString *)tableName withColumn:(NSDictionary *)dictionary
{
 
    [self.cbyDB open];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableString *selectSQL = [[NSMutableString alloc]initWithString:@"SELECT * FROM "];
    [selectSQL appendString:tableName];
    FMResultSet *set = [self.cbyDB executeQuery:selectSQL];
    while ([set next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[set stringForColumn:@"i"] forKey:@"i"];
        
        [dic setObject:[set stringForColumn:@"n"] forKey:@"n"];
        if ([set stringForColumn:@"s"] != nil) {
            [dic setObject:[set stringForColumn:@"s"] forKey:@"s"];
            
        }
        
        if ([NSNumber numberWithInt:[set intForColumn:@"r"]] != nil) {
            [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"r"]] forKey:@"r"];
        }
        [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"p"]] forKey:@"p"];
        [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"disp"]] forKey:@"disp"];
        if ([set stringForColumn:@"img"] != nil) {
            [dic setObject:[set stringForColumn:@"img"] forKey:@"img"];
        }
        
        if ([set stringForColumn:@"car_id"] != nil) {
            [dic setObject:[set stringForColumn:@"car_id"] forKey:@"car_id"];
        }
        
        if ([set stringForColumn:@"version"] !=nil ) {
            [dic setObject:[set stringForColumn:@"version"] forKey:@"version"];
        }
        
        
        [arr addObject:dic];
    }

    
    
    return arr;
}


//取出品牌

-(NSArray *)carBrandQueryFromDB:(NSString *)tableName
{
    [self.cbyDB open];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableString *selectSQL = [[NSMutableString alloc] initWithString:@"SELECT * FROM "];
    [selectSQL appendString:tableName];
    
     [selectSQL appendString:[NSString stringWithFormat:@" WHERE p = \"%@\"",@"0"]];
    
    
    if ([tableName isEqualToString:kCarTable]) {
    FMResultSet *set = [self.cbyDB executeQuery:selectSQL];
   
    while ([set next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[set stringForColumn:@"i"] forKey:@"i"];
        
        [dic setObject:[set stringForColumn:@"n"] forKey:@"n"];
        if ([set stringForColumn:@"s"] != nil) {
            [dic setObject:[set stringForColumn:@"s"] forKey:@"s"];

        }
        
        if ([NSNumber numberWithInt:[set intForColumn:@"r"]] != nil) {
            [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"r"]] forKey:@"r"];
        }
        [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"p"]] forKey:@"p"];
       [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"disp"]] forKey:@"disp"];
        if ([set stringForColumn:@"img"] != nil) {
            [dic setObject:[set stringForColumn:@"img"] forKey:@"img"];
        }
        
        if ([set stringForColumn:@"car_id"] != nil) {
            [dic setObject:[set stringForColumn:@"car_id"] forKey:@"car_id"];
        }
        
        if ([set stringForColumn:@"version"] !=nil ) {
            [dic setObject:[set stringForColumn:@"version"] forKey:@"version"];
        }
        
        [arr addObject:dic];

        

        }
        
        //筛选已有的车型
        NSArray *tempArr = [NSArray arrayWithArray:arr];
        
        for (NSDictionary *tempDic in tempArr) {
            if (![[tempDic objectForKey:@"disp"] integerValue]) {
                [arr removeObject:tempDic];
            }
        }

     }
   
    return arr;
}


//取出车型
-(NSArray *)carModelQueryFromDB:(NSString *)tableName withPID:(NSString *)str
{
    [self.cbyDB open];
    NSMutableArray *arr = [NSMutableArray array];
                           
    NSMutableString *selectSQL = [[NSMutableString alloc] initWithString:@"SELECT * FROM "];
    [selectSQL appendString:tableName];
    
    [selectSQL appendString:[NSString stringWithFormat:@" WHERE p = \"%@\"",str]];
    
    if ([tableName isEqualToString:kCarTable]) {
        FMResultSet *set = [self.cbyDB executeQuery:selectSQL];
        
        while ([set next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[set stringForColumn:@"i"] forKey:@"i"];
            
            [dic setObject:[set stringForColumn:@"n"] forKey:@"n"];
            if ([set stringForColumn:@"s"] != nil) {
                [dic setObject:[set stringForColumn:@"s"] forKey:@"s"];
                
            }
            
            if ([NSNumber numberWithInt:[set intForColumn:@"r"]] != nil) {
                [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"r"]] forKey:@"r"];
            }
            [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"p"]] forKey:@"p"];
            [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"disp"]] forKey:@"disp"];
            if ([set stringForColumn:@"img"] != nil) {
                [dic setObject:[set stringForColumn:@"img"] forKey:@"img"];
            }
            
            if ([set stringForColumn:@"car_id"] != nil) {
                [dic setObject:[set stringForColumn:@"car_id"] forKey:@"car_id"];
            }
            
            if ([set stringForColumn:@"version"] !=nil ) {
                [dic setObject:[set stringForColumn:@"version"] forKey:@"version"];
            }
            
            
            [arr addObject:dic];
        }
    }
    
    return arr;
}


//取出排量
-(NSArray *)carDisChargeQueryFromDB:(NSString *)tableName withPID:(NSString *)str
{
    [self.cbyDB open];
    NSMutableArray *arr = [NSMutableArray array];
    
    NSMutableString *selectSQL = [[NSMutableString alloc] initWithString:@"SELECT * FROM "];
    [selectSQL appendString:tableName];
    
    [selectSQL appendString:[NSString stringWithFormat:@" WHERE p = \"%@\"and disp = \"%d\"",str,1]];
    
    if ([tableName isEqualToString:kCarTable]) {
        FMResultSet *set = [self.cbyDB executeQuery:selectSQL];
        
        while ([set next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[set stringForColumn:@"i"] forKey:@"i"];
            
            [dic setObject:[set stringForColumn:@"n"] forKey:@"n"];
            if ([set stringForColumn:@"s"] != nil) {
                [dic setObject:[set stringForColumn:@"s"] forKey:@"s"];
                
            }
            
            if ([NSNumber numberWithInt:[set intForColumn:@"r"]] != nil) {
                [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"r"]] forKey:@"r"];
            }
            [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"disp"]] forKey:@"disp"];
            if ([set stringForColumn:@"img"] != nil) {
                [dic setObject:[set stringForColumn:@"img"] forKey:@"img"];
            }
            
            if ([set stringForColumn:@"car_id"] != nil) {
                [dic setObject:[set stringForColumn:@"car_id"] forKey:@"car_id"];
            }
            
            if ([set stringForColumn:@"version"] !=nil ) {
                [dic setObject:[set stringForColumn:@"version"] forKey:@"version"];
            }
            
            
            [arr addObject:dic];
        }
    }
    
    return arr;

}

//取出年份
-(NSArray *)carYearQueryFromDB:(NSString *)tableName withPID:(NSString *)str
{
    [self.cbyDB open];
    NSMutableArray *arr = [NSMutableArray array];
    
    NSMutableString *selectSQL = [[NSMutableString alloc] initWithString:@"SELECT * FROM "];
    [selectSQL appendString:tableName];
    
    [selectSQL appendString:[NSString stringWithFormat:@" WHERE p = \"%@\"",str]];
    
    if ([tableName isEqualToString:kCarTable]) {
        FMResultSet *set = [self.cbyDB executeQuery:selectSQL];
        
        while ([set next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[set stringForColumn:@"i"] forKey:@"i"];
            
            [dic setObject:[set stringForColumn:@"n"] forKey:@"n"];
            if ([set stringForColumn:@"s"] != nil) {
                [dic setObject:[set stringForColumn:@"s"] forKey:@"s"];
                
            }
            
            if ([NSNumber numberWithInt:[set intForColumn:@"r"]] != nil) {
                [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"r"]] forKey:@"r"];
            }
            [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"p"]] forKey:@"p"];
            [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"disp"]] forKey:@"disp"];
            if ([set stringForColumn:@"img"] != nil) {
                [dic setObject:[set stringForColumn:@"img"] forKey:@"img"];
            }
            
            if ([set stringForColumn:@"car_id"] != nil) {
                [dic setObject:[set stringForColumn:@"car_id"] forKey:@"car_id"];
            }
            
            if ([set stringForColumn:@"version"] !=nil ) {
                [dic setObject:[set stringForColumn:@"version"] forKey:@"version"];
            }
            
            
            [arr addObject:dic];
        }
    }
    
    return arr;
}

//热门车型
-(NSArray *)carPopularQueryFromDB:(NSString *)tableName
{
    [self.cbyDB open];
    NSMutableArray *arr = [NSMutableArray array];
    
    NSMutableString *selectSQL = [[NSMutableString alloc] initWithString:@"SELECT * FROM "];
    [selectSQL appendString:tableName];
    
    [selectSQL appendString:[NSString stringWithFormat:@" WHERE r = \"%@\"",@"1"]];
    
    if ([tableName isEqualToString:kCarTable]) {
        FMResultSet *set = [self.cbyDB executeQuery:selectSQL];
        
        while ([set next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[set stringForColumn:@"i"] forKey:@"i"];
            
            [dic setObject:[set stringForColumn:@"n"] forKey:@"n"];
            if ([set stringForColumn:@"s"] != nil) {
                [dic setObject:[set stringForColumn:@"s"] forKey:@"s"];
                
            }
            
            if ([NSNumber numberWithInt:[set intForColumn:@"r"]] != nil) {
                [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"r"]] forKey:@"r"];
            }
            [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"p"]] forKey:@"p"];
            [dic setObject:[NSNumber numberWithInt:[set intForColumn:@"disp"]] forKey:@"disp"];
            if ([set stringForColumn:@"img"] != nil) {
                [dic setObject:[set stringForColumn:@"img"] forKey:@"img"];
            }
            
            if ([set stringForColumn:@"car_id"] != nil) {
                [dic setObject:[set stringForColumn:@"car_id"] forKey:@"car_id"];
            }
            
            if ([set stringForColumn:@"version"] !=nil ) {
                [dic setObject:[set stringForColumn:@"version"] forKey:@"version"];
            }
            
            
            [arr addObject:dic];
        }
        
        //筛选已有的车型
        NSArray *tempArr = [NSArray arrayWithArray:arr];
        
        for (NSDictionary *tempDic in tempArr) {
            if (![[tempDic objectForKey:@"disp"] integerValue]) {
                [arr removeObject:tempDic];
            }
        }
        

    }
    
    return arr;

}



//删除缓存
-(void)deleteCacheFromDB
{
    NSMutableString *deleteSQL = [[NSMutableString alloc]init];
    NSArray *arrar4Table = @[kUserTable,kCarTable];
    
    for (NSString *tableName in arrar4Table) {
        [deleteSQL appendString:@"DELETE FROM "];
        [deleteSQL appendString:tableName];
        
        BOOL isOK = [_cbyDB executeUpdate:deleteSQL];
        if (!isOK) {
            NSLog(@"删除失败:%@",[_cbyDB lastErrorMessage]);
        }else{
            NSLog(@"删除成功");
        }
        
        [deleteSQL deleteCharactersInRange:NSMakeRange(0, deleteSQL.length)];
    }
}

//关闭数据库
-(void)close
{
    [_cbyDB close];
    cbyDBManager = nil;
    
}


//将文件保存到document目录下
-(NSString *)copyFileToDocument:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentPath = filePaths[0];
    
    NSString *destPath = [documentPath stringByAppendingPathComponent:fileName];
    
    //如果目录下已经存在此文件，将不复制
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"51cby" ofType:@"sqlite"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
        
        NSLog(@"file error: %@",error);
    }
    return destPath;
}



@end
