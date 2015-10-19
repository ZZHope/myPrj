//
//  MYBoolButton.h
//  51CBY
//
//  Created by SJB on 15/1/15.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYFocusButton : UIButton

@property(nonatomic,assign) BOOL flag;
@property(nonatomic,assign) BOOL selFlag;

-(void)setSelFlag:(BOOL)selFlag andImg:(NSString *)imgName highLightImg:(NSString *)selImg;

@end
