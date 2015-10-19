//
//  ChangeSexViewController.m
//  51CBY
//
//  Created by SJB on 15/1/7.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "ChangeSexViewController.h"

@interface ChangeSexViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *titleArr;

@end

int sexFlag = 10;

@implementation ChangeSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //右视图
//    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
//    [settingBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [settingBtn addTarget:self action:@selector(certainChange:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    //tableView
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    // 数据源
    
    self.titleArr = [NSArray array];
    self.titleArr = @[@"男",@"女",@"保密"];
}

#pragma mark -- tableView Delegate / datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    sexFlag = (int )indexPath.row;
    if (self.myBlock != nil) {
        self.myBlock(self.titleArr[sexFlag]);
    }
    [self.navigationController popViewControllerAnimated:YES];



}



#pragma mark -- target - action
-(void)certainChange:(UIButton *)sender
{
//    if (self.myBlock != nil) {
//        self.myBlock(self.titleArr[sexFlag]);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -- bolck传递回修改的值
-(void)returnSex:(MyBlock)block
{
    self.myBlock = block;
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
