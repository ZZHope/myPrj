//
//  commonSenseCell.h
//  51CBY
//
//  Created by SJB on 15/1/14.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYFocusButton.h"

@interface CommonSenseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet MYFocusButton *focusBtn;


@property (weak, nonatomic) IBOutlet UIButton *timeLabel;
@end
