//
//  Post.h
//  Shaker2
//
//  Created by Leading Chen on 15/3/31.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Post : NSObject
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *topicID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger dislikeNum;
@property (nonatomic, strong) NSString *creatorID;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) UIImage *creatorImage;
@property (nonatomic, strong) NSString *creatorImageURL;
@property (nonatomic, strong) NSMutableArray *cards;

@end
