//
//  HomeServiceController.h
//  51CBY
//
//  Created by SJB on 14/12/24.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^MyReturnBlock) (NSDictionary * carModel);


@interface HomeServiceController : UIViewController


@property(nonatomic,copy) MyReturnBlock  myBlock;
@property(nonatomic,copy) NSString *labelText;



-(void)returnCarModelData:(MyReturnBlock) myBlock;


@end
