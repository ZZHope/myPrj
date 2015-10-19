//
//  MYBoolButton.m
//  51CBY
//
//  Created by SJB on 15/1/15.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "MYFocusButton.h"

@implementation MYFocusButton


-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}


+(id)buttonWithFrame:(CGRect)frame andTitle:(NSString*)title backgroundImage:(UIImage *)backgroundImage hilightedImage:(UIImage *)highLightedImage backgroundColor:(UIColor *)color
{
    UIButton *btn = [[UIButton alloc]init];
    
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:backgroundImage forState:UIControlStateNormal];
    [btn setImage:highLightedImage forState:UIControlStateHighlighted];
    [btn setBackgroundColor:color];
    
    return btn;
    
}



-(void)setFlag:(BOOL)flag
{
    _flag = flag;
    if (flag) {
        [self setImage:[[UIImage imageNamed:@"关注2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal ];
        [self setTitle:nil forState:UIControlStateNormal];
    }else{
         [self setImage:[[UIImage imageNamed:@"关注"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal ];
        [self setTitle:nil forState:UIControlStateNormal];
        
    }
}

-(void)setSelFlag:(BOOL)selFlag andImg:(NSString *)imgName highLightImg:(NSString *)selImgName
{
    _selFlag = selFlag;
    if (selFlag) {
        [self setImage:[[UIImage imageNamed:selImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal ];
        [self setTitle:nil forState:UIControlStateNormal];
    }else{
        [self setImage:[[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal ];
        [self setTitle:nil forState:UIControlStateNormal];
        
    }
}


@end
