//
//  HotelViewController.m
//  GetHotel
//
//  Created by IMAC on 2017/8/25.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HotelViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HotelTableViewCell.h"
#import "HotelModel.h"

@interface HotelViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    NSInteger pageNum;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL isLoading;
    BOOL firstVisit;
}
@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@property (strong, nonatomic) NSMutableArray *arr;
@property(strong,nonatomic) CLLocationManager *locMgr;
@property (weak, nonatomic) IBOutlet UITableView *HotelTabView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property(strong,nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UIImageView *FirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *SeconImage;
@property (weak, nonatomic) IBOutlet UIImageView *ThirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *FirstView;
@property (weak, nonatomic) IBOutlet UIImageView *SeconView;
@property (weak, nonatomic) IBOutlet UIImageView *ThirdView;

@property (strong, nonatomic) NSMutableArray *adArr;


@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataInitialize];
    [self locationConfig];
    [self networkRequest];
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
//定位失败时
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error) {
        switch (error.code) {
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:nil onView:self];
                break;
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:@"未打开定位" andTitle:nil onView:self ];
                break;
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:@"未知地址" andTitle:nil onView:self];
                break;
            default:
                [Utilities popUpAlertViewWithMsg:@"未知错误" andTitle:nil onView:self];
                break;
        }
    }
}
//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    // NSLog(@"维度：%f",newLocation.coordinate.latitude);
    //  NSLog(@"经度：%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿城市
    if(firstVisit){
        firstVisit = ! firstVisit;
        //根据定位拿城市
        [self getRegeoViaCoordinate];
    }
}
-(void)getRegeoViaCoordinate{
    //duration表示从now开始过3个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    //用duration这个设置好的策略去做某些事
    dispatch_after(duration, dispatch_get_main_queue(), ^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(!error){
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                NSLog(@"locDict = %@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"LocCity"];
                
                //将定位的城市保存进单例化全局变量
                [[StorageMgr singletonStorageMgr]addKey:@"LocCity" andValue:cityStr];
                if (![cityStr isEqualToString:_cityBtn.titleLabel.text]) {
                    //当定位到的城市和当前选择到的城市不一样的时候去弹窗询问用户是否切换城市
                    UIAlertController *alertView =[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到城市为%@， 你是否要切换",cityStr] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
                        //修改用户选择的城市记忆体
                        [Utilities removeUserDefaults:@"UserCity"];
                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
                        //重新执行网络请求
                        [self networkRequest];
                    }];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alertView addAction:yesAction];
                    [alertView addAction:noAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                    
                }
            }
        }];
        //关掉开关
        [_locMgr stopUpdatingLocation];
    });
}
-(void)checkCityState:(NSNotification *)note {
    NSString *cityStr=note.object;
    if (![cityStr isEqualToString:_cityBtn.titleLabel.text]) {
        
        //修改城市按钮标题
        [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
        //修改用户选择的城市记忆体
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //重新执行网络请求
        [self networkRequest];
        
    }
}

//这个方法专门做导航条的控制
- (void)naviConfig {
    //设置导航条标题文字
    self.navigationItem.title = @"GetHotel";
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
    _adArr = [NSMutableArray new];
    //创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    [self refreshPage];
}
- (void)setADImage {
    NSMutableArray *urlArr = [NSMutableArray new];
    
    for (HotelModel *ad in _adArr) {
        [urlArr addObject:ad.adImg];
    }
    //NSLog(@"%@",urlArr);
    
    
    
    [_FirstView sd_setImageWithURL:[NSURL URLWithString:urlArr[0]] placeholderImage:[UIImage imageNamed:@"酒店"]];
    [_SeconView sd_setImageWithURL:[NSURL URLWithString:urlArr[1]] placeholderImage:[UIImage imageNamed:@"酒店"]];
    [_ThirdView sd_setImageWithURL:[NSURL URLWithString:urlArr[2]] placeholderImage:[UIImage imageNamed:@"酒店"]];
}

- (void)refreshPage {
    pageNum = 1;
    [self networkRequest];
}
//执行网络请求
- (void)networkRequest{
    NSLog(@"123");
         NSDictionary *para = @{@"pageNum" : @(pageNum), @"perSize" : @(perPage),@"startId": @1,@"priceId":@1,@"sortingId":@1,@"inTime":@"2017-08-26",@"outTime":@"2017-08-27",@"wxlongitude":@"31.568",@"wxlatitude":@"120.299"};
    NSLog(@"456");
        [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
            NSLog(@"789");
            NSLog(@"responseObject = %@",responseObject);
            [_aiv stopAnimating];
            if ([responseObject[@"result"] integerValue] == 1) {
                if (_adArr.count == 0) {
                NSArray *advertising = responseObject[@"content"][@"advertising"];
                for (NSDictionary *dict in advertising) {
                    HotelModel *ad = [[HotelModel alloc] initWithDictForAD:dict];
                    [_adArr addObject:ad];
                }
                }
                NSArray *hotel = responseObject[@"content"][@"hotel"][@"list"];
                [_arr removeAllObjects];
                for (NSDictionary *dict in hotel) {
                    HotelModel *hotelModel = [[HotelModel alloc] initWithDictForHotelCell:dict];
                    //NSLog(@"%@",hotelModel.hotelName);
                    [_arr addObject:hotelModel];
                    
                }
                [_HotelTabView reloadData];
            }
            
        }failure:^(NSInteger statusCode, NSError *error) {
            [_aiv stopAnimating];
        }];
}
- (void)endAnimation {
    isLoading = NO;
    [_aiv stopAnimating];
    [self end];
    
}
//设置表格视图中有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
}

//设置当一个细胞将要出现的时候也要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //判断是不是最后一行细胞将要出现
    if (indexPath.row == _arr.count -1) {
        //判断是否有下一页存在
        if (pageNum <totalPage) {
            //在这里执行上拉翻页的数据操作
            pageNum ++;
                  }
    }
}
//设置每一组中每一行的cell（细胞）长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据某个具体名字找到该名字在页面上对应的细胞
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
    HotelModel *hotel = _arr[indexPath.row];
    cell.HotelName.text = hotel.hotelName;
    cell.HotelLocation.text = hotel.hotelLocation;
    cell.hotelMoney.text = hotel.hotelMoney;
    cell.hotelDistance.text = hotel.hotelDistance;
    //将http请求的字符串转换为NSURL
    NSURL *url = [NSURL URLWithString:hotel.hotelImg];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"酒店 1"]];
    return cell;
}
//设置每一组中每一行的cell（细胞）被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断当前tableView是否为_activityTableView(这个条件判断常用在一个页面中有多个tableView的时候)
    //if ([tableView isEqual:_activityTableView]){
        //取消选中
      //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //}
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HotelModel *hotelID = _arr[indexPath.row];
    /////////////////////////////////////////////////////////
    //DetailViewController *detailVC = [Utilities getStoryboardInstance:@"Deatil" byIdentity:@"reservation"];
    
}

@end

