//
//  UIBarButtonItem+Item.h
//  financer
//
//  Created by  淑萍 on 16/5/30.
//  Copyright © 2016年 Jney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

+(UIBarButtonItem *)ItemWithImage:(UIImage *)img highLight:(UIImage *)highImg target:(id)target action:(SEL)action;

@end
