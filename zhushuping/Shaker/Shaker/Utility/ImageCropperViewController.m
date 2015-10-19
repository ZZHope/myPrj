//
//  ImageCropperViewController.m
//  TestCropView
//
//  Created by Leading Chen on 15/5/19.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "ImageCropperViewController.h"
#import "Contants.h"
#import "ColorHandler.h"


@interface ImageCropperViewController ()

@end

@implementation ImageCropperViewController

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame {
    self = [super init];
    if (self) {
        _cropFrame = cropFrame;
        _originalImage = originalImage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self buildView];
    [self buildBottomButton];
    
}

- (void)buildView {
    CGFloat oraWidth = self.view.bounds.size.width;
    CGFloat oraHeight = _originalImage.size.height * (oraWidth/_originalImage.size.width);
    if (oraHeight < _cropFrame.size.height) {
        oraHeight = _cropFrame.size.height;
        oraWidth = _originalImage.size.width * (oraHeight/_originalImage.size.height);
    }
    
    _showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, oraWidth, oraHeight)];
    [_showImgView setImage:_originalImage];
    [_showImgView setUserInteractionEnabled:YES];
    [_showImgView setMultipleTouchEnabled:YES];
    [_showImgView setCenter:self.view.center];
    [self addGestureRecognizers];
    [self.view addSubview:_showImgView];
    
    _overlayView = [[UIView alloc] initWithFrame: self.view.bounds];
    _overlayView.alpha = .5f;
    _overlayView.backgroundColor = [UIColor blackColor];
    _overlayView.userInteractionEnabled = NO;
    _overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview: _overlayView];
    
    _ratioView = [[UIView alloc] initWithFrame: _cropFrame];
    _ratioView.layer.borderColor = [UIColor yellowColor].CGColor;
    _ratioView.layer.borderWidth = 2.0f;
    _ratioView.autoresizingMask = UIViewAutoresizingNone;
    [_ratioView setCenter:_showImgView.center];
    [self.view addSubview: _ratioView];
    
    _latestFrame = _showImgView.frame;
    _cropFrame = _ratioView.frame;
    
    [self overlayClipping];
}


- (void)overlayClipping {
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    // Left side of the ratio view
    CGPathAddRect(path, nil,
                  CGRectMake(0,
                             0,
                             _ratioView.frame.origin.x,
                             _overlayView.frame.size.height
                             )
                  );
    // Right side of the ratio view
    CGPathAddRect(path, nil,
                  CGRectMake(_ratioView.frame.origin.x+_ratioView.frame.size.width,
                             0,
                             _overlayView.frame.size.width-_ratioView.frame.origin.x-_ratioView.frame.size.width,
                             _overlayView.frame.size.height
                             )
                  );
    // Top side of the ratio view
    CGPathAddRect(path, nil,
                  CGRectMake(0,
                             0,
                             _overlayView.frame.size.width,
                             _ratioView.frame.origin.y
                             )
                  );
    // Bottom side of the ratio view
    CGPathAddRect(path, nil,
                  CGRectMake(0,
                             _ratioView.frame.origin.y+_ratioView.frame.size.height,
                             _overlayView.frame.size.width,
                             _overlayView.frame.size.height-_ratioView.frame.origin.y+_ratioView.frame.size.height
                             )
                  );
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

// register all gestures
- (void) addGestureRecognizers {
    // add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    // add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    UIView *view = self.showImgView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3f animations:^{
            _showImgView.frame = newFrame;
            _latestFrame = newFrame;
        }];
    }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *view = _showImgView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = _cropFrame.origin.x + _cropFrame.size.width / 2;
        CGFloat absCenterY = _cropFrame.origin.y + _cropFrame.size.height / 2;
        CGFloat scaleRatio = _showImgView.frame.size.width / _cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = _showImgView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3f animations:^{
            _showImgView.frame = newFrame;
            _latestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < _cropFrame.size.width) {
        newFrame = _latestFrame;
    }
    if (newFrame.size.height < _cropFrame.size.height) {
        newFrame = _latestFrame;
    }
    //    if (newFrame.size.width > self.largeFrame.size.width) {
    //        newFrame = self.largeFrame;
    //    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}


- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (CGRectGetMinX(newFrame) > CGRectGetMinX(_cropFrame)) {
        newFrame.origin.x = _cropFrame.origin.x;
    }
    if (CGRectGetMaxX(newFrame) < CGRectGetMaxX(_cropFrame)) {
        newFrame.origin.x = CGRectGetMaxX(_cropFrame) - newFrame.size.width;
    }
    // vertically
    if (CGRectGetMinY(newFrame) > CGRectGetMinY(_cropFrame)) {
        newFrame.origin.y = _cropFrame.origin.y;
    }
    if (CGRectGetMaxY(newFrame) < CGRectGetMaxY(_cropFrame)) {
        newFrame.origin.y = CGRectGetMaxY(_cropFrame) - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (_showImgView.frame.size.width > _showImgView.frame.size.height && newFrame.size.height <= _cropFrame.size.height) {
        newFrame.origin.y = _cropFrame.origin.y + (_cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

- (void)buildBottomButton {
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(23, viewHeight-30, 50, 20)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBtn setTitleColor:[ColorHandler colorWithHexString:@"#00d8a5"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(didCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-23-50, viewHeight-30, 50, 20)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [confirmBtn setTitleColor:[ColorHandler colorWithHexString:@"#00d8a5"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(didConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (void)didCancel {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ImageCropperDelegate)]) {
        [self.delegate imageCropperDidCancel:self];
    }
}

- (void)didConfirm {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ImageCropperDelegate)]) {
        [self.delegate imageCropper:self didFinished:[self getSubImage]];
    }
}

-(UIImage *)getSubImage{
    CGRect squareFrame = _cropFrame;
    CGFloat scaleRatio = _latestFrame.size.width / _originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - _latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - _latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.height / scaleRatio;
    if (_latestFrame.size.width < _cropFrame.size.width) {
        CGFloat newW = _cropFrame.size.width;
        CGFloat newH = newW * (_cropFrame.size.height / _cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newW; h = newH;
    }
    if (_latestFrame.size.height < _cropFrame.size.height) {
        CGFloat newH = _cropFrame.size.height;
        CGFloat newW = newH * (_cropFrame.size.width / _cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newW; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = _originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
