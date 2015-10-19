//
//  Score.h
//  51CBY
//
//  Created by SJB on 14/12/23.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject

@property(strong,nonatomic) NSNumber* age;
@property(strong,nonatomic) NSNumber* care;
@property(strong,nonatomic) NSNumber* changePower;
@property(strong,nonatomic) NSNumber* engin;
@property(assign,nonatomic) BOOL hugeRepaire ;
@property(strong,nonatomic) NSNumber* jurney;
@property(assign,nonatomic) BOOL line;
@property(strong,nonatomic) NSNumber* rain;
@property(strong,nonatomic) NSNumber* tire;
@property(strong,nonatomic) NSNumber* unFrozen;

-(int)scoreValue;

@end
