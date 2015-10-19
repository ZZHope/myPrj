//
//  YearViewController.h
//  51CBY
//
//  Created by SJB on 14/12/18.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairViewController.h"


@interface YearViewController : UITableViewController

@property (strong, nonatomic)NSString *string;
@property (copy, nonatomic)NSString *yearStr;
@property (copy, nonatomic)NSString *carName;

#pragma mark - 接收要请求数据的参数
@property (strong, nonatomic) NSMutableDictionary *dic;//请求参数


@end
