//
//  MyProgressView.h
//  xike
//
//  Created by shaker on 15/8/12.
//  Copyright (c) 2015年 shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "test.h"

@interface MyProgressView : UIView
@property(nonatomic, strong)test *imgOutSide;
@property(nonatomic, strong)UIView *imgInner;

-(void)animatProgress:(float)progress;
-(void)addProgressToView:(UIView *)view;

@end
