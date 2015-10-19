//
//  CarModelsView.h
//  51CBY
//
//  Created by SJB on 14/12/17.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarModelsView : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

//用于接收选择的车型
@property (copy, nonatomic)NSMutableString *carStr;

@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;

#pragma mark - 接收要请求数据的参数
@property (strong, nonatomic) NSMutableDictionary *dic;//请求参数

@end
