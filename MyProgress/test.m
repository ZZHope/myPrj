//
//  test.m
//  testProgress
//
//  Created by shaker on 15/6/3.
//  Copyright (c) 2015年 shaker. All rights reserved.
//

#import "test.h"
#import <QuartzCore/QuartzCore.h>

@implementation test


-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
   
   
    
    //画扇形并填充颜
    UIColor *aColor = self.color;
   // UIColor*aColor = [UIColor colorWithRed:1 green:0.0 blue:0 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextMoveToPoint(context, rect.size.width*self.x, rect.size.width*self.y);
    CGContextAddArc(context, rect.size.width*self.x, rect.size.width*self.y, rect.size.width*self.radius,  self.startAngle*M_PI,  -0.5*M_PI+self.progressRate*2*M_PI, 0);
       CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFill); //绘制路径加填充
    
    
    /*参数说明
     
     void CGContextAddArc ( CGContextRef c, CGFloat x, CGFloat y, CGFloat radius, CGFloat startAngle, CGFloat endAngle, int clockwise );
     Parameters：
     c-A graphics context.
     x-The x-value, in user space coordinates, for the center of the arc.
     y-The y-value, in user space coordinates, for the center of the arc.
     radius-The radius of the arc, in user space coordinates.
     startAngle-The angle to the starting point of the arc, measured in radians from the positive x-axis.
     endAngle-The angle to the end point of the arc, measured in radians from the positive x-axis.
     clockwise-Specify 1 to create a clockwise arc or 0 to create a counterclockwise arc
     
     */
}


-(void)setProgressRate:(float)progressRate
{
    self.progressRate = progressRate;
}

@end
