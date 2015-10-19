//
//  Topic.h
//  Shaker
//
//  Created by Leading Chen on 15/4/9.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Topic : NSObject
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *creatorID;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, strong) NSString *backImageURL;
@property (nonatomic, strong) UIImage *topicImage;
@property (nonatomic, strong) NSString *topicImageURL;
@property (nonatomic, strong) UIImage *creatorImage;
@property (nonatomic, strong) NSString *creatorImageURL;
@property (nonatomic, strong) NSString *layoutID;
@property (nonatomic, strong) NSString *themeID;
@property (nonatomic, assign) NSInteger limitNum;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, strong) NSMutableArray *posts;
@end
