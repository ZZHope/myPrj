//
//  DirectAddressViewController.h
//  51CBY
//
//  Created by SJB on 14/12/25.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectAddressViewController : UIViewController

@property(nonatomic, copy) NSString *priceLabelText;
@property(nonatomic, strong) NSArray *commitGoods;
@property(nonatomic, strong) NSArray *commitService;
@property(nonatomic, copy) NSString *orderCarID;

@property(nonatomic, copy) NSString *priceFromCheck;
@property(nonatomic, copy) NSString *fromPriceFlag;

@property(nonatomic, strong) NSDictionary *checkGoodsTemp;

@end
