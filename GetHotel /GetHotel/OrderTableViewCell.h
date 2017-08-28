//
//  OrderTableViewCell.h
//  GetHotel
//
//  Created by admin1 on 2017/8/27.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotelAddressLAbel;

@property (weak, nonatomic) IBOutlet UILabel *hotelPeopleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImg;


@end
