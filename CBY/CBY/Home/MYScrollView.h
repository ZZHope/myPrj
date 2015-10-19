//
//  LGScrollView.h
//  LGPige
//
//  Created by SLG on 14-10-24.
//  Copyright (c) 2014年 SLG. All rights reserved.
//

//无限循环的scrollView。pageControll显示图片显示的页数
#import <UIKit/UIKit.h>

//@class MYScrollView;
@protocol MYScrollViewDelegate <NSObject>

@optional
-(void)tapImageLoopToViewController;

@end

@interface MYScrollView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic, assign) id <MYScrollViewDelegate> myDelegate;
@property (nonatomic,assign) NSInteger startContent;

-(id)initWithFrame:(CGRect)frame Image:(NSArray *)image;
-(void)startTimer;
@end
