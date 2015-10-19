//
//  AddressViewController.h
//  51CBY
//
//  Created by SJB on 15/1/27.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock) (NSDictionary *dic);

@interface AddressViewController : UIViewController
@property(nonatomic,strong) NSMutableArray *existArr;
@property(nonatomic,copy)   NSString *modifyAddressID;
@property(nonatomic,copy) ReturnTextBlock myAddressBlock;

//@property (nonatomic,assign) int chooseAddressFlag;


-(void)returnNewAddressInfo:(ReturnTextBlock)myAddressBlock;


@end
