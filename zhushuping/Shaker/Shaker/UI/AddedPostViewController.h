//
//  AddedPostViewController.h
//  Shaker
//
//  Created by Leading Chen on 15/4/15.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "Card.h"
#import "UserInfo.h"
#import "ShakerDatabase.h"

@protocol AddedPostViewControllerDelegate <NSObject>

- (void)didEditCardArray:(NSMutableArray *)cardArray atIndex:(NSInteger)index;

@end

@interface AddedPostViewController : UIViewController <NavigationBarDelegate>
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, strong) ShakerDatabase *database;
@property (nonatomic, strong) NSMutableArray *addedCardArray;
@property (nonatomic, strong) id<AddedPostViewControllerDelegate> delegate;

@end
