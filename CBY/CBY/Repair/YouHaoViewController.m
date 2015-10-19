//
//  YouHaoViewController.m
//  51CBY
//
//  Created by SJB on 14/12/18.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "YouHaoViewController.h"
#import "YearViewController.h"
#import "CbyDataBaseManager.h"
#import "DBCommon.h"

@interface YouHaoViewController ()
@property(strong, nonatomic)NSArray *arr;
@property (strong, nonatomic) NSString *string;
@end

@implementation YouHaoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textlabel.text = @"排量";
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
    self.arr = [cbyCar carDisChargeQueryFromDB:kCarTable withPID:self.youHaoStr];
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

    YearViewController *detailViewController = [[YearViewController alloc] initWithNibName:nil bundle:nil];

    detailViewController.carName = [self.carName stringByAppendingString:[NSString stringWithFormat:@" %@",[self.arr[indexPath.row] objectForKey:@"n"]]];
    self.string = [self.arr[indexPath.row] objectForKey:@"i"];

    detailViewController.yearStr = self.string;
    detailViewController.dic = self.dic;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
