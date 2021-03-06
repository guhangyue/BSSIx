//
//  HotelDetailViewController.m
//  GetHotel
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HotelDetailViewController.h"
//#import "HotelDetailModel.h"
//#import "UserModel.h"
#import "HotelModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HotelDetailViewController ()<UIScrollViewDelegate>{
    NSInteger flag;
}

@property (weak, nonatomic) IBOutlet UILabel *hotelNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UIImageView *smallPictureImgView;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *chatingBtn;
- (IBAction)chatingAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)mapAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *eatingLbl;
@property (weak, nonatomic) IBOutlet UILabel *bedNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;

- (IBAction)confirmAction:(UIBarButtonItem *)sender;

- (IBAction)cancelAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
- (IBAction)startTimeAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
- (IBAction)endTimeAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (weak, nonatomic) IBOutlet UIButton *fanhuiBtn;
- (IBAction)fanhuiAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong,nonatomic )IBOutlet UIPageControl *page2;
@property (strong ,nonatomic) IBOutlet NSTimer *starT;
@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig1];
    [self getImage];
    [self HotelDetailRequest];
        // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getImage{
    CGSize scrollSize = _scrollView1.frame.size;
    for(int i =0;i<4;i++)
    {
        UIImageView *imageview = [[UIImageView alloc]init];
        
        //CGFloat scrollWidth = scrollSize.width;
        CGFloat imagex = [[UIScreen mainScreen] bounds].size.width * i;
        CGFloat imagey = 0;
        CGFloat imagew = [[UIScreen mainScreen] bounds].size.width;
        CGFloat imageh = scrollSize.height;
        imageview.frame = CGRectMake(imagex, imagey, imagew, imageh);
        NSString *imagestr = [NSString stringWithFormat:@"1%d",i+1];
        imageview.image = [UIImage imageNamed:imagestr];
        [_scrollView1 addSubview:imageview];
    }
    _scrollView1.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * 4, 0);
    _scrollView1.showsVerticalScrollIndicator = NO;
    _scrollView1.backgroundColor = [UIColor grayColor];
   // self.scrollView1.delegate = self;
    _page2 = [[UIPageControl alloc] init];
    _page2.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 + 150, [[UIScreen mainScreen] bounds].size.height/6 +35, 10, 10);
    _page2.numberOfPages = 4;
    _page2.pageIndicatorTintColor = [UIColor blueColor];
    _page2.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:_page2];
    [self startTime];
}
-(void)startTime{
    
    self.starT = [NSTimer timerWithTimeInterval: 2.0 target: self selector:@selector(nextpage)userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.starT forMode:NSRunLoopCommonModes];
}
-(void)nextpage{
    NSInteger page1 = self.page2.currentPage;
    NSLog(@"%ld",(long)page1);
    NSInteger nextpage = 0;
    if(page1 == self.page2.numberOfPages - 1)
    {
        nextpage = 0;
    }else{
        nextpage = page1 +1;
    }
    
    CGFloat content = nextpage *_scrollView1.frame.size.width;
    _scrollView1.contentOffset = CGPointMake(content, 0);
    
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [_starT invalidate];
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.starT = [NSTimer timerWithTimeInterval: 2.0 target: self selector:@selector(nextpage)userInfo:nil repeats:YES];
    [self startTime];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //    NSLog(@"%d", page);
    // 设置页码
    _page2.currentPage = page;
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
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
- (void)backAction {
   // [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)HotelDetailRequest{
    //菊花膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    //NSLog(@"%@",_hotelid);
   // HotelModel *user=[ HotelModel alloc];
        NSDictionary *para = @{@"id" :@(_hotelDetail.hotelId)};
   // NSLog(@"%@",user.hotelId);
    [RequestAPI requestURL:@"/findHotelById" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"result:%@",responseObject);
        if([responseObject[@"result"]integerValue]==1){
            NSDictionary *result = responseObject[@"content"];
            HotelModel *detail = [[ HotelModel alloc]initWithDictForHotelCell:result];
            _hotelNameLbl.text =detail.hotelName;
            _addressLbl.text = detail.hotelLocation;
            _moneyLbl.text = [NSString stringWithFormat:@"¥ %@",detail.hotelMoney];
            
            [_smallPictureImgView sd_setImageWithURL:[NSURL URLWithString:detail.hotelImg] placeholderImage:[UIImage imageNamed:@"11"]];
            //_hotelbed.text = detail.type;
            NSArray *list = result[@"hotel_types"];
            for(int i=0;i<list.count;i++){
                switch (i) {
                    case 0:
                        _roomNameLbl.text= list[i];
                        break;
                    case 1:
                        _eatingLbl.text = list[i];
                        break;
                    case 2:
                        _bedNameLbl.text = list[i];
                        break;
                    case 3:
                        _areaLbl.text = list[i];
                        break;
                        
                    default:
                        break;
                }
            }
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self ];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"该功能需要登录才会开放，请您登录" andTitle:@"提示" onView:self];
    }];
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
- (IBAction)fanhuiAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
