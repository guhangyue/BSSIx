//
//  MyViewController.m
//  GetHotel
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 com. All rights reserved.
//

#import "MyViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface MyViewController ()<CLLocationManagerDelegate>{
    BOOL firstVisit;
}
- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong,nonatomic) NSDictionary *cities;
@property (strong,nonatomic) NSArray *keys;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *myArr;
@property (strong, nonatomic) NSMutableArray *arr;
@property(strong,nonatomic) CLLocationManager *locMgr;
@property(strong,nonatomic) CLLocation *location;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myArr = [NSMutableArray new];
    _arr = [NSMutableArray new];
    [self naviConfig];

}
//每次将要离开这个页面的时候
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关掉开关
    [_locMgr stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//这个方法专门做导航条的控制
- (void)naviConfig {
    //设置导航条标题文字
    self.navigationItem.title = @"城市列表";
    //设置导航条颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏.
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}
-(void)uiLayout{
    if (![[[StorageMgr singletonStorageMgr]objectForKey:@"LocCity"]isKindOfClass:[NSNull class]]) {
        if ([[StorageMgr singletonStorageMgr]objectForKey:@"LocCity"]!=nil) {
            //已经获得了定位，将定位到的城市显示在按钮上；
            [_cityBtn setTitle:[[StorageMgr singletonStorageMgr]objectForKey:@"LocCity"] forState:UIControlStateNormal];
            _cityBtn.enabled=YES;
            
            return;
            
        }
        
        
    }
    //当还没有获得定位的情况下去执行定位功能
    [self LocationStart];
}

-(void)LocationStart{
    _locMgr=[CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //设置定位到的设备，位移多少距离进行一次识别
    _locMgr.distanceFilter = kCLDistanceFilterNone ;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy =  kCLLocationAccuracyBest;
    //打开定位服务的开关（开始定位)
    [_locMgr startUpdatingLocation];
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _myArr.count;
}

//设置组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _keys[section];
}
//设置section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}




- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
