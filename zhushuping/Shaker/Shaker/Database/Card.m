//
//  Card.m
//  Shaker
//
//  Created by Leading Chen on 15/4/15.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "Card.h"

@implementation Card
- (id)init {
    self = [super init];
    if (self) {
        _UUID = @"";
        _postID = @"";
        _content =@"";
        _image = nil;
        _imageURL = @"";
        _cardImage = nil;
        _cardImageURL = @"";
        _layoutID = @"";
        _index = 0;
    }
    return self;
}
@end
