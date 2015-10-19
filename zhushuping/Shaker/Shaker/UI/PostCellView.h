//
//  PostCellView.h
//  Shaker2
//
//  Created by Leading Chen on 15/3/31.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Topic.h"

@protocol PostCellDelegate <NSObject>

@optional
- (void)didChooseTopic:(Topic *)topic;

@end

@interface PostCellView : UIControl
@property (nonatomic, strong) Topic *topic;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) UIImageView *topicImageView;
@property (nonatomic, strong) UIImageView *creatorImageView;
@property (nonatomic, strong) id <PostCellDelegate> delegate;


- (id)initWithFrame:(CGRect)frame Topic:(Topic *)topic;
- (id)initPersonalPostWithFrame:(CGRect)frame Topic:(Topic *)topic;
@end
