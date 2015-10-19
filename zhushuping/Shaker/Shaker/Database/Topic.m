//
//  Topic.m
//  Shaker
//
//  Created by Leading Chen on 15/4/9.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "Topic.h"

@implementation Topic

- (id)init {
    self = [super init];
    if (self) {
        _UUID = @"";
        _title = @"";
        _content = @"";
        _type = @"";
        _creatorID = @"";
        _creatorName = @"";
        _backImage = nil;
        _backImageURL = @"";
        _topicImage = nil;
        _creatorImage = nil;
        _layoutID = @"";
        _themeID = @"theme_01";
        _limitNum = 99;
        _likeNum = 0;
        _posts = [NSMutableArray new];
    }
    return self;
}

@end
