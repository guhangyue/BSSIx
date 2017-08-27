//
//  HotelDetailViewController.m
//  GetHotel
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HotelDetailViewController.h"

@interface HotelDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *hotelPictureImgView;
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UIImageView *smallPictureImgView;
@property (weak, nonatomic) IBOutlet UIButton *chooseHotelBtn;
@property (weak, nonatomic) IBOutlet UILabel *inTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *outTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *chatingBtn;
- (IBAction)chatingAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)mapAction:(UIButton *)sender forEvent:(UIEvent *)event;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *confirmBtn;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setDefaultDateForButton{
    //初始化日期格式器
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat=@"yyyy-MM-dd";
    //当前时间
    NSDate *date=[NSDate date];
    //明天的日期
    NSDate *dateTom=[NSDate dateTomorrow];
    //将时间转换为字符串
    NSString *dateStr=[formatter stringFromDate:date];
    NSString *dateTomStr=[formatter stringFromDate:dateTom];
    //将处理好的时间字符串设置给两个button
   // [_startDateBrn setTitle:dateStr forState:UIControlStateNormal];
   // [_endDateBtn setTitle:dateTomStr forState:UIControlStateNormal];
}
- (void)naviConfig {
    //设置导航条标题文字
    self.navigationItem.title = @"酒店预订";
    //设置导航条颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 100, 255);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏.
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    //获取要跳转的页面实例
    UINavigationController *detailToPay=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToPay"];
    //执行跳转
    [self presentViewController:detailToPay animated:YES completion:nil];
//    if ([Utilities loginCheck]) {
    //        获取要跳转的页面实例
//    UINavigationController *detailToUserAddress=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToUserAddress"];
//    执行跳转
 //   [self presentViewController:detailToUserAddress animated:YES completion:nil];
//    }else{
//      [Utilities popUpAlertViewWithMsg:@"该功能需要登录才会开放，请您登录" andTitle:@"提示" onView:self];
//    }
}
- (IBAction)chatingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转的页面实例
    UINavigationController *detailToTalk=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToTalk"];
    //执行跳转
    [self presentViewController:detailToTalk animated:YES completion:nil];
    //    if ([Utilities loginCheck]) {
    //        获取要跳转的页面实例
    //    UINavigationController *detailToUserAddress=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToUserAddress"];
    //    执行跳转
    //   [self presentViewController:detailToUserAddress animated:YES completion:nil];
    //    }else{
    //      [Utilities popUpAlertViewWithMsg:@"该功能需要登录才会开放，请您登录" andTitle:@"提示" onView:self];
    //    }
}

- (IBAction)mapAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转的页面实例
    UINavigationController *detailToUserAddress=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToUserAddress"];
    //执行跳转
    [self presentViewController:detailToUserAddress animated:YES completion:nil];
    //    if ([Utilities loginCheck]) {
    //        获取要跳转的页面实例
    //    UINavigationController *detailToUserAddress=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToUserAddress"];
    //    执行跳转
    //   [self presentViewController:detailToUserAddress animated:YES completion:nil];
    //    }else{
    //      [Utilities popUpAlertViewWithMsg:@"该功能需要登录才会开放，请您登录" andTitle:@"提示" onView:self];
    //    }
}
- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden=YES;
    _datePicker.hidden=YES;
}
@end
