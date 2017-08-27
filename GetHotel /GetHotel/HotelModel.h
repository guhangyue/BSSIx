//
//  HotelModel.h
//  GetHotel
//
//  Created by IMAC on 2017/8/27.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelModel : NSObject
@property (strong, nonatomic) NSString *adImg; //广告图片
@property (strong, nonatomic) NSString *hotelImg;//酒店图片
@property (strong, nonatomic) NSString *hotelName;//酒店名称
@property (strong, nonatomic) NSString *hotelLocation;//酒店所在地
@property (strong, nonatomic) NSString *hotelDistance;//距离
@property (strong, nonatomic) NSString *hotelMoney;//酒店费用
@property (nonatomic) NSInteger hotelId;

- (instancetype)initWithDictForHotelCell: (NSDictionary *)dict;
- (instancetype)initWithDictForAD: (NSDictionary *)dict;
@end
