//
//  NewAddressCell.h
//  51CBY
//
//  Created by SJB on 15/1/27.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYFocusButton.h"

@interface NewAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MYFocusButton *selBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
