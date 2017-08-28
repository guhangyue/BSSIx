//
//  HotelDetailViewController.m
//  GetHotel
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HotelDetailViewController.h"


@interface HotelDetailViewController ()<UIScrollViewDelegate>{
    NSInteger flag;
}
@property (weak, nonatomic) IBOutlet UIImageView *hotelPictureImgView;
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UIImageView *smallPictureImgView;
@property (weak, nonatomic) IBOutlet UIButton *chooseHotelBtn;
//@property (weak, nonatomic) IBOutlet UILabel *inTimeLbl;
//@property (weak, nonatomic) IBOutlet UILabel *outTimeLbl;
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
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
- (IBAction)startTimeAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
- (IBAction)endTimeAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig1];
        // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig1 {
    //设置导航条标题文字
    self.navigationItem.title = @"酒店预订";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 100, 255);
    //实例化一个button
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置button的位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置背景图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
-(void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setDefaultDateForButton{
    //初始化日期格式器
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat=@"MM月dd日";
    //当前时间
    NSDate *date=[NSDate date];
    //明天的日期
    NSDate *dateTom=[NSDate dateTomorrow];
    //将时间转换为字符串
    NSString *dateStr=[formatter stringFromDate:date];
    NSString *dateTomStr=[formatter stringFromDate:dateTom];
    //将处理好的时间字符串设置给两个button
    [_startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
    [_endTimeBtn setTitle:dateTomStr forState:UIControlStateNormal];
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
    [self performSegueWithIdentifier:@"DetailToPay" sender:nil];
    //获取要跳转的页面实例
//    UINavigationController *detailToPay=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToPay"];
    //执行跳转
//    [self presentViewController:detailToPay animated:YES completion:nil];
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
    [self performSegueWithIdentifier:@"DetailToTalk" sender:nil];
    //获取要跳转的页面实例
//    UINavigationController *detailToTalk=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToTalk"];
    //执行跳转
//    [self presentViewController:detailToTalk animated:YES completion:nil];
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
    [self performSegueWithIdentifier:@"DetailToUserAddress" sender:nil];
    //获取要跳转的页面实例
//    UINavigationController *detailToUserAddress=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToUserAddress"];
    //执行跳转
//    [self presentViewController:detailToUserAddress animated:YES completion:nil];
    //    if ([Utilities loginCheck]) {
    //        获取要跳转的页面实例
    //    UINavigationController *detailToUserAddress=[Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"DetailToUserAddress"];
    //    执行跳转
    //   [self presentViewController:detailToUserAddress animated:YES completion:nil];
    //    }else{
    //      [Utilities popUpAlertViewWithMsg:@"该功能需要登录才会开放，请您登录" andTitle:@"提示" onView:self];
    //    }
}
//确认item点击事件（确认选择日期）
- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //拿到当前datepicker选择的时间
    NSDate *date= _datePicker.date;
    // 初始化一个日期格式器
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"MM月dd日 ";
    //将日期转换为字符串（通过日期格式器中的stringFromDate方法）
    NSString *theDate=[formatter stringFromDate:date];
    if (flag==0) {
        [_startTimeBtn setTitle:theDate forState:UIControlStateNormal];
        
    }else{
        [_endTimeBtn setTitle:theDate forState:UIControlStateNormal];
    }
    _toolBar.hidden=YES;
    _datePicker.hidden=YES;
    
}
//取消item点击事件（取消选择日期）
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden=YES;
    _datePicker.hidden=YES;
}
//开始日期按钮点击事件
- (IBAction)startTimeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag=0;
    _toolBar.hidden=NO;
    _datePicker.hidden=NO;
}
//结束日期按钮点击事件
- (IBAction)endTimeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag=1;
    _toolBar.hidden=NO;
    _datePicker.hidden=NO;
}
@end
