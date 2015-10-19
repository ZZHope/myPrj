//
//  TopicCell2.m
//  Shaker
//
//  Created by Leading Chen on 15/4/13.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "TopicCell2.h"
#import "ColorHandler.h"
#import "Contants.h"
#import "UIImageView+WebCache.h"
@implementation TopicCell2 {
    UIImageView *topicImageView;
}
- (id)initWithFrame:(CGRect)frame Topic:(Topic *)topic {
    self = [super initWithFrame:frame];
    if (self) {
        _topic = topic;
        [self buildView];
    }
    return self;
}

- (void)buildView {
    topicImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    if (_topic.topicImage) {
        topicImageView.image = _topic.topicImage;
    } else {
        [topicImageView sd_setImageWithURL:[NSURL URLWithString:_topic.topicImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _topic.topicImage = topicImageView.image;
        }];
        
    }
    
    UIImageView *creatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 456, 35, 35)];
    creatorImageView.layer.cornerRadius = 2;
    if (_topic.creatorImage) {
        creatorImageView.image = _topic.creatorImage;
    } else {
        [creatorImageView sd_setImageWithURL:[NSURL URLWithString:_topic.creatorImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _topic.creatorImage = creatorImageView.image;
        }];
    }
    [topicImageView addSubview:creatorImageView];
    
    NSString *creatorHeadText;
    if (_topic.limitNum == 0) {
        creatorHeadText = @"作者";
    } else {
        creatorHeadText = @"发起人";
    }
    UILabel *creatorHead = [self buildLabel:creatorHeadText color:[ColorHandler colorWithHexString:@"#a7a7a7"] font:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12]];
    [creatorHead setFrame:CGRectMake(66, 470-creatorHead.bounds.size.height, creatorHead.bounds.size.width, creatorHead.bounds.size.height)];
    [topicImageView addSubview:creatorHead];
    UILabel *creatorLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%@",_topic.creatorName] color:[ColorHandler colorWithHexString:@"#00d8a5"] font:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12]];
    [creatorLabel setFrame:CGRectMake(66, 486-creatorLabel.bounds.size.height, creatorLabel.bounds.size.width, creatorLabel.bounds.size.height)];
    [topicImageView addSubview:creatorLabel];
    
    UIImage *likeImage = [UIImage imageNamed:@"likeIcon_u"];
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(197, 486-likeImage.size.height, likeImage.size.width, likeImage.size.height)];
    likeImageView.image = likeImage;
    [topicImageView addSubview:likeImageView];
    UILabel *likeNumLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%d",(int)_topic.likeNum]  color:[ColorHandler colorWithHexString:@"#a7a7a7"] font:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [likeNumLabel setFrame:CGRectMake(216, 486-likeNumLabel.bounds.size.height, likeNumLabel.bounds.size.width, likeNumLabel.bounds.size.height)];
    [topicImageView addSubview:likeNumLabel];
    
    if (_topic.limitNum > 0) {
        UIImage *limitNumImage = [UIImage imageNamed:@"limitNumIcon"];
        UIImageView *limitNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(245, 486-limitNumImage.size.height, limitNumImage.size.width, limitNumImage.size.height)];
        limitNumImageView.image = limitNumImage;
        [topicImageView addSubview:limitNumImageView];
        UILabel *limitNumLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%d 人参与",(int)_topic.limitNum]  color:[ColorHandler colorWithHexString:@"#a7a7a7"] font:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
        [limitNumLabel setFrame:CGRectMake(263, 486-limitNumLabel.bounds.size.height, limitNumLabel.bounds.size.width, likeNumLabel.bounds.size.height)];
        [topicImageView addSubview:limitNumLabel];
    }
    
    [self addSubview:topicImageView];
}

- (UILabel *)buildLabel:(NSString *)text color:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    [label setFrame:CGRectMake(0, 0, ceilf(size.width), ceilf(size.height))];
    
    return label;
}

@end
