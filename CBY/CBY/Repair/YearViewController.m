//
//  YearViewController.m
//  51CBY
//
//  Created by SJB on 14/12/18.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "YearViewController.h"
#import "RepairViewController.h"
#import "DBCommon.h"
#import "CbyDataBaseManager.h"
#import "SchemeViewController.h"
#import "AFNCommon.h"
#import "CbyUserSingleton.h"

@interface YearViewController ()
@property(strong, nonatomic)NSArray *arr;
@property(strong, nonatomic) CbyUserSingleton *finalCarInfo;

@end

@implementation YearViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textlabel.text = @"年份";
        textlabel.font = [UIFont boldSystemFontOfSize:20];
        textlabel.textAlignment = NSTextAlignmentCenter;
        textlabel.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = textlabel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arr = [NSArray array];
    
    //user
    _finalCarInfo = [CbyUserSingleton shareUserSingleton];
    
    CbyDataBaseManager *cbyCar = [CbyDataBaseManager shareInstance];
    self.arr = [cbyCar carYearQueryFromDB:kCarTable withPID:self.yearStr];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

 
    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [self.arr[indexPath.row] objectForKey:@"n"];
    
    return cell;
}
               

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //取到最后生成的car_id
    self.string = [self.arr[indexPath.row] objectForKey:@"car_id"];
    
    //拼接成完整车型的字符串
    NSString *string = [NSString string];
    string = [self.carName stringByAppendingString:[NSString stringWithFormat:@" %@",[self.arr[indexPath.row] objectForKey:@"n"]]];
    
        if (self.dic == nil) {
            
            RepairViewController *rootVC = (RepairViewController *)self.navigationController.viewControllers[0];
            rootVC.textField.text = string;
            rootVC.carbackID = self.string;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else {
            
            SchemeViewController *svc = [[SchemeViewController alloc]init];
            svc.hidesBottomBarWhenPushed = YES;
            svc.strUrl = kShareUrl;
            self.finalCarInfo.carID = self.string;
            svc.carString = string;
            [self.dic setObject:self.string forKey:@"car_id"];
            svc.parameter = self.dic;
            [self.navigationController pushViewController:svc animated:YES];
        }
    
    
}



@end
