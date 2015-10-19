//
//  ImageCropperViewController.h
//  TestCropView
//
//  Created by Leading Chen on 15/5/19.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageCropperViewController;

@protocol ImageCropperDelegate <NSObject>

- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController;

@end

@interface ImageCropperViewController : UIViewController
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *editedImage;
@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *ratioView;
@property (nonatomic, assign) CGRect cropFrame;
//@property (nonatomic, assign) CGRect oldFrame;
//@property (nonatomic, assign) CGRect largeFrame;
//@property (nonatomic, assign) CGFloat limitRatio;
@property (nonatomic, assign) CGRect latestFrame;

@property (nonatomic, strong) id<ImageCropperDelegate> delegate;


- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame;

@end
