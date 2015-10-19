//
//  ChangeSexViewController.h
//  51CBY
//
//  Created by SJB on 15/1/7.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBlock) (NSString * text);


@interface ChangeSexViewController : UIViewController
@property (nonatomic, copy) MyBlock myBlock;



-(void)returnSex:(MyBlock)block;

@end
