//
//  PieProgressView.m
//  TestPie
//
//  Created by  淑萍 on 17/2/14.
//  Copyright © 2017年 华夏信财. All rights reserved.
//

#import "PieProgressView.h"
#import <QuartzCore/QuartzCore.h>

@interface PieProgressView()
@property(nonatomic,assign) float start;
@property(nonatomic,assign) float end;

@end
@implementation PieProgressView

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.start = -M_PI_2;
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);//中心位置
    if (self.colors&&self.colors.count) {
        for (int i=0; i<self.colors.count; i++) {
            self.end=self.start + 1.0/self.colors.count*2*M_PI;
            CGFloat endAngle = self.end;
            float radiusCircle = self.frame.size.width>self.frame.size.height?self.frame.size.height/2:self.frame.size.width/2;
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point radius:(radiusCircle-4) startAngle:self.start endAngle:endAngle clockwise:YES];
            CGContextSetLineCap(context, kCGLineCapSquare);
            
            CGContextSetLineWidth(context, 4.0);
            CGContextSetStrokeColorWithColor(context, ((UIColor*)self.colors[i]).CGColor);//第一部分颜色
            CGContextAddPath(context, bezierPath.CGPath);
            CGContextStrokePath(context);//渲染
            self.start = self.end;
            
        }
 
    }else{//只有一种颜色时候
        CGFloat endAngle = 2*M_PI;
        float radiusCircle = self.frame.size.width>self.frame.size.height?self.frame.size.height/2:self.frame.size.width/2;
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point radius:(radiusCircle-4) startAngle:self.start endAngle:endAngle clockwise:YES];
        CGContextSetLineCap(context, kCGLineCapSquare);
        
        CGContextSetLineWidth(context, 4.0);
        CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);//第一部分颜色
        CGContextAddPath(context, bezierPath.CGPath);
        CGContextStrokePath(context);//渲染
 
    }
    
}

-(void)setProgressWithAnimated
{
    self.hidden = NO;
    [self setNeedsDisplay];
}

@end
