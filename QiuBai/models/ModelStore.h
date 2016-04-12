//
// Created by PengPremium on 16/3/29.
// Copyright (c) 2016 pi-lot.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QiuBaiUser;
@class QiuBaiPost;
@class QiuBaiComment;

@interface ModelStore : NSObject
+ (instancetype)sharedStore;
- (void)sync;

- (void)insertUser:(QiuBaiUser *)user;
- (QiuBaiUser *)userWithID:(u_int64_t)userId;
- (void)deleteUserWithID:(u_int64_t)userId;

- (void)insertPost:(QiuBaiPost *)post;
- (QiuBaiPost *)postWithID:(u_int64_t)postId;
- (void)deletePostWithID:(u_int64_t)postId;
- (NSArray*)allPosts;

- (void)insertComment:(QiuBaiComment *)comment;
- (QiuBaiComment *)commentWithID:(u_int64_t)commentId;
- (void)deleteCommentWithID:(u_int64_t)commentId;

- (QiuBaiComment*)newCommentWithContent:(NSString*)commentContent;
@end