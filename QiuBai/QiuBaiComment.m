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
     self.respondComments = [dictionary objectForKey:@"respondComments"];
     self.likeCount = ((NSNumber *)[dictionary objectForKey:@"likeCount"]).unsignedLongLongValue;

     u_int64_t authorID = ((NSNumber *)[dictionary objectForKey:@"commentAuthor"]).unsignedLongLongValue;
     self.commentAuthor = [[ModelStore sharedStore] userWithID:authorID];
 }
 return self;
}

@end