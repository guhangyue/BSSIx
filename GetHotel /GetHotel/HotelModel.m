//
//  HotelModel.m
//  GetHotel
//
//  Created by IMAC on 2017/8/27.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HotelModel.h"

@implementation HotelModel
- (instancetype)initWithDictForHotelCell:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.hotelName = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"暂无"];
        self.hotelDistance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"未知"];
        self.hotelLocation = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"未知"];
        self.hotelMoney = [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@"未知"];
        self.hotelImg = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
        self.hotelId = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0] integerValue];
    }
    return self;
}
- (instancetype)initWithDictForAD:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.adImg = [Utilities nullAndNilCheck:dict[@"ad_img"] replaceBy:@"你好我好"];
    }
    return self;
}

@end
