//
//  QiuBaiUser.m
//  QiuBai
//
//  Created by PengPremium on 16/3/29.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiUser.h"

@implementation QiuBaiUser
- (instancetype)initWithJSONDictionary:(NSDictionary *)attributeDictionary {
    self = [super init];
    if (self) {
        self.userID = ((NSNumber *) [attributeDictionary objectForKey:@"userID"]).unsignedLongLongValue;
        self.nickName = [attributeDictionary objectForKey:@"nickName"];
        self.marriageStatus = (enum MarriageStatus) ((NSNumber *)[attributeDictionary objectForKey:@"marriageStatus"]).intValue;
        self.stellar = (enum Stellar) ((NSNumber *)[attributeDictionary objectForKey:@"stellar"]).intValue;
        self.occupation = [attributeDictionary objectForKey:@"occupation"];
        self.profileImagePath = [attributeDictionary objectForKey:@"profileImagePath"];

        //TODO: groups
        self.joinedGroups = [NSMutableArray arrayWithArray:[attributeDictionary objectForKey:@"joinedGroups"]];;

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _joinDate = [formatter dateFromString:[attributeDictionary objectForKey:@"joinDate"]];
    }
    return self;
}


@end
