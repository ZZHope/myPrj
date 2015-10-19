//
//  ManageAddressController.h
//  51CBY
//
//  Created by SJB on 15/1/27.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyReturnBlock) (NSDictionary * newAddress);

@interface ManageAddressController : UIViewController
@property(nonatomic, assign) int changeFlag;
@property(nonatomic,copy) MyReturnBlock myAddressReturn;

-(void)returnMyNewAddress:(MyReturnBlock)myReturn;

@end
