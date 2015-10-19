//
//  Post.m
//  Shaker2
//
//  Created by Leading Chen on 15/3/31.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "Post.h"

@implementation Post
- (id)init {
    self = [super init];
    if (self) {
        _UUID = @"";
        _topicID = @"";
        _type = @"";
        _creatorID = @"";
        _creatorName = @"";
        _creatorImage = nil;
        _creatorImageURL = @"";
        _likeNum = 0;
        _cards = [NSMutableArray new];
    }
    return self;
}
@end
