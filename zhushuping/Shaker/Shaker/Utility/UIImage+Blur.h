//
//  UIImage+Blur.h
//  Qing
//
//  Created by Leading Chen on 14-7-8.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

/* blur the current image with a box blur algoritm */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur;

/* blur the current image with a box blur algoritm and tint with a color */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor*)tintColor;

@end
