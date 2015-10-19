//
//  CarBareViewController.h
//  51CBY
//
//  Created by SJB on 14/12/29.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CarBareReturn) (NSDictionary * carBareInfo);

@interface CarBareViewController : UIViewController

@property(nonatomic, copy) CarBareReturn carBareInfo;
@property(nonatomic, assign) int needReturnInfo;



-(void) returnCareBareInfo:(CarBareReturn)carBareInfo;

@end
