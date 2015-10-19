//
//  TopicCell2.h
//  Shaker
//
//  Created by Leading Chen on 15/4/13.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
@interface TopicCell2 : UIView
@property (nonatomic, strong) Topic *topic;

- (id)initWithFrame:(CGRect)frame Topic:(Topic *)topic;
@end
