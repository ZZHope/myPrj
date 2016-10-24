//
//  MyProgressView.m
//  xike
//
//  Created by shaker on 15/8/12.
//  Copyright (c) 2015年 shaker. All rights reserved.
//

#import "MyProgressView.h"
#import "common.h"

@implementation MyProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        _imgInner = [self imgViewWithFrame:CGRectMake((frame.size.width-60)*0.5, (frame.size.height-60)*0.5, 60, 60)];
        
        
        _imgOutSide = [[test alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _imgOutSide.backgroundColor= [UIColor whiteColor];
        _imgOutSide.color = kColor(216, 216, 216);
        _imgOutSide.x = 0.5;
        _imgOutSide.y = 0.5;
        _imgOutSide.radius = 0.5;
        _imgOutSide.startAngle = -0.5;
        
        
        
        
        //遮盖
        UIView *coverView = [self imgViewWithFrame:CGRectMake(5, 5, 50, 50)];
        coverView.backgroundColor = kColor(216, 216, 216);
        
        [self.imgInner addSubview:self.imgOutSide];
        [self.imgInner addSubview:coverView];
        [self addSubview:self.imgInner];
        

    }
    
    return self;
}

-(void)addProgressToView:(UIView *)view
{
    
    [view addSubview:self];
    
}



-(UIView*)imgViewWithFrame:(CGRect)frame
{
    UIView *imgView = [[UIView alloc]initWithFrame:frame];
    
    imgView.layer.cornerRadius = frame.size.width*0.5;
    imgView.clipsToBounds = YES;
    imgView.layer.borderColor = [UIColor grayColor].CGColor;
    imgView.layer.borderWidth = 2.0f;
    
    return imgView;
}

-(void)animatProgress:(float)progress
{
    
    self.imgOutSide.progressRate = progress;
    [self.imgOutSide setNeedsDisplay];
    
}

@end
