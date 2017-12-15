//
//  Account.m
//  Yoshop
//
//  Created by zhaowei on 16/5/31.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "AccountModel.h"

#define USER_IS_INVITE          @"is_invite"
#define USER_RINKNAME           @"rank_name"
#define USER_EMAIL              @"email"
#define USER_SEX                @"sex"
#define USER_MSN                @"msn"
#define USER_FIRSTNAME          @"firstname"
#define USER_LASTNAME           @"lastname"
#define USER_ADDRESSID          @"addressId"
#define USER_PHONE              @"phone"
#define USER_INSTODUCTION       @"introduction"
#define USER_PAYPAL_ACCOUNT     @"paypal_account"
#define USER_BIRTHDAY           @"birthday"
#define USER_AVATAR             @"avatar"
#define USER_VERIFY             @"isValidated"
#define USER_ID                 @"userid"
#define USER_PASSWORD           @"password"
#define USER_RANK               @"userRank"

@implementation AccountModel


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.email forKey:USER_EMAIL];
    [aCoder encodeInt:self.sex forKey:USER_SEX];
    [aCoder encodeObject:self.firstname forKey:USER_FIRSTNAME];
    [aCoder encodeObject:self.lastname forKey:USER_LASTNAME];
    [aCoder encodeObject:self.addressId forKey:USER_ADDRESSID];
    [aCoder encodeObject:self.phone forKey:USER_PHONE];
    [aCoder encodeObject:self.birthday forKey:USER_BIRTHDAY];
    [aCoder encodeObject:self.avatar forKey:USER_AVATAR];
    [aCoder encodeObject:self.password forKey:USER_PASSWORD];
    [aCoder encodeObject:self.sess_id forKey:@"sess_id"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.collect_number forKey:@"collect_number"];
    [aCoder encodeObject:self.order_number forKey:@"order_number"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.email = [aDecoder decodeObjectForKey:USER_EMAIL];
        self.sex = [aDecoder decodeIntForKey:USER_SEX];
        self.firstname = [aDecoder decodeObjectForKey:USER_FIRSTNAME];
        self.lastname = [aDecoder decodeObjectForKey:USER_LASTNAME];
        self.addressId = [aDecoder decodeObjectForKey:USER_ADDRESSID];
        self.phone = [aDecoder decodeObjectForKey:USER_PHONE];
        self.birthday = [aDecoder decodeObjectForKey:USER_BIRTHDAY];
        self.avatar = [aDecoder decodeObjectForKey:USER_AVATAR];
        self.password = [aDecoder decodeObjectForKey:USER_PASSWORD];
        
        self.sess_id = [aDecoder decodeObjectForKey:@"sess_id"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.order_number = [aDecoder decodeObjectForKey:@"order_number"];
        self.collect_number = [aDecoder decodeObjectForKey:@"collect_number"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    AccountModel *copy = [[[self class] allocWithZone:zone] init];
    copy.email = [self.email copy];
    copy.sex = self.sex;
    copy.firstname = [self.firstname copy];
    copy.lastname = [self.firstname copy];
    copy.addressId = [self.addressId copy];
    copy.phone = [self.phone copy];
    copy.birthday = [self.birthday copy];
    copy.avatar = [self.avatar copy];
    copy.password = [self.password copy];
    copy.sess_id = [self.sess_id copy];
    copy.token = [self.token copy];
    copy.user_id = [self.user_id copy];
    copy.order_number = [self.order_number copy];
    copy.collect_number = [self.collect_number copy];
    return copy;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    AccountModel *copy = [[[self class] allocWithZone:zone] init];
    copy.email = [self.email mutableCopy];
    copy.firstname = [self.firstname mutableCopy];
    copy.lastname = [self.firstname mutableCopy];
    copy.addressId = [self.addressId mutableCopy];
    copy.phone = [self.phone mutableCopy];
    copy.birthday = [self.birthday mutableCopy];
    copy.avatar = [self.avatar mutableCopy];
    copy.password = [self.password mutableCopy];
    copy.sess_id = [self.sess_id mutableCopy];
    copy.token = [self.token mutableCopy];
    copy.user_id = [self.user_id mutableCopy];
    copy.order_number = [self.order_number mutableCopy];
    copy.collect_number = [self.collect_number mutableCopy];
    return copy;
}

-(NSString*) description{
    NSString* descriptionString = @"";
//    NSString* descriptionString = [NSString stringWithFormat:@"userid:%@ \n firstname:%@ \n email:%@ \n sex:%ld \n addressId:%@ \n phone:%@ \n isValidated:%ld \n avatar:%@  birthday:%@ \n user_rank:%@", self.userid, self.firstname, self.email,(unsigned long)self.sex,self.addressId, self.phone, (unsigned long)self.isValidated, self.avatar,self.birthday,self.user_rank];
    
    return descriptionString;
}

- (NSString *)user_id {
    if (!_user_id) {
        _user_id = @"";
    }
    return _user_id;
}

- (NSString *)token {
    if (!_token) {
        _token = @"";
    }
    return _token;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userid"      : @"user_id",
             @"addressId"   : @"address_id",
             @"isValidated" : @"is_validated",
             };
}

@end
