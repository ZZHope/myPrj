//
//  DiscountTableViewCell.h
//  51CBY
//
//  Created by SJB on 14/12/30.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validTime;
@property (weak, nonatomic) IBOutlet UIButton *distributeBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@end
