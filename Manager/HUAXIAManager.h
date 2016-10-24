//
//  HUAXIAManager.h
//  financer
//
//  Created by  淑萍 on 16/6/22.
//  Copyright © 2015年 HuaxiaFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HUAXIAViewControllerType) {
    HUAXIAControllerTypeLoginView,
    HUAXIAControllerTypeMainView
};


@interface HUAXIAManager : NSObject

+ (void)presentHUAXIAControllerWithType:(HUAXIAViewControllerType)controllerType;


@end
