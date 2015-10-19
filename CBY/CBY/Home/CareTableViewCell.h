//
//  CareTableViewCell.h
//  51CBY
//
//  Created by SJB on 14/12/25.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
