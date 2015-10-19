//
//  ShakerDatabase.h
//  Shaker2
//
//  Created by Leading Chen on 15/3/30.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "UserInfo.h"
#import "Post.h"
#import "Topic.h"
#import "Card.h"

@interface ShakerDatabase : NSObject
- (void)openDatabase;
- (void)closeDatabase;
- (BOOL)createAllTables;
- (BOOL)setUser:(UserInfo *)user;
- (BOOL)updateUser:(UserInfo *)user;
- (NSString *)getUserPassword:(UserInfo *)user;
- (BOOL)updateUserPassword:(UserInfo *)user;
- (UserInfo *)getUserInfo;
- (BOOL)setLastUesdUser:(UserInfo *)user;
- (BOOL)whetherUserExisted:(UserInfo *)user;
- (BOOL)createNewTopic:(Topic *)topic;
- (NSMutableArray *)getAllTopicsByUser:(UserInfo *)user; //add user restriction
//- (NSMutableArray *)getAllTopics;
- (BOOL)createNewPost:(Post *)post;
- (Post *)getPostWithID:(NSString *)ID;
//- (BOOL)collectTopic:(Topic *)topic;
//- (NSMutableArray *)getAllCollectedTopics;
- (NSMutableArray *)getAllCollectedTopicsByUser:(UserInfo *)user; //add user restriction
//- (BOOL)deleteCardWithCardID:(NSString *)ID;
//- (NSMutableArray *)getAllPosts;


- (BOOL)collectTopic:(Topic *)topic ByUser:(UserInfo *)user;

@end
