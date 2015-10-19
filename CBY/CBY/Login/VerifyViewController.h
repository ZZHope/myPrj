//
//  VerifyViewController.h
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyViewController : UIViewController <UIAlertViewDelegate>

@property(nonatomic,strong)  UILabel* telLabel;
@property(nonatomic,strong)  UITextField* verifyCodeField;
@property(nonatomic,strong)  UILabel* timeLabel;
@property(nonatomic,strong)  UIButton* repeatSMSBtn;
@property(nonatomic,strong)  UIButton* submitBtn;
@property(nonatomic,copy)   NSString* isVerify;
@property(nonatomic, copy) NSString *phone;

@property(nonatomic,assign) int comeFromFlag; //3：修改密码
@property(nonatomic,copy) NSString *carIDOrder;
@property(nonatomic,strong) NSArray *goodsArrFromOrder;
@property(nonatomic,strong) NSArray *serviceArrFromOrder;
@property(nonatomic, strong) NSMutableArray *goodsTemp;

@property(nonatomic, strong) NSDictionary *checkGoods;


-(void)setPhone:(NSString*)phone AndAreaCode:(NSString*)areaCode;
-(void)submit;
-(void)CannotGetSMS;

@end
