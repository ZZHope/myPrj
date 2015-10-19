//
//  MainViewController.m
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "AboutMeViewController.h"
#import "RepairViewController.h"
#import "ServiceViewController.h"


@interface MainViewController ()<UINavigationControllerDelegate>

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       
        //self.tabBar.items
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
   
    
    AboutMeViewController *AboutViewController = [[AboutMeViewController alloc] init];
    RepairViewController *repairViewController = [[RepairViewController alloc] init];
    ServiceViewController *serviceViewController = [[ServiceViewController alloc] init];
    
    
    NSArray *viewControllers = @[homeViewController,repairViewController,serviceViewController,AboutViewController];
    
    NSMutableArray *navViewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (UIViewController *viewControllerItem in viewControllers) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewControllerItem];
        
        [navViewControllers addObject:nav];
        
    }
    self.viewControllers = navViewControllers;
    
    self.tabBar.translucent = NO;
    UIImage *img = [UIImage imageNamed:@"底部背景"];
    [img resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    
    self.tabBar.backgroundImage = img;
    self.tabBar.translucent = NO;
    //self.tabBar.backgroundColor = [UIColor grayColor];
   
    
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
