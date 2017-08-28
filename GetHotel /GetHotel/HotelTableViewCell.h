//
//  HotelTableViewCell.h
//  GetHotel
//
//  Created by IMAC on 2017/8/27.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hotelImage;
@property (weak, nonatomic) IBOutlet UILabel *HotelName;
@property (weak, nonatomic) IBOutlet UILabel *HotelLocation;
@property (weak, nonatomic) IBOutlet UILabel *hotelDistance;
@property (weak, nonatomic) IBOutlet UILabel *hotelMoney;
@end
