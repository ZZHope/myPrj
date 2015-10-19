//
//  UIImage+Common.h
//  PhotoTest
//
//  Created by Leading Chen on 15/1/24.
//  Copyright (c) 2015年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

+ (UIImage *)imageCrop:(UIImage *)originalImage :(CGRect)imageRect :(CGRect)cropRect;
+ (UIImage *)imageCapture:(UIView *)view;
+ (UIImage *)imageCaptureScrollView:(UIScrollView *)scrollView;
+ (UIImage *)imageWithOriginImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
