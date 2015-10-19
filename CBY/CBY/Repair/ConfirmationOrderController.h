//
//  ConfirmationOrderController.h
//  51CBY
//
//  Created by SJB on 15/1/27.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmationOrderController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic)NSMutableArray *shopCartlist;
@property (strong, nonatomic)NSMutableDictionary *addressInfo;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
