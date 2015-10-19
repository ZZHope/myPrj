//
//  ChangeJYViewController.h
//  51CBY
//
//  Created by SJB on 15/4/8.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ReturnJYBlock) (NSDictionary *dic);
@interface ChangeJYViewController : UIViewController

@property (nonatomic, copy) ReturnJYBlock changeJYInfo;

@property(nonatomic, copy) NSString *carIdJY;
@property(nonatomic, copy) NSString *weightJY;

-(void)changeJYInfo:(ReturnJYBlock)changeJYInfo;


@end
