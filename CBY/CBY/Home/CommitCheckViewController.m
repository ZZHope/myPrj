//
//  CommitCheckViewController.m
//  51CBY
//
//  Created by SJB on 14/12/30.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import "CommitCheckViewController.h"

@interface CommitCheckViewController ()<UITextFieldDelegate>

@end

@implementation CommitCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)commitCheckService:(UIButton *)sender {
    
    
    NSLog(@"提交免费检测的订单。。。。");
}

#pragma mark --textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
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
