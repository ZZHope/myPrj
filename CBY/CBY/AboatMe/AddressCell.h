//
//  AddressCell.h
//  51CBY
//
//  Created by SJB on 14/12/22.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;





@end
