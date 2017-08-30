//
//  HotelDetailModel.h
//  GetHotel
//
//  Created by admin1 on 2017/8/30.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelDetailModel : NSObject
@property (strong,nonatomic) NSString *hotels;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *image;
@property (strong,nonatomic) NSString *type;
@property (nonatomic) NSInteger price;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
