//
//  UIBarButtonItem+Item.m
//  financer
//
//  Created by  淑萍 on 16/5/30.
//  Copyright © 2016年 Jney. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+(UIBarButtonItem *)ItemWithImage:(UIImage *)img highLight:(UIImage *)highImg target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:highImg forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

@end
