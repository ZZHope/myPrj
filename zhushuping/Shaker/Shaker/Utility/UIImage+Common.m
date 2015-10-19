//
//  UIImage+Common.m
//  PhotoTest
//
//  Created by Leading Chen on 15/1/24.
//  Copyright (c) 2015年 Leading. All rights reserved.
//

#import "UIImage+Common.h"

@implementation UIImage (Common)

+ (UIImage *)imageCaptureScrollView:(UIScrollView *)scrollView {//20150527
    CGPoint offset = scrollView.contentOffset;
    CGRect frame = scrollView.frame;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    scrollView.contentOffset = CGPointZero;
    [scrollView setFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //reset scrollView to previous position
    [scrollView setFrame:frame];
    scrollView.contentOffset = offset;
    
    return image;
}
+ (UIImage *)imageCapture:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageCrop:(UIImage *)originalImage :(CGRect)imageRect :(CGRect)cropRect {
    CGFloat scaleRatio = imageRect.size.width/originalImage.size.width;
    CGFloat x = (cropRect.origin.x - imageRect.origin.x)/scaleRatio;
    CGFloat y = (cropRect.origin.y - imageRect.origin.y)/scaleRatio;
    CGFloat w = cropRect.size.width/scaleRatio;
    CGFloat h = cropRect.size.height/scaleRatio;
    if (imageRect.size.width < cropRect.size.width) {
        CGFloat newW = originalImage.size.width;
        CGFloat newH = newW * (cropRect.size.height/cropRect.size.width);
        x = 0; y = y + (h-newH)/2;
        w = newW; h = newH;
    }
    if (imageRect.size.height < cropRect.size.height) {
        CGFloat newH = originalImage.size.height;
        CGFloat newW = newH * (cropRect.size.width/cropRect.size.height);
        x = x + (w - newW)/2; y = 0;
        w = newW; h = newH;
    }
    
    CGImageRef imageRef = originalImage.CGImage;
    CGRect subImageRect = CGRectMake(x, y, w, h);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    
    UIGraphicsBeginImageContext(CGSizeMake(subImageRect.size.width, subImageRect.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;

}

+ (UIImage *)imageWithOriginImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
