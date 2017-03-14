//
//  PieProgressView.h
//  TestPie
//
//  Created by  淑萍 on 17/2/14.
//  Copyright © 2017年 华夏信财. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieProgressView : UIView
@property(nonatomic,strong) NSMutableArray *colors;
-(void)setProgressWithAnimated;
@end
