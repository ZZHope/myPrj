//
//  CarBareTableViewCell.h
//  51CBY
//
//  Created by SJB on 15/1/31.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarBareTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
