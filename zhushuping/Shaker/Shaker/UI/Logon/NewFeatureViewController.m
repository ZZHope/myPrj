//
//  NewFeatureViewController.m
//  shaker
//
//  Created by a on 15/4/17.
//  Copyright (c) 2015年 manyStyle. All rights reserved.
//  引导页

// 屏幕尺寸
//#define screenS [UIScreen mainScreen].bounds

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

#define NewFeatureImageNumber 4

#import "NewFeatureViewController.h"
#import "StartViewController.h"
#import "ShakerDatabase.h"

@interface NewFeatureViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIPageControl *pageControl;

@property (nonatomic, weak) UIImageView *spaceshipView;

@property (nonatomic, weak) UIImageView *smokeImageView;

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加scrollerView
    [self setupScrollView];
    
    // 添加pageControl
    [self setupPageControl];
    
}

// 添加scrollerView
- (void)setupScrollView {
    
    // 创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.delegate = self;
    
    scrollView.frame = self.view.frame;
    
    [self.view addSubview:scrollView];
    
    // 图片的frame
    CGFloat imageY = 0;
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    
    for (int i = 0; i < NewFeatureImageNumber; i++) {
        
        UIImageView *imageIcon = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"guide_%d", i + 1];
        imageIcon.image = [UIImage imageNamed:name];
        CGFloat imageX = imageW * i;
        imageIcon.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        // 把图片添加到scroll
        [scrollView addSubview:imageIcon];
        
        // 在第一张图片上添加按钮
        if (i == 0) {
            [self setupFirstView:imageIcon];
        }
        
        // 在第二张图片上添加按钮
        else if (i == 1) {
            [self setupSecondView:imageIcon];
        }
        
        // 在第三张图片上添加按钮
        else if (i == 2) {
            [self setupThreeView:imageIcon];
        }
        
        // 在最后一张图片上添加按钮
        else if (i == NewFeatureImageNumber - 1) {
            [self setupLastView:imageIcon];
        }
    }
    
    // 内容尺寸 可滚动范围多大
    scrollView.contentSize = CGSizeMake(imageW * NewFeatureImageNumber, 0);
    
    // 是否要下面的滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // 是否分页
    scrollView.pagingEnabled = YES;
    
    // 左右不拉伸
    scrollView.bounces = YES;
}

// 添加pageControl
- (void)setupPageControl {
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    
    pageControl.numberOfPages = NewFeatureImageNumber;
    
    CGFloat pageX = self.view.frame.size.width * 0.5;
    CGFloat pageY = self.view.frame.size.height - 18;
    
    pageControl.center = CGPointMake(pageX, pageY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    
    pageControl.userInteractionEnabled = NO;
    
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
    
    // 设置圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
}

// 实现代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 水平滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)pageDouble + 0.5;
    self.pageControl.currentPage = pageInt;
}

// 在第一张图片上添加按钮
- (void)setupFirstView:(UIImageView *)imageIcon {
    
    // 第五个
    UIImage *speckImage = [UIImage imageNamed:@"guide_2_1"];
    CGFloat speckX = 90;
    CGFloat speckY = 315;
    CGFloat speckW = speckImage.size.width / 2;
    CGFloat speckH = speckImage.size.height / 2;
    
    UIImageView *speckView = [[UIImageView alloc] initWithImage:speckImage];
    speckView.frame = CGRectMake(speckX, speckY, speckW, speckH);
    
    [imageIcon addSubview:speckView];
    
    // 第一个
    UIImage *speck1Image = [UIImage imageNamed:@"guide_2_3"];
    CGFloat speck1X = 75;
    CGFloat speck1Y = 160;
    CGFloat speck1W = speck1Image.size.width / 2;
    CGFloat speck1H = speck1Image.size.height / 2;
    
    UIImageView *speck1View = [[UIImageView alloc] initWithImage:speck1Image];
    speck1View.frame = CGRectMake(speck1X, speck1Y, speck1W, speck1H);
    
    [imageIcon addSubview:speck1View];
    
    // 第三个
    UIImage *speck3Image = [UIImage imageNamed:@"guide_2_7"];
    CGFloat speck3X = 215;
    CGFloat speck3Y = 240;
    CGFloat speck3W = speck3Image.size.width / 2;
    CGFloat speck3H = speck3Image.size.height / 2;
    
    UIImageView *speck3View = [[UIImageView alloc] initWithImage:speck3Image];
    speck3View.frame = CGRectMake(speck3X, speck3Y, speck3W, speck3H);
    
    [imageIcon addSubview:speck3View];
    
    // 第六个
    UIImage *speck6Image = [UIImage imageNamed:@"guide_2_1"];
    CGFloat speck6X = 289;
    CGFloat speck6Y = 355;
    CGFloat speck6W = speck6Image.size.width / 2;
    CGFloat speck6H = speck6Image.size.height / 2;
    
    UIImageView *speck6View = [[UIImageView alloc] initWithImage:speck6Image];
    speck6View.frame = CGRectMake(speck6X, speck6Y, speck6W, speck6H);
    
    [imageIcon addSubview:speck6View];
    
    // 第七个
    UIImage *speck7Image = [UIImage imageNamed:@"guide_2_6"];
    CGFloat speck7X = 311;
    CGFloat speck7Y = 460;
    CGFloat speck7W = speck7Image.size.width / 2;
    CGFloat speck7H = speck7Image.size.height / 2;
    
    UIImageView *speck7View = [[UIImageView alloc] initWithImage:speck7Image];
    speck7View.frame = CGRectMake(speck7X, speck7Y, speck7W, speck7H);
    
    [imageIcon addSubview:speck7View];
    
    // 第四个
    UIImage *speck4Image = [UIImage imageNamed:@"guide_2_1"];
    CGFloat speck4X = 11;
    CGFloat speck4Y = 270;
    CGFloat speck4W = speck4Image.size.width / 2;
    CGFloat speck4H = speck4Image.size.height / 2;
    
    UIImageView *speck4View = [[UIImageView alloc] initWithImage:speck4Image];
    speck4View.frame = CGRectMake(speck4X, speck4Y, speck4W, speck4H);
    
    [imageIcon addSubview:speck4View];
    
    // 第二个
    UIImage *speck2Image = [UIImage imageNamed:@"guide_2_3"];
    CGFloat speck2X = 329;
    CGFloat speck2Y = 128;
    CGFloat speck2W = speck2Image.size.width / 2;
    CGFloat speck2H = speck2Image.size.height / 2;
    
    UIImageView *speck2View = [[UIImageView alloc] initWithImage:speck2Image];
    speck2View.frame = CGRectMake(speck2X, speck2Y, speck2W, speck2H);
    
    [imageIcon addSubview:speck2View];
    
    // 第八个
    UIImage *speck8Image = [UIImage imageNamed:@"guide_1_8"];
    CGFloat speck8X = 27;
    CGFloat speck8Y = 477;
    CGFloat speck8W = speck8Image.size.width / 2;
    CGFloat speck8H = speck8Image.size.height / 2;
    
    UIImageView *speck8View = [[UIImageView alloc] initWithImage:speck8Image];
    speck8View.frame = CGRectMake(speck8X, speck8Y, speck8W, speck8H);
    
    [imageIcon addSubview:speck8View];
    
    // 执行动画水平方向
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.keyPath = @"transform.translation.x";
    anim.values = @[@(0), @(30), @(0), @(-30), @(0)];
    anim.duration = 20.0;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    // 执行动画水平方向
    CAKeyframeAnimation *anim1 = [CAKeyframeAnimation animation];
    
    anim1.keyPath = @"transform.translation.x";
    anim1.values = @[@(0), @(-30), @(0), @(30), @(0)];
    anim1.duration = 20.0;
    // 动画的重复执行次数
    anim1.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim1.removedOnCompletion = NO;
    anim1.fillMode = kCAFillModeForwards;
    
    // 执行动画水平方向
    CAKeyframeAnimation *anim2 = [CAKeyframeAnimation animation];
    
    anim2.keyPath = @"transform.translation.x";
    anim2.values = @[@(0), @(-30), @(0), @(30), @(0)];
    anim2.duration = 20.0;
    // 动画的重复执行次数
    anim2.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim2.removedOnCompletion = NO;
    anim2.fillMode = kCAFillModeForwards;
    
    // 执行动画水平方向
    CAKeyframeAnimation *anim3 = [CAKeyframeAnimation animation];
    
    anim3.keyPath = @"transform.translation.x";
    anim3.values = @[@(0), @(-30), @(0), @(30), @(0)];
    anim3.duration = 20.0;
    // 动画的重复执行次数
    anim3.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim3.removedOnCompletion = NO;
    anim3.fillMode = kCAFillModeForwards;
    
    [speckView.layer addAnimation:anim1 forKey:@"k"];
    [speck1View.layer addAnimation:anim forKey:@"k"];
    [speck3View.layer addAnimation:anim2 forKey:@"k"];
    [speck6View.layer addAnimation:anim3 forKey:@"k"];
    [speck7View.layer addAnimation:anim forKey:@"k"];
    
    // 执行动画垂直方向
    CAKeyframeAnimation *animY = [CAKeyframeAnimation animation];
    
    animY.keyPath = @"transform.translation.y";
    animY.values = @[@(0), @(30), @(0), @(-30), @(0)];
    animY.duration = 20.0;
    // 动画的重复执行次数
    animY.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    animY.removedOnCompletion = NO;
    animY.fillMode = kCAFillModeForwards;
    
    [speck4View.layer addAnimation:animY forKey:@"ky"];
    [speck2View.layer addAnimation:animY forKey:@"ky"];
    [speck8View.layer addAnimation:animY forKey:@"ky"];

}

// 在第二张图片上添加按钮
- (void)setupSecondView:(UIImageView *)imageIcon {
    
    // 最里面的星球
    UIImage *bodyImage = [UIImage imageNamed:@"s_2_1"];
    CGFloat bodyW = bodyImage.size.width / 2;
    CGFloat bodyH = bodyImage.size.height / 2;
    
    UIImageView *bodyView = [[UIImageView alloc] initWithImage:bodyImage];
    bodyView.frame = CGRectMake(0, 0, bodyW, bodyH);
    
    [imageIcon addSubview:bodyView];
    
    // 执行动画

    CGPoint arcCenter=CGPointMake(self.view.frame.size.width / 2, 256); // 中心锚点
    int radius = 149; // 半径
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                               radius:radius                                                                     startAngle:DEGREES_TO_RADIANS(-180)
                                                             endAngle:DEGREES_TO_RADIANS(180)
                                                            clockwise:YES];
    
    CAKeyframeAnimation * orbit = [CAKeyframeAnimation animation];
    orbit.keyPath = @"position";
    orbit.path = circlePath.CGPath;
    orbit.duration = 20;
    orbit.additive = YES;
    orbit.repeatCount = HUGE_VALF;
    orbit.calculationMode = kCAAnimationPaced;
    orbit.rotationMode = kCAAnimationRotateAuto;
    
    [bodyView.layer addAnimation:orbit forKey:@"orbit"];
    
    // 最里面的星球
    UIImage *body1Image = [UIImage imageNamed:@"s_2_3"];
    CGFloat body1W = body1Image.size.width / 2;
    CGFloat body1H = body1Image.size.height / 2;
    
    UIImageView *body1View = [[UIImageView alloc] initWithImage:body1Image];
    body1View.frame = CGRectMake(0, 0, body1W, body1H);
    
    [imageIcon addSubview:body1View];
    
    // 执行动画
    
    CGPoint arcCenter1=CGPointMake(self.view.frame.size.width / 2, 256); // 中心锚点
    int radius1 = 34; // 半径
    UIBezierPath * circlePath1 = [UIBezierPath bezierPathWithArcCenter:arcCenter1
                                                               radius:radius1                                                                     startAngle:DEGREES_TO_RADIANS(-180)
                                                             endAngle:DEGREES_TO_RADIANS(180)
                                                            clockwise:YES];
    
    CAKeyframeAnimation * orbit1 = [CAKeyframeAnimation animation];
    orbit1.keyPath = @"position";
    orbit1.path = circlePath1.CGPath;
    orbit1.duration = 20;
    orbit1.additive = YES;
    orbit1.repeatCount = HUGE_VALF;
    orbit1.calculationMode = kCAAnimationPaced;
    orbit1.rotationMode = kCAAnimationRotateAuto;
    
    [body1View.layer addAnimation:orbit1 forKey:@"orbit"];
    
    // 最里面的星球
    UIImage *body2Image = [UIImage imageNamed:@"s_2_4"];
    CGFloat body2W = body2Image.size.width / 2;
    CGFloat body2H = body2Image.size.height / 2;
    
    UIImageView *body2View = [[UIImageView alloc] initWithImage:body2Image];
    body2View.frame = CGRectMake(0, 0, body2W, body2H);
    
    [imageIcon addSubview:body2View];
    
    // 执行动画
    
    CGPoint arcCenter2=CGPointMake(self.view.frame.size.width / 2, 256); // 中心锚点
    int radius2 = 54; // 半径
    UIBezierPath * circlePath2 = [UIBezierPath bezierPathWithArcCenter:arcCenter2
                                                                radius:radius2                                                                     startAngle:DEGREES_TO_RADIANS(-180)
                                                              endAngle:DEGREES_TO_RADIANS(180)
                                                             clockwise:YES];
    
    CAKeyframeAnimation * orbit2 = [CAKeyframeAnimation animation];
    orbit2.keyPath = @"position";
    orbit2.path = circlePath2.CGPath;
    orbit2.duration = 30;
    orbit2.additive = YES;
    orbit2.repeatCount = HUGE_VALF;
    orbit2.calculationMode = kCAAnimationPaced;
    orbit2.rotationMode = kCAAnimationRotateAuto;
    
    [body2View.layer addAnimation:orbit2 forKey:@"orbit"];

    
    // 最里面的星球
    UIImage *body3Image = [UIImage imageNamed:@"s_2_2"];
    CGFloat body3W = body3Image.size.width / 2;
    CGFloat body3H = body3Image.size.height / 2;
    
    UIImageView *body3View = [[UIImageView alloc] initWithImage:body3Image];
    body3View.frame = CGRectMake(0, 0, body3W, body3H);
    
    [imageIcon addSubview:body3View];
    
    // 执行动画
    
    CGPoint arcCenter3=CGPointMake(self.view.frame.size.width / 2, 256); // 中心锚点
    int radius3 = 81; // 半径
    UIBezierPath * circlePath3 = [UIBezierPath bezierPathWithArcCenter:arcCenter3
                                                                radius:radius3                                                                     startAngle:DEGREES_TO_RADIANS(-180)
                                                              endAngle:DEGREES_TO_RADIANS(180)
                                                             clockwise:YES];
    
    CAKeyframeAnimation * orbit3 = [CAKeyframeAnimation animation];
    orbit3.keyPath = @"position";
    orbit3.path = circlePath3.CGPath;
    orbit3.duration = 20;
    orbit3.additive = YES;
    orbit3.repeatCount = HUGE_VALF;
    orbit3.calculationMode = kCAAnimationPaced;
    orbit3.rotationMode = kCAAnimationRotateAuto;
    
    [body3View.layer addAnimation:orbit3 forKey:@"orbit"];
}

// 第三张图片
- (void)setupThreeView:(UIImageView *)imageIcon {
    
    // 第一个
    UIImage *speckImage = [UIImage imageNamed:@"guide_3_1"];
    CGFloat speckX = 275;
    CGFloat speckY = 110;
    CGFloat speckW = speckImage.size.width / 2;
    CGFloat speckH = speckImage.size.height / 2;
    
    UIImageView *speckView = [[UIImageView alloc] initWithImage:speckImage];
    speckView.frame = CGRectMake(speckX, speckY, speckW, speckH);
    
    [imageIcon addSubview:speckView];
    
    // 第er个
    UIImage *speck1Image = [UIImage imageNamed:@"guide_3_2"];
    CGFloat speck1X = 45;
    CGFloat speck1Y = 270;
    CGFloat speck1W = speck1Image.size.width / 2;
    CGFloat speck1H = speck1Image.size.height / 2;
    
    UIImageView *speck1View = [[UIImageView alloc] initWithImage:speck1Image];
    speck1View.frame = CGRectMake(speck1X, speck1Y, speck1W, speck1H);
    
    [imageIcon addSubview:speck1View];
    
    // 第三个
    UIImage *speck2Image = [UIImage imageNamed:@"guide_3_3"];
    CGFloat speck2X = 210;
    CGFloat speck2Y = 280;
    CGFloat speck2W = speck2Image.size.width / 2;
    CGFloat speck2H = speck2Image.size.height / 2;
    
    UIImageView *speck2View = [[UIImageView alloc] initWithImage:speck2Image];
    speck2View.frame = CGRectMake(speck2X, speck2Y, speck2W, speck2H);
    
    [imageIcon addSubview:speck2View];
    
    // 执行动画水平方向
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.keyPath = @"transform.translation.x";
    anim.values = @[@(0), @(30), @(0), @(-30), @(0)];
    anim.duration = 20.0;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [speckView.layer addAnimation:anim forKey:@"ky"];
    [speck1View.layer addAnimation:anim forKey:@"ky"];
    
    // 执行动画垂直方向
    CAKeyframeAnimation *animY = [CAKeyframeAnimation animation];
    
    animY.keyPath = @"transform.translation.y";
    animY.values = @[@(0), @(30), @(0), @(-30), @(0)];
    animY.duration = 10.0;
    // 动画的重复执行次数
    animY.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    animY.removedOnCompletion = NO;
    animY.fillMode = kCAFillModeForwards;
    
    [speck2View.layer addAnimation:animY forKey:@"ky"];


}

// 在最后一张图片上添加按钮
- (void)setupLastView:(UIImageView *)imageIcon {
    
    imageIcon.userInteractionEnabled = YES;
    
    // 飞机按钮
    UIImage *shipView = [UIImage imageNamed:@"Rocket"];
    CGFloat spaceshipW = shipView.size.width / 2;
    CGFloat spaceshipH = shipView.size.height / 2;
    CGFloat spaceshipX = (self.view.frame.size.width - spaceshipW) / 2;
    CGFloat spaceshipY = self.view.frame.size.height - 245;
    
    UIImageView *spaceshipView = [[UIImageView alloc] initWithImage:shipView];
    spaceshipView.frame = CGRectMake(spaceshipX, spaceshipY, spaceshipW, spaceshipH);
    self.spaceshipView = spaceshipView;
    
    [imageIcon addSubview:spaceshipView];
    
    // 烟雾按钮
    UIImage *smokeView = [UIImage imageNamed:@"gas"];
    CGFloat smokeW = smokeView.size.width / 2.0;
    CGFloat smokeH = smokeView.size.height / 2.0;
    CGFloat smokeX = (self.view.bounds.size.width-smokeW)*0.5;
    CGFloat smokeY = self.view.frame.size.height - 175;
    
    UIImageView *smokeImageView = [[UIImageView alloc] initWithImage:smokeView];
    smokeImageView.frame = CGRectMake(smokeX, smokeY, smokeW, smokeH);
    self.smokeImageView = smokeImageView;
    
    [imageIcon addSubview:smokeImageView];
    
    // 飞机起飞按钮
    CGFloat flyBtW = 107;
    CGFloat flyBtH = 30;
    CGFloat flyBtX = (self.view.frame.size.width - flyBtW) / 2;
    CGFloat flyBtY = self.view.frame.size.height - 76;
    
    UIButton *flyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [flyBt setImage:[UIImage imageNamed:@"稀客来了"] forState:UIControlStateNormal];
    flyBt.layer.borderColor = [UIColor whiteColor].CGColor;
    flyBt.layer.borderWidth = 0.8;
    flyBt.layer.cornerRadius = 2;
    flyBt.frame = CGRectMake(flyBtX, flyBtY, flyBtW, flyBtH);
    [flyBt addTarget:self action:@selector(didFly) forControlEvents:UIControlEventTouchUpInside];
    
    [imageIcon addSubview:flyBt];
}

// 飞机起飞 进入首页
- (void)didFly {
    
    [UIView animateWithDuration:1.5 animations:^{
        
        self.smokeImageView.alpha = 0.0;
        self.spaceshipView.frame = CGRectMake(self.view.frame.size.width / 2, 0, 0, 0);
    } completion:^(BOOL finished) {
        
        
        ShakerDatabase *dataBase = [ShakerDatabase new];
        StartViewController *startVC = [[StartViewController alloc]init];
        if ([dataBase createAllTables]) {
            startVC = [StartViewController new];
            startVC.database = dataBase;
           // logonViewController.deviceToken = token;

        }
        
        UINavigationController *navVC  = [[UINavigationController alloc]initWithRootViewController:startVC];
        [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
    }];
}

@end
