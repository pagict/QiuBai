//
// Created by PengPremium on 16/3/29.
// Copyright (c) 2016 pi-lot.org. All rights reserved.
//

#import "ModelStore.h"
#import "QiuBaiUser.h"
#import "QiuBaiComment.h"
#import "QiuBaiPost.h"

@interface ModelStore()
@property (strong, nonatomic) NSMutableSet *userStore;
@property (strong, nonatomic) NSMutableSet *postStore;
@property (strong, nonatomic) NSMutableSet *commentStore;
@end


@implementation ModelStore
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"use [ModelStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        self.userStore = [[NSMutableSet alloc] init];
        self.postStore = [[NSMutableSet alloc] init];
        self.commentStore = [[NSMutableSet alloc] init];
    }

    return self;
}

+ (instancetype)sharedStore {
    static ModelStore *_store;
    if (!_store) {
        _store = [[ModelStore alloc] initPrivate];
    }
    return _store;
}

- (void)sync {
    [[ModelStore sharedStore] syncUsers];
    [[ModelStore sharedStore] syncPosts];
    [[ModelStore sharedStore] syncComments];
}

- (void)syncUsers {
    //TODO
}

- (void)syncPosts {
    for (QiuBaiPost* post in self.postStore) {
        for (NSNumber* commentId in post.commentIDs) {
            QiuBaiComment* comment = [[ModelStore sharedStore] commentWithID:commentId.longLongValue];
            if (!comment)   continue;

            [post.comments addObject:comment];
        }

        if (!post.postAuthor) {
            post.postAuthor = [[ModelStore sharedStore] userWithID:post.postAuthorID];
        }
    }
}

- (void)syncComments {
    for (QiuBaiComment* comment in self.commentStore) {
        for (NSNumber* commentId in comment.respondCommentIDs) {
            QiuBaiComment* respondComent = [[ModelStore sharedStore] commentWithID:commentId.longLongValue];
            if (!respondComent) continue;

            [comment.respondComments addObject:respondComent];
        }
    }
}

- (void)insertUser:(QiuBaiUser *)user {
    if (!user) return;
    if ([[ModelStore sharedStore] userWithID:user.userID])
        return;

    [self.userStore addObject:user];
}

- (QiuBaiUser *)userWithID:(u_int64_t)userId {
    NSString *predicateString = [NSString stringWithFormat:@"userID == %llu", userId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSSet* filteredSet = [self.userStore filteredSetUsingPredicate:predicate];
    if (!filteredSet || filteredSet.count == 0) return nil;

    return [filteredSet anyObject];
}

- (void)deleteUserWithID:(u_int64_t)userId {
    QiuBaiUser *user = [[ModelStore sharedStore] userWithID:userId];
    if (user)
        [self.userStore removeObject:user];
}

- (QiuBaiComment *)commentWithID:(u_int64_t)commentId {
    NSString *predicateString = [NSString stringWithFormat:@"commentID == %llu", commentId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSSet* filteredSet = [self.commentStore filteredSetUsingPredicate:predicate];
    if (!filteredSet || filteredSet.count == 0) return nil;

    return [filteredSet anyObject];
}

- (void)insertComment:(QiuBaiComment *)comment {
    if (!comment) return;
    if ([[ModelStore sharedStore] commentWithID:comment.commentID]) return;

    [self.commentStore addObject:comment];
}

- (void)deleteCommentWithID:(u_int64_t)commentId {
    QiuBaiComment *comment = [[ModelStore sharedStore] commentWithID:commentId];
    if (comment)
        [self.commentStore removeObject:comment];
}

- (QiuBaiPost *)postWithID:(u_int64_t)postId {
    NSString *predicateString = [NSString stringWithFormat:@"postID == %llu", postId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSSet *filteredSet = [self.postStore filteredSetUsingPredicate:predicate];
    if (!filteredSet || filteredSet.count == 0) return nil;

    return [filteredSet anyObject];
}

- (void)insertPost:(QiuBaiPost *)post {
    if (!post) return;
    if ([[ModelStore sharedStore] postWithID:post.postID]) return;

    [self.postStore addObject:post];
}

- (void)deletePostWithID:(u_int64_t)postId {
    QiuBaiPost *post = [[ModelStore sharedStore] postWithID:postId];
    if (post)
        [self.postStore removeObject:post];
}

- (NSArray*)allPosts {
    return [_postStore allObjects];
}
@end