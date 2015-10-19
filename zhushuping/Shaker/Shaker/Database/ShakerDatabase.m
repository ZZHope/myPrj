//
//  ShakerDatabase.m
//  Shaker2
//
//  Created by Leading Chen on 15/3/30.
//  Copyright (c) 2015年 Shaker. All rights reserved.
//

#import "ShakerDatabase.h"
#import "Contants.h"

@implementation ShakerDatabase
static sqlite3 *_database;

- (id)init {
    self = [super init];
    return self;
}

- (void)openDatabase {
    NSArray *sqLiteDbPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *sqLiteDb = [[sqLiteDbPaths objectAtIndex:0] stringByAppendingPathComponent:@"Shaker2.sqlite3"];
    if (sqlite3_open([sqLiteDb UTF8String], &_database) == SQLITE_OK) {
        NSLog(@"open is ok");
    }
    
    
}

- (void)closeDatabase {
    sqlite3_close(_database);
    NSLog(@"close is ok");
}

- (BOOL)createAllTables {
    [self openDatabase];
    char *errMsg;
    const char *createUserInfoSQL = "create table if not exists userinfo (user_id text, name text default null,desc text default null,phone text default null,photo blob defalut null,background_pic blob default null,QQ text default null,weibo text default null,weixin text default null,password text,gender text default null,deviceToken text,last_used integer default 0,ID text)";
    if (sqlite3_exec(_database, createUserInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"userinfo created");
    } else {
        NSLog(@"userinfo creation failed!");
        [self ErrorReport:createUserInfoSQL];
        [self closeDatabase];
        return NO;
    }
    
    const char *createTopicInfoSQL = "create table if not exists topicinfo (id text, title text default null, content text default null,backImage blob defalut null,topicImage blob defalut null,limitNum integer default 0,likeNum integer default 0,type text default null,categoryid text default null,layoutID text default null,creatorID text default null,creatorName text default null,creatorImage blob defalut null,createdAt timestamp default current_timestamp,updatedAt timestamp default current_timestamp)";
    if (sqlite3_exec(_database, createTopicInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"entityinfo created");
    } else {
        NSLog(@"entityinfo creation failed!");
        [self ErrorReport:createTopicInfoSQL];
        [self closeDatabase];
        return NO;
    }
    
    const char *createPostInfoSQL = "create table if not exists postinfo (id text, topicID text default null,likeNum integer default 0,type text default null,creatorID text default null,creatorName text default null,creatorImage blob defalut null,createdAt timestamp default current_timestamp,updatedAt timestamp default current_timestamp)";
    if (sqlite3_exec(_database, createPostInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"postinfo created");
    } else {
        NSLog(@"postinfo creation failed!");
        [self ErrorReport:createPostInfoSQL];
        [self closeDatabase];
        return NO;
    }
    
    const char *createCardInfoSQL = "create table if not exists cardinfo (id text, postID text default null, content text default null,image blob defalut null,cardImage blob defalut null,likeNum integer default 0,type text default null,layoutID text default null,createdAt timestamp default current_timestamp,updatedAt timestamp default current_timestamp)";
    if (sqlite3_exec(_database, createCardInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"postinfo created");
    } else {
        NSLog(@"postinfo creation failed!");
        [self ErrorReport:createCardInfoSQL];
        [self closeDatabase];
        return NO;
    }
    
    const char *createTopicCollectionInfoSQL = "create table if not exists topiccollectioninfo (id text, title text default null, content text default null,backImage blob defalut null,topicImage blob defalut null,limitNum integer default 0,likeNum integer default 0,type text default null,categoryid text default null,layoutID text default null,creatorID text default null,creatorName text default null,creatorImage blob defalut null,collectorID,createdAt timestamp default current_timestamp,updatedAt timestamp default current_timestamp)";
    if (sqlite3_exec(_database, createTopicCollectionInfoSQL, NULL, NULL, &errMsg) == SQLITE_OK) {
        NSLog(@"TopicCollection created");
    } else {
        NSLog(@"TopicCollection creation failed!");
        [self ErrorReport:createTopicCollectionInfoSQL];
        [self closeDatabase];
        return NO;
    }
    
    [self closeDatabase];
    return YES;
}

- (BOOL)setUser:(UserInfo *)user {
    [self openDatabase];
    const char *insertUserInfoSQL = "Insert into userinfo (user_id,name,password,deviceToken,ID,photo) values (?,?,?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, insertUserInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.userID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [user.name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [user.password UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [user.deviceToken UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 5, [user.ID UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 6, [user.photo bytes], (int)[user.photo length], NULL);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"insert user failed!");
            [self ErrorReport:insertUserInfoSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (BOOL)updateUser:(UserInfo *)user {
    [self openDatabase];
    const char *updateUserInfoSQL = "update userinfo set name=?,desc=?,phone=?,photo=?,background_pic=?,QQ=?,weibo=?,weixin=?,gender=? where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, updateUserInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [user.desc UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [user.phone UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 4, [user.photo bytes], (int)[user.photo length], NULL);
        sqlite3_bind_blob(stmt, 5, [user.backgroundPic bytes], (int)[user.backgroundPic length], NULL);
        sqlite3_bind_text(stmt, 6, [user.QQ UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [user.weibo UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [user.weixin UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [user.gender UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 10, [user.userID UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"Update User failed!");
            [self ErrorReport:updateUserInfoSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (NSString *)getUserPassword:(UserInfo *)user {
    NSString *password;
    [self openDatabase];
    const char *getPasswordSQL = "select password from userinfo where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, getPasswordSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.userID UTF8String], -1, nil);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_column_text(stmt, 0)) {
                password = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            } else {
                password = otherLogonPassword;
            }
        }
    }
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return password;
}

- (BOOL)updateUserPassword:(UserInfo *)user {
    [self openDatabase];
    const char *updatePasswordSQL = "update userinfo set password=? where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, updatePasswordSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.password UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [user.userID UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"Update Password failed!");
            [self ErrorReport:updatePasswordSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (BOOL)whetherUserExisted:(UserInfo *)user {
    [self openDatabase];
    const char *checkSQL = "select count(*) from userinfo where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, checkSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.userID UTF8String], -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_column_int(stmt, 0) > 0) {
                sqlite3_finalize(stmt);
                [self closeDatabase];
                return YES;
            } else {
                NSLog(@"User not Exists!");
                [self ErrorReport:checkSQL];
                sqlite3_finalize(stmt);
                [self closeDatabase];
                return NO;
            }
        }
    }
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return NO;
}

- (UserInfo *)getUserInfo {
    UserInfo *user = [UserInfo new];
    [self openDatabase];
    const char *getUserInfoSQL = "select user_id,name,phone,photo,background_pic,QQ,weibo,weixin,gender,ID,password,desc from userinfo where last_used = 1";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, getUserInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_column_text(stmt, 0)) {
                user.userID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            }
            if (sqlite3_column_text(stmt, 1)) {
                user.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            } else {
                user.name = user.userID;
            }
            if (sqlite3_column_text(stmt, 2)) {
                user.phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            }
            if (sqlite3_column_bytes(stmt, 3) != 0) {
                user.photo = [NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:sqlite3_column_bytes(stmt, 3)];
            }
            if (sqlite3_column_bytes(stmt, 4) != 0) {
                user.backgroundPic = [NSData dataWithBytes:sqlite3_column_blob(stmt, 4) length:sqlite3_column_bytes(stmt, 4)];
            }
            //NSLog(@"%d",sqlite3_column_bytes(stmt, 3));
            if (sqlite3_column_text(stmt, 5)) {
                user.QQ = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
            }
            if (sqlite3_column_text(stmt, 6)) {
                user.weibo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
            }
            if (sqlite3_column_text(stmt, 7)) {
                user.weixin = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
            }
            if (sqlite3_column_text(stmt, 8)) {
                user.gender = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
            }
            if (sqlite3_column_text(stmt, 9)) {
                user.ID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
            }
            if (sqlite3_column_text(stmt, 10)) {
                user.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 10)];
            }
            if (sqlite3_column_text(stmt, 11)) {
                user.desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 11)];
            }
            
        }
    }
    
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return user;
}

- (BOOL)setLastUesdUser:(UserInfo *)user {
    [self openDatabase];
    const char *setLastUsedUserDefaultSQL = "update userinfo set last_used = 0";
    sqlite3_stmt *stmt0;
    if (sqlite3_prepare_v2(_database, setLastUsedUserDefaultSQL, -1, &stmt0, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt0) == SQLITE_DONE) {
            sqlite3_finalize(stmt0);
            [self closeDatabase];
        } else {
            NSLog(@"set last user failed!");
            [self ErrorReport:setLastUsedUserDefaultSQL];
            sqlite3_finalize(stmt0);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt0);
        [self closeDatabase];
        return NO;
    }
    
    [self openDatabase];
    const char *updateLastUsedUserSQL = "update userinfo set last_used = 1 where user_id = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, updateLastUsedUserSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.userID UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"set last user failed!");
            [self ErrorReport:updateLastUsedUserSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (BOOL)createNewTopic:(Topic *)topic {
    [self openDatabase];
    const char *insertTopicInfoSQL = "Insert into topicinfo (id,title,content,backImage,topicImage,limitNum,layoutID,creatorID,creatorName,creatorImage) values (?,?,?,?,?,?,?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, insertTopicInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [topic.UUID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [topic.title UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [topic.content UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 4, [UIImageJPEGRepresentation(topic.backImage, 1.0) bytes], (int)[UIImageJPEGRepresentation(topic.backImage, 1.0) length], NULL);
        sqlite3_bind_blob(stmt, 5, [UIImageJPEGRepresentation(topic.topicImage, 1.0) bytes], (int)[UIImageJPEGRepresentation(topic.topicImage, 1.0) length], NULL);
        sqlite3_bind_int(stmt, 6, (int)topic.limitNum);
        sqlite3_bind_text(stmt, 7, [topic.layoutID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [topic.creatorID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [topic.creatorName UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 10, [UIImageJPEGRepresentation(topic.creatorImage, 1.0) bytes], (int)[UIImageJPEGRepresentation(topic.creatorImage, 1.0) length], NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"insert user failed!");
            [self ErrorReport:insertTopicInfoSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
    
}

- (BOOL)createNewPost:(Post *)post {
    [self openDatabase];
    const char *insertPostInfoSQL = "Insert into postinfo (id,topicID,creatorID,creatorName,creatorImage) values (?,?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, insertPostInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [post.UUID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [post.topicID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [post.creatorID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [post.creatorName UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 5, [UIImageJPEGRepresentation(post.creatorImage, 1.0) bytes], (int)[UIImageJPEGRepresentation(post.creatorImage, 1.0) length], NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            for (int i=0; i<post.cards.count; i++) {
                [self createNewCard:[post.cards objectAtIndex:i]];
            }
            return YES;
        } else {
            NSLog(@"insert user failed!");
            [self ErrorReport:insertPostInfoSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (BOOL)createNewCard:(Card *)card {
    [self openDatabase];
    const char *insertCardInfoSQL = "Insert into cardinfo (id,postID,content,image,cardImage,layoutID) values (?,?,?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, insertCardInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [card.UUID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [card.postID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [card.content UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 4, [UIImageJPEGRepresentation(card.image, 1.0) bytes], (int)[UIImageJPEGRepresentation(card.image, 1.0) length], NULL);
        sqlite3_bind_blob(stmt, 5, [UIImageJPEGRepresentation(card.cardImage, 1.0) bytes], (int)[UIImageJPEGRepresentation(card.cardImage, 1.0) length], NULL);
        sqlite3_bind_text(stmt, 6, [card.layoutID UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"insert user failed!");
            [self ErrorReport:insertCardInfoSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
}

- (NSMutableArray *)getAllTopicsByUser:(UserInfo *)user {
    NSMutableArray* topics = [NSMutableArray new];
    [self openDatabase];
    const char *getAllTopicSQL = "select id,title,content,backImage,topicImage,limitNum,likeNum,layoutID,creatorID,creatorName,creatorImage from topicinfo where creatorID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, getAllTopicSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.ID UTF8String], -1, NULL);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            Topic *topic = [Topic new];
            if (sqlite3_column_text(stmt, 0)) {
                topic.UUID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            }
            if (sqlite3_column_text(stmt, 1)) {
                topic.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            }
            if (sqlite3_column_text(stmt, 2)) {
                topic.content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            }
            if (sqlite3_column_bytes(stmt, 3) != 0) {
                topic.backImage = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:sqlite3_column_bytes(stmt, 3)]];
            }
            if (sqlite3_column_bytes(stmt, 4) != 0) {
                topic.topicImage = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(stmt, 4) length:sqlite3_column_bytes(stmt, 4)]];
            }
            if (sqlite3_column_int(stmt, 5)) {
                topic.limitNum = sqlite3_column_int(stmt, 5);
            }
            if (sqlite3_column_int(stmt, 6)) {
                topic.likeNum = sqlite3_column_int(stmt, 6);
            }
            if (sqlite3_column_text(stmt, 7)) {
                topic.layoutID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
            }
            if (sqlite3_column_text(stmt, 8)) {
                topic.creatorID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
            }
            if (sqlite3_column_text(stmt, 9)) {
                topic.creatorName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
            }
            if (sqlite3_column_bytes(stmt, 10) != 0) {
                topic.creatorImage = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(stmt, 10) length:sqlite3_column_bytes(stmt, 10)]];
            }
            [topics addObject:topic];
        }
    }
    
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return topics;
}

- (Post *)getPostWithID:(NSString *)ID {
    Post *post = [Post new];
    [self openDatabase];
    const char *getPostSQL = "select id,topicID,likeNum,creatorID,creatorName,creatorImage from postinfo where id = ?";
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, getPostSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [ID UTF8String], -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_column_text(stmt, 0)) {
                post.UUID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            }
            if (sqlite3_column_text(stmt, 1)) {
                post.topicID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            }
            if (sqlite3_column_int(stmt, 2)) {
                post.likeNum = sqlite3_column_int(stmt, 2);
            }
            if (sqlite3_column_text(stmt, 3)) {
                post.creatorID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
            }
            if (sqlite3_column_text(stmt, 4)) {
                post.creatorName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
            }
            if (sqlite3_column_bytes(stmt, 5) != 0) {
                post.creatorImage = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(stmt, 5) length:sqlite3_column_bytes(stmt, 5)]];
            }
            post.cards = [self getCardWithPostID:post.UUID];
            
        }
    }
    
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return post;
}

- (NSMutableArray *)getCardWithPostID:(NSString *)postID {
    NSMutableArray *cards = [NSMutableArray new];
    const char *getPostSQL = "select id,content,image,cardImage,layoutID from postinfo where postID = ?";
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, getPostSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [postID UTF8String], -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            Card *card;
            card.postID = postID;
            if (sqlite3_column_text(stmt, 0)) {
                card.UUID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            }
            if (sqlite3_column_text(stmt, 1)) {
                card.content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            }
            if (sqlite3_column_bytes(stmt, 2) != 0) {
                card.image = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(stmt, 2) length:sqlite3_column_bytes(stmt, 2)]];
            }
            if (sqlite3_column_bytes(stmt, 3) != 0) {
                card.cardImage = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:sqlite3_column_bytes(stmt, 3)]];
            }
            if (sqlite3_column_text(stmt, 4)) {
                card.layoutID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
            }
            [cards addObject:card];
        }
    }
    return cards;
}


- (BOOL)collectTopic:(Topic *)topic ByUser:(UserInfo *)user {
    [self openDatabase];
    const char *insertTopicCollectionInfoSQL = "Insert into topiccollectioninfo (id,title,content,backImage,topicImage,limitNum,layoutID,creatorID,creatorName,creatorImage,collectorID) values (?,?,?,?,?,?,?,?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, insertTopicCollectionInfoSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [topic.UUID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [topic.title UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [topic.content UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 4, [UIImageJPEGRepresentation(topic.backImage, 1.0) bytes], (int)[UIImageJPEGRepresentation(topic.backImage, 1.0) length], NULL);
        sqlite3_bind_blob(stmt, 5, [UIImageJPEGRepresentation(topic.topicImage, 1.0) bytes], (int)[UIImageJPEGRepresentation(topic.topicImage, 1.0) length], NULL);
        sqlite3_bind_int(stmt, 6, (int)topic.limitNum);
        sqlite3_bind_text(stmt, 7, [topic.layoutID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [topic.creatorID UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [topic.creatorName UTF8String], -1, NULL);
        sqlite3_bind_blob(stmt, 10, [UIImageJPEGRepresentation(topic.creatorImage, 1.0) bytes], (int)[UIImageJPEGRepresentation(topic.creatorImage, 1.0) length], NULL);
        sqlite3_bind_text(stmt, 11, [user.ID UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return YES;
        } else {
            NSLog(@"insert user failed!");
            [self ErrorReport:insertTopicCollectionInfoSQL];
            sqlite3_finalize(stmt);
            [self closeDatabase];
            return NO;
        }
    } else {
        NSLog(@"prepareStatement failed!");
        sqlite3_finalize(stmt);
        [self closeDatabase];
        return NO;
    }
    
}

- (NSMutableArray *)getAllCollectedTopicsByUser:(UserInfo *)user {
    NSMutableArray* topics = [NSMutableArray new];
    [self openDatabase];
    const char *getAllCollectedTopicsSQL = "select id,title,content,backImage,topicImage,limitNum,likeNum,layoutID,creatorID,creatorName,creatorImage from topiccollectioninfo where collectorID = ?";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, getAllCollectedTopicsSQL, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [user.ID UTF8String], -1, NULL);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            Topic *topic = [Topic new];
            if (sqlite3_column_text(stmt, 0)) {
                topic.UUID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
            }
            if (sqlite3_column_text(stmt, 1)) {
                topic.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            }
            if (sqlite3_column_text(stmt, 2)) {
                topic.content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            }
            if (sqlite3_column_bytes(stmt, 3) != 0) {
                topic.backImage = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:sqlite3_column_bytes(stmt, 3)]];
            }
            if (sqlite3_column_bytes(stmt, 4) != 0) {
                topic.topicImage = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(stmt, 4) length:sqlite3_column_bytes(stmt, 4)]];
            }
            if (sqlite3_column_int(stmt, 5)) {
                topic.limitNum = sqlite3_column_int(stmt, 5);
            }
            if (sqlite3_column_int(stmt, 6)) {
                topic.likeNum = sqlite3_column_int(stmt, 6);
            }
            if (sqlite3_column_text(stmt, 7)) {
                topic.layoutID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
            }
            if (sqlite3_column_text(stmt, 8)) {
                topic.creatorID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
            }
            if (sqlite3_column_text(stmt, 9)) {
                topic.creatorName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
            }
            if (sqlite3_column_bytes(stmt, 10) != 0) {
                topic.creatorImage = [UIImage imageWithData:[NSData dataWithBytes:sqlite3_column_blob(stmt, 10) length:sqlite3_column_bytes(stmt, 10)]];
            }
            [topics addObject:topic];
        }
    }
    
    sqlite3_finalize(stmt);
    [self closeDatabase];
    return topics;
}

//error handling
- (void)ErrorReport: (const char *)item
{
    char *errorMsg;
    
    if (sqlite3_exec(_database, item, NULL, NULL, &errorMsg)==SQLITE_OK)
    {
        NSLog(@"%@ ok.",[NSString stringWithUTF8String:item]);
    }
    else
    {
        NSLog(@"error: %s",errorMsg);
        sqlite3_free(errorMsg);
    }
}
@end
