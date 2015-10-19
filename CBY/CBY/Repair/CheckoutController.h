//
//  CheckoutController.h
//  51CBY
//
//  Created by SJB on 15/1/4.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, copy) NSString *orderCode;
@property(nonatomic, copy) NSString *orderDescription;
@property(nonatomic, copy) NSString *finalPrice;

@end
