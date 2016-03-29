//
//  QiuBaiUser.h
//  QiuBai
//
//  Created by PengPremium on 16/3/29.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <Foundation/Foundation.h>

enum MarriageStatus {
    inRelationship,
    single,
    married
};

enum Stellar {
    Aries,  //白羊
    Taurus, //金牛
    Gemini, //双子
    Cancer, //巨蟹
    Leo,    //狮子
    Virgo,  //处女
    Libra,  //天称
    Scorpio,//天蝎
    Sagittarius,    //射手
    Capricorn,      //摩羯
    Aquarius,       //水瓶
    Pisces          //双鱼
};

@interface QiuBaiUser : NSObject
@property (nonatomic)                   u_int64_t           userID;
@property (strong, nonatomic)           NSString *          nickName;
@property (nonatomic)                   enum MarriageStatus marriageStatus;
@property (nonatomic)                   enum Stellar        stellar;
@property (strong, nonatomic, readonly) NSDate *            joinDate;
@property (strong, nonatomic)           NSString *          occupation;
@property (nonatomic)                   int                 level;
@property (strong, nonatomic)           NSMutableArray *    joinedGroups;

@property (strong, nonatomic)           NSString *          profileImagePath;

- (instancetype)initWithJSONDictionary:(NSDictionary *)attributeDictionary;
@end
