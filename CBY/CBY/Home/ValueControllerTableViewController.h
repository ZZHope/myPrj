//
//  ValueControllerTableViewController.h
//  51CBY
//
//  Created by SJB on 14/12/18.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnScoreBlock) (int scoreShow);
@interface ValueControllerTableViewController : UITableViewController
@property (assign, nonatomic) int estimateScore;
@property(nonatomic,copy) ReturnScoreBlock returnScoreBlock;
@property(nonatomic, strong)NSMutableDictionary *tempDic;



-(void) returnScore:(ReturnScoreBlock)block;

@end
