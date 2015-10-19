//
//  Card.h
//  Shaker
//
//  Created by Leading Chen on 15/4/15.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Card : NSObject
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage *cardImage;
@property (nonatomic, strong) NSString *cardImageURL;
@property (nonatomic, strong) NSString *layoutID;
@property (nonatomic, assign) NSInteger layoutIndex;
@property (nonatomic, assign) NSInteger index;
@end
