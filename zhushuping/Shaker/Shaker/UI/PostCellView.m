//
//  PostCellView.m
//  Shaker2
//
//  Created by Leading Chen on 15/3/31.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "PostCellView.h"
#import "ColorHandler.h"
#import "UIImageView+WebCache.h"
#import "ProgressHUD.h"

@implementation PostCellView {
    UILabel *likeLabel;
}

- (id)initWithFrame:(CGRect)frame Topic:(Topic *)topic {
    self = [super initWithFrame:frame];
    if (self) {
        _topic = topic;
        [self addTarget:self action:@selector(didChoose) forControlEvents:UIControlEventTouchUpInside];
        [self buildView];
    }
    return self;
}

- (id)initPersonalPostWithFrame:(CGRect)frame Topic:(Topic *)topic {
    self = [super initWithFrame:frame];
    if (self) {
        _topic = topic;
        [self addTarget:self action:@selector(didChoose) forControlEvents:UIControlEventTouchUpInside];
        [self buildView2];
    }
    return self;
}


//首页
- (void)buildView {
    
    //间距调节
    self.backgroundColor = [UIColor whiteColor];
    _topicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-2,(self.bounds.size.width-2)*559/375 )];//height=278 将278全部替换为(self.bounds.size.width-2)*1.5 )//CGRectGetMaxY(_creatorImageView.frame)-
    if (_topic.topicImage) {
        _topicImageView.image = _topic.topicImage;
    } else {
        
        [_topicImageView sd_setImageWithURL:[NSURL URLWithString:_topic.topicImageURL] placeholderImage:[UIImage imageNamed:@"topicPlaceholder"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            _topic.topicImage = image;
        }];
    }
    [self addSubview:_topicImageView];
    
    _creatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.width-2)*1.5+4, 24, 24)];
  
    if (_topic.creatorImage) {
        _creatorImageView.image = _topic.creatorImage;
    } else {
        
        //由于命名规则里面有用户名，用中文的话，需要转码，否则  [NSURL URLWithString:_topic.creatorImageURL]= nil;

        [_creatorImageView sd_setImageWithURL:[NSURL URLWithString:[_topic.creatorImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"placeHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _topic.creatorImage = image;
        }];
    }
    
//坐标位置改过
    UILabel *creatorNameLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%@",_topic.creatorName] :[ColorHandler colorWithHexString:@"#00d8a5"] :[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:10]];
    [creatorNameLabel setFrame:CGRectMake(39, _creatorImageView.frame.origin.y+(_creatorImageView.bounds.size.height - creatorNameLabel.bounds.size.height)/2, creatorNameLabel.bounds.size.width, creatorNameLabel.bounds.size.height)];//0527
    [self addSubview:creatorNameLabel];
    
    _creatorImageView.layer.cornerRadius = 2;
    [self addSubview:_creatorImageView];
    
    UIImage *likeIcon_h = [UIImage imageNamed:@"like_h"];
    UIImageView *likeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-10-likeIcon_h.size.width, _creatorImageView.frame.origin.y+(_creatorImageView.bounds.size.height-likeIcon_h.size.height)/2, likeIcon_h.size.width, likeIcon_h.size.height)];//20150527
    likeIconView.image = likeIcon_h;
    [self addSubview:likeIconView];
    
    likeLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%d",(int)_topic.likeNum] :[ColorHandler colorWithHexString:@"#2a2a2a"] :[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:11]];
    [likeLabel setFrame:CGRectMake(likeIconView.frame.origin.x-4-likeLabel.bounds.size.width, _creatorImageView.frame.origin.y+(_creatorImageView.bounds.size.height-likeLabel.bounds.size.height)/2, likeLabel.bounds.size.width, likeLabel.bounds.size.height)];//20150527
    [self addSubview:likeLabel];

    
}

//个人主页
- (void)buildView2 {
    self.backgroundColor = [UIColor whiteColor];
    _topicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width*559/375)];//20150527
    if (_topic.topicImage) {
        _topicImageView.image = _topic.topicImage;
    } else {
        [_topicImageView sd_setImageWithURL:[NSURL URLWithString:_topic.topicImageURL]];
    }
    [self addSubview:_topicImageView];
    
    _creatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _topicImageView.frame.origin.y+_topicImageView.bounds.size.height+8, 24, 24)];//20150527
    
    if (_topic.creatorImage) {
        _creatorImageView.image = _topic.creatorImage;
    } else {
        [_creatorImageView sd_setImageWithURL:[NSURL URLWithString:[_topic.creatorImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];  //防止有汉语字体出现没有图像
    }
    _creatorImageView.layer.cornerRadius = 2;
    [self addSubview:_creatorImageView];
    UILabel *creatorNameLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%@",_topic.creatorName] :[ColorHandler colorWithHexString:@"#00d8a5"] :[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:10]];
    [creatorNameLabel setFrame:CGRectMake(39,_creatorImageView.frame.origin.y+(_creatorImageView.bounds.size.height-creatorNameLabel.bounds.size.height)/2 , creatorNameLabel.bounds.size.width, creatorNameLabel.bounds.size.height)];//20150527
    [self addSubview:creatorNameLabel];
    
    UIImage *likeIcon_h = [UIImage imageNamed:@"like_h"];
    UIImageView *likeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-10-likeIcon_h.size.width, _creatorImageView.frame.origin.y+(_creatorImageView.bounds.size.height-likeIcon_h.size.height)/2, likeIcon_h.size.width, likeIcon_h.size.height)];//20150527
    likeIconView.image = likeIcon_h;
    [self addSubview:likeIconView];
    
    likeLabel = [self buildLabel:[[NSString alloc] initWithFormat:@"%d",(int)_topic.likeNum] :[ColorHandler colorWithHexString:@"#2a2a2a"] :[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:11]];
    [likeLabel setFrame:CGRectMake(likeIconView.frame.origin.x-4-likeLabel.bounds.size.width, _creatorImageView.frame.origin.y+(_creatorImageView.bounds.size.height-likeLabel.bounds.size.height)/2, likeLabel.bounds.size.width, likeLabel.bounds.size.height)];//20150527
    [self addSubview:likeLabel];

}


- (void)didChoose {
    [self.delegate didChooseTopic:_topic];
}

- (UILabel *)buildLabel:(NSString *)text :(UIColor *)textColor :(UIFont *)font {
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    [label setFrame:CGRectMake(0, 0, ceilf(size.width), ceilf(size.height))];
    
    return label;
}


@end
