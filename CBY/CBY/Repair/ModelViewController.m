//
//  ModelViewController.m
//  51CBY
//
//  Created by SJB on 14/12/17.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "ModelViewController.h"
#import "CarModelsView.h"
#import "YouHaoViewController.h"
#import "CbyDataBaseManager.h"
#import "DBCommon.h"
@interface ModelViewController ()
@property(nonatomic,strong)NSArray* arr;
@end

@implementation ModelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textlabel.text = @"车系";
        textlabel.font = [UIFont boldSystemFontOfSize:20];
        textlabel.textAlignment = NSTextAlignmentCenter;
        textlabel.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = textlabel;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.arr = [NSArray array];
    
    CbyDataBaseManager *cbyCar = [CbyDataBaseManager shareInstance];
    self.arr = [cbyCar carModelQueryFromDB:kCarTable withPID:self.string];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    
    YouHaoViewController *detailViewController = [[YouHaoViewController alloc] initWithNibName:nil bundle:nil];
    
    detailViewController.carName = [self.carName stringByAppendingString:[NSString stringWithFormat:@" %@",[self.arr[indexPath.row] objectForKey:@"n"]]];
    
    self.modelStr = [self.arr[indexPath.row] objectForKey:@"i"];
    
    detailViewController.youHaoStr = self.modelStr;
    
    detailViewController.dic = self.dic;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
