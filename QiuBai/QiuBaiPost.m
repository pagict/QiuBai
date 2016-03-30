//
// Created by PengPremium on 16/3/29.
// Copyright (c) 2016 pi-lot.org. All rights reserved.
//

#import "QiuBaiPost.h"
#import "ModelStore.h"


@implementation QiuBaiPost {

}
- (instancetype)initWithJSONDictionary:(NSDictionary *)attributeDictionary {
    self = [super init];
    if (self)   {
        self.postID = ((NSNumber *)[attributeDictionary objectForKey:@"postID"]).unsignedLongLongValue;
        self.postContent = [attributeDictionary objectForKey:@"postContent"];
        self.likeCount = ((NSNumber *)[attributeDictionary objectForKey:@"likeCount"]).unsignedLongLongValue;
        self.dislikeCount = ((NSNumber *)[attributeDictionary objectForKey:@"dislikeCount"]).unsignedLongLongValue;
        self.sharedCount = ((NSNumber *)[attributeDictionary objectForKey:@"sharedCount"]).unsignedLongLongValue;

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        self.postDate = [formatter dateFromString:[attributeDictionary objectForKey:@"postDate"]];
        self.hot = ((NSNumber *)[attributeDictionary objectForKey:@"isHot"]).boolValue;
        self.new = ((NSNumber *)[attributeDictionary objectForKey:@"isNew"]).boolValue;

        u_int64_t postAuthorID = ((NSNumber *)[attributeDictionary objectForKey:@"postAuthor"]).unsignedLongLongValue;
        self.postAuthor = [[ModelStore sharedStore] userWithID:postAuthorID];

        //TODO:comments Array
    }
    return self;
}

@end