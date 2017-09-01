//
//  HotelDetailModel.m
//  GetHotel
//
//  Created by admin1 on 2017/8/30.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HotelDetailModel.h"

@implementation HotelDetailModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        self.hotels = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"无"];
        self.address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"无"];
        self.image = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@"无"];
        self.price=[[Utilities nullAndNilCheck:dict[@"price"] replaceBy:0]integerValue];
        self.type = [Utilities nullAndNilCheck:dict[@"hotel_type"] replaceBy:@"无"];
        self.hotelID=[[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0]integerValue];
        
    }
    return self;
}

@end
