//
//  SchemeViewController.h
//  51CBY
//
//  Created by SJB on 15/4/1.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchemeViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableDictionary *allDictionary;//根据服务得到的所有字典数据

@property (strong, nonatomic) NSDictionary *parameter;//请求所需要的参数

@property (copy, nonatomic) NSString *strUrl;

//@property (copy, nonatomic) NSString *carId;
@property (copy, nonatomic) NSString *carString;

@property (assign, nonatomic) int loopFlag;



@end
