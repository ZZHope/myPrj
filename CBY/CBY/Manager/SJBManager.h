//
//  SJBManager.h
//  51CBY
//
//  Created by SJB on 14/12/12.
//  Copyright (c) 2014年 SJB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SJBViewControllerType) {
    SJBControllerTypeUserGuideView,
    SJBControllerTypeLoginView,
    SJBControllerTypeMainView
};


@interface SJBManager : NSObject

+ (void)prsentSJBControllerWithType:(SJBViewControllerType)controllerType;
@end
