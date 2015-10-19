//
//  RepairViewController.h
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary *dic;

@property(nonatomic, copy) NSString *carbackID;
@property (strong, nonatomic)UITextField *textField;

@end
