//
//  HotelViewController.m
//  GetHotel
//
//  Created by IMAC on 2017/8/25.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HotelViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface HotelViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    BOOL isLoading;
    BOOL firstVisit;
}
@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@property (strong, nonatomic) NSMutableArray *arr;
@property(strong,nonatomic) CLLocationManager *locMgr;
@property (weak, nonatomic) IBOutlet UITableView *HotelTabView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//每次将要来到这个页面的时候
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//每次到达这个页面的时候
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self locationStart];
}

//每次将要离开这个页面的时候
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关掉开关
   // [_locMgr stopUpdatingLocation];
}

//每次离开这个页面的时候
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //获得当前页面导航控制器所维系的关于导航关系的数组，通过判断该数组中是否包含自己来得知当前操作是离开本页面还是退出本页面
}
//这个方法专门处理定位的基本设置
-(void)locationConfig{
    _locMgr=[CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //设置定位到的设备，位移多少距离进行一次识别
    _locMgr.distanceFilter = kCLDistanceFilterNone ;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy =  kCLLocationAccuracyBest;
}
//这个方法处理开始定位
-(void)locationStart{
    //判断用户有没有选择过是否使用定位
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        //询问用户是否愿意使用定位
#ifdef __IPHONE_8_0
        if([_locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            //使用“使用中打开定位”这个策略去运用定位功能
            [_locMgr requestWhenInUseAuthorization];
        }
#endif
    }
    //打开定位服务的开关（开始定位)
    [_locMgr startUpdatingLocation];
}
//这个方法专门做导航条的控制
- (void)naviConfig {
    //设置导航条标题文字
    self.navigationItem.title = @"活动列表";
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

- (void)uiLayout {
    //为表格视图创建footer(该方法可以去除表格视图底部多余的下划线)
    _HotelTabView.tableFooterView = [UIView new];
    //创建下拉刷新器
    [self refreshConfiguration];
    
}

- (void)refreshConfiguration{
    //初始化一个下拉刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    refreshControl.tag = 10001;
    //设置标题
    NSString *title = @"加载中...";
    
    //创建属性字典
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : [UIColor redColor],NSBackgroundColorAttributeName : [UIColor yellowColor]};
    
    
    //将文字和属性字典包裹成一个带属性的字符串
    NSAttributedString *attriTitle = [[NSAttributedString alloc]initWithString:title attributes:attrDict];
    
    refreshControl.attributedTitle = attriTitle;
    //设置风格颜色为黑色（风格颜色：刷新指示器的颜色）
    refreshControl.tintColor = [UIColor brownColor];
    
    //设置背景色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //定义用户触发下拉事件时执行的方法
    [refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到tableView中(在tableView中，下拉刷新控件会自动放置在表格视图顶部后侧位置)
    [self.HotelTabView addSubview:refreshControl];
    
}
- (void)end{
    //在activityTableView中，根据下标为10001获得其子视图：下拉刷新控件
    UIRefreshControl *refresh = (UIRefreshControl *)[self.HotelTabView viewWithTag:10001];
    //结束刷新
    [refresh endRefreshing];
}
//这个方法专门做数据的处理
- (void)dataInitialize {
    BOOL appInit = NO;
    
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //说明是第一次打开APP
        appInit =  YES;
    }else{
        if ([Utilities getUserDefaults:@"UserCity"] ==nil) {
            //也说明是第一次打开APP
            appInit = YES;
        }
    }
    if (appInit) {
        //第一次来到APP将默认城市与记忆城市同步
        NSString *userCity = _cityBtn.titleLabel.text;
        [Utilities setUserDefaults:@"UserCity" content:userCity];
    }else{
        //不是第一次来到APP则将记忆城市与安宁上的城市名反向同步
        NSString *userCity =[Utilities getUserDefaults:@"UserCity"];
        [_cityBtn setTitle:userCity forState:UIControlStateNormal];
        
    }
    
    
    firstVisit = YES;
    isLoading = NO;
    _arr = [NSMutableArray new];
    //创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    //[self refreshPage];
}



@end
