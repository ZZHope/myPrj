//
//  LGScrollView.m
//  LGPige
//
//  Created by SLG on 14-10-24.
//  Copyright (c) 2014年 SLG. All rights reserved.
//

#import "MYScrollView.h"
#import "UIImageView+WebCache.h"
#import "AFNCommon.h"
#import "SDImageCache.h"

#define kImageName  @"imageurl"
#define kLoopFlag  @"action"

@implementation MYScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame Image:(NSArray *)image
{
    self = [super initWithFrame:frame];
    if (self) {
    //组合图片
        if (image.count > 0) {
            NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithCapacity:image.count + 2];
            [mutableArray addObject:image.lastObject];
            [mutableArray addObjectsFromArray:image];
            [mutableArray addObject:image[0]];
            self.images = mutableArray;
            
        }
       
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //初始化内容
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        
        scrollView.contentSize = CGSizeMake(self.images.count * self.frame.size.width, self.frame.size.height);
        self.scrollView = scrollView;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        
        for (int i = 0; i < self.images.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@",kBannerImageUrl,[self.images[i] objectForKey:kImageName]]];
            
            UIImage *holderImg = [[UIImage imageNamed:@"holder"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch] ;
            [imageView sd_setImageWithURL:url placeholderImage:holderImg options:SDWebImageLowPriority];
            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageLoop:)];
            
            [imageView addGestureRecognizer:tap];
            
            
            imageView.frame = CGRectOffset(self.scrollView.frame, i *self.frame.size.width, 0);
            imageView.userInteractionEnabled = YES;
            [self.scrollView addSubview:imageView];
        }
        



        [self addSubview:self.scrollView];
    
    
    //默认显示第零张
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    [self startTimer];
    
    /*pageControl*/
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.bounds.size.width-80)*0.5, CGRectGetMaxY(self.scrollView.frame)-40, 80, 20)];
    self.pageControl.numberOfPages = (self.images.count-2);
    self.pageControl.pageIndicatorTintColor = [UIColor cyanColor];
    [self addSubview:self.pageControl];
    

    
}
-(void)startTimer
{
    //启动定时器
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        
    }
}

-(void)timerFire:(NSTimer*)timer
{
    //设置scrollView的偏移
    
    CGPoint point = CGPointZero;
    if (self.scrollView.contentOffset.x < (self.images.count - 1)*self.frame.size.width) {
        point = CGPointMake(self.scrollView.contentOffset.x + self.frame.size.width, 0);
        [UIView animateWithDuration:3.0f animations:^{
            [self.scrollView setContentOffset:point animated:YES];

        }];
    }else
    {
        point = CGPointMake(self.frame.size.width, 0);
        [self.scrollView setContentOffset:point];
        
        [self timerFire:nil];
    }
    
    
}

-(void)stopTimer
{
    //停止一个定时器
    [self.timer invalidate];
    self.timer = nil;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖拽
    [self stopTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //停止拖拽
    [self startTimer];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x >= (self.images.count - 1) * self.bounds.size.width) {
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
        
    }else if (scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake((self.images.count - 2) * self.bounds.size.width, 0) animated:NO];
    }
    
    self.pageControl.currentPage = (scrollView.contentOffset.x - scrollView.bounds.size.width) / scrollView.bounds.size.width;
    self.startContent = self.pageControl.currentPage;
}



#pragma mark -- 实现代理方法
-(void)tapImageLoop:(UIGestureRecognizer *)gesture
{
    
    [self.myDelegate tapImageLoopToViewController];
    
    
}



@end
