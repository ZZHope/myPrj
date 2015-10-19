//
//  CustomButton.m
//  51CBY
//
//  Created by SJB on 14/12/16.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        
      
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    }
    return self;
}


//重写父类的方法

//根据button的rect设定并返回文本label的rect

- (CGRect)titleRectForContentRect:(CGRect)contentRect

{
    
    CGFloat titleW = contentRect.size.width;
    
    CGFloat titleH = contentRect.size.height*0.25;
    
    CGFloat titleX = 0;
    
    CGFloat titleY = contentRect.size.height*self.rateFloat;
    
    contentRect = (CGRect){{titleX,titleY},{titleW,titleH}};
    
    return contentRect;
    
}

//根据button的rect设定并返回UIImageView的rect

- (CGRect)imageRectForContentRect:(CGRect)contentRect

{
    
    CGFloat imageW = contentRect.size.width;
    
    CGFloat imageH = contentRect.size.height*0.75;
    
    CGFloat imageX = 0;
    
    CGFloat imageY = 0;
    
    contentRect = (CGRect){{imageX,imageY},{imageW,imageH}};
    
    return contentRect;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
