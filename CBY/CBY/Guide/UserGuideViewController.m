//
//  UserGuideViewController.m
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "UserGuideViewController.h"
#import "SJBManager.h"

#define Width  self.view.bounds.size.width
#define Height self.view.bounds.size.height
#define PageControllWidth  120

@interface UserGuideViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageController;

@end

@implementation UserGuideViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       //self.view.backgroundColor = [UIColor grayColor];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    const NSUInteger nPageCount = 3;
    self.scrollView.contentSize = CGSizeMake(Width*nPageCount, Height);
    self.scrollView.contentSize = CGSizeMake(Width * nPageCount, Height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
   
    
    //    设置scrollView上的显示内容UIImageView
    for (int i = 0; i < nPageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Width* i,0,Width,Height)];
        imageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"new_features_%d.jpg",i+1]]resizableImageWithCapInsets:UIEdgeInsetsMake(265, 0, 214, 0) resizingMode:UIImageResizingModeStretch];
        [self.scrollView addSubview:imageView];
        
    }
    
    
    
    //pageController
    _pageController = [[UIPageControl alloc]initWithFrame:CGRectMake((Width-PageControllWidth)/2.0, Height-50.0, PageControllWidth, 20)];
    self.pageController.numberOfPages = nPageCount;
    self.pageController.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageController.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageController];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    //计算一下，scrollView滑动的偏移位置
    //通过偏移计算，当前滑动是否是最后一个页面并偏移了指定位置
    
    NSUInteger offset = Width * 2 + 80;
    if (scrollView.contentOffset.x - offset > 0) {
        [SJBManager prsentSJBControllerWithType:SJBControllerTypeMainView];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
//    //显示当前页面
    self.pageController.currentPage = scrollView.contentOffset.x/Width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
