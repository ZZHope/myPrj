//
//  NavigationBar.h
//  Shaker2
//
//  Created by Leading Chen on 15/3/30.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBarDelegate <NSObject>
@optional
- (void)leftBtnClicked;
- (void)rightBtnClicked;
- (void)otherBtnClicked;
@end

@interface NavigationBar : UIView
@property (nonatomic, strong) id <NavigationBarDelegate> delegate;

- (void)setBackColor:(UIColor *)backgroundColor;
- (void)setLeftBtnWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font;
- (void)setRightBtnWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font;
- (void)setLeftBtn:(UIImage *)image;
- (void)setRightBtn:(UIImage *)image;
- (void)setTitleTextView:(NSAttributedString *)text;
- (void)setOtherButton:(CGRect)frame :(UIImage *)image :(NSString *)text;
- (void)setTitleImageView:(UIImage *)image;
- (void)enableRightBtn;
- (void)disableRightBtn;
@end
