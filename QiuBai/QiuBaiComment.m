//
// Created by PengPremium on 16/3/29.
// Copyright (c) 2016 pi-lot.org. All rights reserved.
//

#import "QiuBaiComment.h"
#import "ModelStore.h"

@implementation QiuBaiComment

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary {
 self = [super init];
 if (self) {
     self.commentID = ((NSNumber *)[dictionary objectForKey:@"commentID"]).unsignedLongLongValue;
     self.commentContent = [dictionary objectForKey:@"commentContent"];
     self.likeCount = ((NSNumber *)[dictionary objectForKey:@"likeCount"]).unsignedLongLongValue;

     u_int64_t authorID = ((NSNumber *)[dictionary objectForKey:@"commentAuthor"]).unsignedLongLongValue;
     self.commentAuthor = [[ModelStore sharedStore] userWithID:authorID];

     self.respondCommentIDs = [dictionary objectForKey:@"respondCommentIDs"];
 }
 return self;
}

- (NSMutableSet*)respondComments {
    if (!_respondComments) {
        _respondComments = [[NSMutableSet alloc] init];
    }
    return _respondComments;
}

@end