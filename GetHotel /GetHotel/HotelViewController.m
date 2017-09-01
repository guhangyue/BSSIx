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
#import "HotelDetailViewController.h"

@interface HotelViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    NSInteger ATime;
    NSInteger pageNum;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL isLoading;
    BOOL firstVisit;
    BOOL bule;
    NSInteger index3;
    NSInteger flag2;
}
@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@property (strong, nonatomic) NSMutableArray *arr;
@property(strong,nonatomic) CLLocationManager *locMgr;
@property (weak, nonatomic) IBOutlet UITableView *HotelTabView;

@property(strong,nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UIImageView *FirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *SeconImage;
@property (weak, nonatomic) IBOutlet UIImageView *ThirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *FirstView;
@property (weak, nonatomic) IBOutlet UIImageView *SeconView;
@property (weak, nonatomic) IBOutlet UIImageView *ThirdView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *date1;
- (IBAction)date1Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *date2Btn;
- (IBAction)date2Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *inTime; //按钮上显示的入住时间
@property (strong, nonatomic) NSString *outTime;// 按钮上显示的离店时间
@property (weak, nonatomic) IBOutlet UIButton *zhinengBtn;
- (IBAction)zhinengAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (strong, nonatomic) NSMutableArray *adArr;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIView *zhinengView;
@property (weak, nonatomic) IBOutlet UIButton *zn2;
- (IBAction)zn2Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *zn1Btn;
- (IBAction)zn1Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *zn3Btn;
- (IBAction)zn3Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
- (IBAction)chooseAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *chooseQDBtn;
- (IBAction)chooseQDAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIScrollView *chooseSView;
@property (weak, nonatomic) IBOutlet UIButton *jiage1Btn;
- (IBAction)jiage1Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *jiage2Btn;
- (IBAction)jiage2Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *jiage3Btn;
- (IBAction)jiage3Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *pingjia1Btn;
- (IBAction)pingjia1:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *pingjia2Btn;
- (IBAction)pingjia2Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *juli1Btn;
- (IBAction)juli1Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *juli2Btn;
- (IBAction)juli2Action:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *juli3Btn;
- (IBAction)juli3Action:(UIButton *)sender forEvent:(UIEvent *)event;


@property (strong, nonatomic) NSTimer *timer; //控制轮播
@property (nonatomic) NSTimeInterval inTimeIn; //入住时间戳
@property (nonatomic) NSTimeInterval outTimeIn;//离店时间戳
@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataInitialize];
    [self locationConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
    [self networkRequest];
}
//每次将要来到这个页面的时候
//控制广告轮播
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationStart];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
}
//每次到达这个页面的时候
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self locationStart];
}
//每次将要离开这个页面的时候
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    [_locMgr stopUpdatingLocation];
}
//每次离开这个页面的时候
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //获得当前页面导航控制器所维系的关于导航关系的数组，通过判断该数组中是否包含自己来得知当前操作是离开本页面还是退出本页面
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




#pragma mark - loction

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
#pragma mark - naviConfig
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
    
    _HotelTabView.tableFooterView = [UIView new];
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
//    //创建菊花膜
//    _aiv = [Utilities getCoverOnView:self.view];
//    [self refreshPage];
}
-(void)setNowTime{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd";
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [NSDate dateTomorrow];
    NSDateFormatter *pFormatter = [NSDateFormatter new];
    pFormatter.dateFormat = @"yyyy-MM-dd";
    [_date1 setTitle:[NSString stringWithFormat:@"入住%@", [formatter stringFromDate:today]] forState:UIControlStateNormal];
    [_date2Btn setTitle:[NSString stringWithFormat:@"离店%@", [formatter stringFromDate:tomorrow]] forState:UIControlStateNormal];
    [_datePicker setMinimumDate:today];
    _outTimeIn = [tomorrow timeIntervalSince1970InMilliSecond];
    
    _inTimeIn = [today timeIntervalSince1970InMilliSecond];
    _inTime = [NSString stringWithFormat:@"入住%@", [formatter stringFromDate:today]];
    _outTime = [NSString stringWithFormat:@"离店%@", [formatter stringFromDate:tomorrow]];


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
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
    [_timer setFireDate:[NSDate distantFuture]];
}

//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //视图静止之后，过1.5秒在开启定时器
    //[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]  返回值为从现在时刻开始 再过1.5秒的时刻。
    //NSLog(@"开启定时器");
    [_timer setFireDate:[NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]]];
}




- (void)changeImage {
    NSInteger page = [self scrollCheck:_scrollView];
    [_scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W *(page+1), 0, UI_SCREEN_W, 150) animated:NO];
}
- (NSInteger)scrollCheck: (UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page == 2) {
        page = -1;
    }
    //NSLog(@"%ld",(long)page);
    return page;
}


- (void)refreshPage {
    pageNum = 1;
    [self networkRequest];
}
//执行网络请求
- (void)networkRequest{
    NSLog(@"123");
         NSDictionary *para = @{@"city_name":_cityBtn.titleLabel.text,@"pageNum" : @(pageNum),@"pageSize":@10, @"startId" :@1 , @"priceId":@1,@"sortingId" :@1 ,@"inTime" :@"2017-01-05" ,@"outTime" : @"2017-05-06",@"wxlongitude":@"31.568",@"wxlatitude":@"120.299"};
    NSLog(@"456");
        [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
            NSLog(@"789");
            [_aiv stopAnimating];
            if ([responseObject[@"result"] integerValue] == 1) {
                NSLog(@"%@",responseObject);
                if (_adArr.count == 0) {
                NSArray *advertising = responseObject[@"content"][@"advertising"];
                for (NSDictionary *dict in advertising) {
                    HotelModel *ad = [[HotelModel alloc] initWithDictForAD:dict];
                    [_adArr addObject:ad];
                }
                    [self setADImage];
                }
                NSArray *hotel = responseObject[@"content"][@"hotel"][@"list"];
                [_arr removeAllObjects];
                for (NSDictionary *dict in hotel) {
                    HotelModel *hotelModel = [[HotelModel alloc] initWithDictForHotelCell:dict];
                    //NSLog(@"%@",hotelModel.hotelName);
                    [_arr addObject:hotelModel];
                    
                }
                NSLog(@"%ld",_arr.count);
                [_HotelTabView reloadData];
            }
            
        }failure:^(NSInteger statusCode, NSError *error) {
            [_aiv stopAnimating];
            [Utilities popUpAlertViewWithMsg:@"网络不稳定" andTitle:nil onView:self];

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
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    //判断是不是最后一行细胞将要出现
//    if (indexPath.row == _arr.count -1) {
//        //判断是否有下一页存在
//        if (pageNum <totalPage) {
//            //在这里执行上拉翻页的数据操作
//            pageNum ++;
//                  }
//    }
//}
//设置每一组中每一行的cell（细胞）长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据某个具体名字找到该名字在页面上对应的细胞
    //NSLog(@"%ld",_arr.count);
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
    
    HotelModel *hotel = _arr[indexPath.row];
    cell.HotelName.text = hotel.hotelName;
    cell.HotelLocation.text = hotel.hotelLocation;
    cell.hotelMoney.text = hotel.hotelMoney;
    if (hotel.hotelDistance >1000) {
        NSInteger a = hotel.hotelDistance/1000;
        cell.hotelDistance.text = [NSString stringWithFormat:@"距离我%ld公里",a];
    }else{
        cell.hotelDistance.text = [NSString stringWithFormat:@"距离我%ld米",hotel.hotelDistance];
    }
    
    
    //将http请求的字符串转换为NSURL
    NSURL *url = [NSURL URLWithString:hotel.hotelImg];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    return cell;

}
//设置每一组中每一行的cell（细胞）被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HotelDetailViewController *detailVC = [Utilities getStoryboardInstance:@"HotelDetail" byIdentity:@"1"];
     [self.navigationController pushViewController:detailVC animated:YES];

// if (tableView == _selectTableView) {
//        [_c setTitle:_sorts[indexPath.row] forState:UIControlStateNormal];
//        switch (indexPath.row) {
//            case 0:
//                _SortId = @"1";
//                break;
//            case 1:
//                _SortId = @"2";
//                break;
//            case 2:
//                _SortId = @"3";
//                break;
//            default:
//                _SortId = @"4";
//                break;
//        }
//        _selectBView.hidden = YES;
//        [self requestAll];
//        return;
//    }
//    AAndHModel *hotelID = _hotelArr[indexPath.row];
//    DetailViewController *detailVC = [Utilities getStoryboardInstance:@"Deatil" byIdentity:@"reservation"];
//    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"hotelId"];
//    [[StorageMgr singletonStorageMgr] addKey:@"hotelId" andValue:@(hotelID.hotelId)];
//    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"customInTime"];
//    [[StorageMgr singletonStorageMgr] addKey:@"customInTime" andValue:_inTime];
//    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"customOutTime"];
//    [[StorageMgr singletonStorageMgr] addKey:@"customOutTime" andValue:_outTime];
//    //UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:detailVC];
//    //[self presentViewController:nc animated:YES completion:nil];
//    // detailVC.hotelId = hotelID.hotelId;
//    NSLog(@"%@",detailVC.hotelid);
//    
//    [self.navigationController pushViewController:detailVC animated:YES];
    
}
//当某个页面跳转行为将要发生的时候
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"HotelToDetail"]) {
        //当从列表页到详情页的这个跳转要发生的时候
        //1、获取要传递到下一页去的数据
        NSIndexPath *indexPath = [_HotelTabView indexPathForSelectedRow];
        HotelModel *activity = _arr[indexPath.row];
        //2、获取下一页这个实例
        HotelDetailViewController *detailVC = segue.destinationViewController;
        //3、把数据给下一页预备好的接收容器
        detailVC.hotelDetail = activity;
        
    }
}


- (IBAction)date1Action:(UIButton *)sender forEvent:(UIEvent *)event {
    flag2=0;
    _datePicker.hidden = NO;
    _toolBar.hidden = NO;
    _zhinengView.hidden=YES;
    _chooseSView.hidden=YES;
}
- (IBAction)date2Action:(UIButton *)sender forEvent:(UIEvent *)event {
    flag2=1;
    _datePicker.hidden = NO;
    _toolBar.hidden = NO;
    _zhinengView.hidden=YES;
    _chooseSView.hidden=YES;
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    //拿到当前datepicker选择的事件
    NSDate *date =  _datePicker.date;
    //初始化一个日期格式器
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd";
    NSString *theDate = [formatter stringFromDate:date];
    NSTimeInterval Time = [date timeIntervalSince1970InMilliSecond];
    NSDateFormatter *pFormatter = [NSDateFormatter new];
    pFormatter.dateFormat = @"yyyy-MM-dd";
//    if (ATime == 0) {
//        if (Time > _outTimeIn) {
//            [Utilities popUpAlertViewWithMsg:@"请选择正确的离店时间" andTitle:nil  onView:self];
//            return;
//        }
//        _inTimeIn = Time;
//        _inTime = [NSString stringWithFormat:@"入住%@",theDate];
//        [_date1 setTitle:theDate forState:UIControlStateNormal];
////        [_a setTitle:_inTime forState:UIControlStateNormal];
//        //        [_outTimeBtn setTitle:[NSString stringWithFormat:@"离店%@", theDate] forState:UIControlStateNormal];
//        //        [_datePicker setMinimumDate:date];
//        //_date1 = [pFormatter stringFromDate:date];
//    }
//    else {
//        if (Time < _inTimeIn) {
//            
//            return;
//        }
//        _outTimeIn = Time;
//        _outTime = [NSString stringWithFormat:@"离店%@",theDate];
//        
//        
//    }
    
    _datePicker.hidden = YES;
    _toolBar.hidden = YES;
    _zhinengView.hidden=YES;
    _chooseSView.hidden=YES;
   // [self networkRequest];

}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //拿到当前datepicker选择的时间
    NSDate *date= _datePicker.date;
    // 初始化一个日期格式器
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"MM月dd日 ";
    //将日期转换为字符串（通过日期格式器中的stringFromDate方法）
    NSString *theDate=[formatter stringFromDate:date];
    if (flag2==0) {
        [_date1 setTitle:theDate forState:UIControlStateNormal];
        
    }else{
        [_date2Btn setTitle:theDate forState:UIControlStateNormal];
    }

    _toolBar.hidden= YES;
    _datePicker.hidden=YES;
    _zhinengView.hidden=YES;
    _chooseSView.hidden=YES;
    
    [self networkRequest];
}
- (IBAction)zhinengAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _zhinengView.hidden=NO;
    _toolBar.hidden= YES;
    _datePicker.hidden=YES;
    _chooseSView.hidden=YES;
}
- (IBAction)zn2Action:(UIButton *)sender forEvent:(UIEvent *)event {
    _zhinengView.hidden=YES;
    _toolBar.hidden= YES;
    _datePicker.hidden=YES;
    _chooseSView.hidden=YES;
}
- (IBAction)zn1Action:(UIButton *)sender forEvent:(UIEvent *)event {
    _zhinengView.hidden=YES;
    _toolBar.hidden= YES;
    _datePicker.hidden=YES;
    _chooseSView.hidden=YES;
}
- (IBAction)zn3Action:(UIButton *)sender forEvent:(UIEvent *)event {
    _zhinengView.hidden=YES;
    _toolBar.hidden= YES;
    _datePicker.hidden=YES;
    _chooseSView.hidden=YES;
}
- (IBAction)chooseAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _chooseSView.hidden=NO;
    _zhinengView.hidden=YES;
    _toolBar.hidden= YES;
    _datePicker.hidden=YES;
}
- (IBAction)chooseQDAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _chooseSView.hidden=YES;
    _zhinengView.hidden=YES;
    _toolBar.hidden= YES;
    _datePicker.hidden=YES;
}
- (IBAction)jiage1Action:(UIButton *)sender forEvent:(UIEvent *)event {
    if (++index3%2==0) {
        _jiage1Btn.backgroundColor=[UIColor lightGrayColor];
        
    }else{
    _jiage1Btn.backgroundColor=[UIColor blueColor];
       _jiage2Btn.backgroundColor=[UIColor lightGrayColor];
        _jiage3Btn.backgroundColor=[UIColor lightGrayColor];
    }

   
}
- (IBAction)jiage2Action:(UIButton *)sender forEvent:(UIEvent *)event {
    if (++index3%2==0) {
        _jiage2Btn.backgroundColor=[UIColor lightGrayColor];
        
    }else{
        _jiage1Btn.backgroundColor=[UIColor lightGrayColor];
        _jiage2Btn.backgroundColor=[UIColor blueColor];
        _jiage3Btn.backgroundColor=[UIColor lightGrayColor];
    }
    
    
}
- (IBAction)jiage3Action:(UIButton *)sender forEvent:(UIEvent *)event {
    if (++index3%2==0) {
        _jiage3Btn.backgroundColor=[UIColor lightGrayColor];
        
    }else{
        _jiage1Btn.backgroundColor=[UIColor lightGrayColor];
        _jiage2Btn.backgroundColor=[UIColor lightGrayColor];
        _jiage3Btn.backgroundColor=[UIColor blueColor];
    }
}
- (IBAction)pingjia1:(UIButton *)sender forEvent:(UIEvent *)event {
    if (bule) {
                _pingjia1Btn.backgroundColor=[UIColor lightGrayColor];
            }else{
                _pingjia2Btn.backgroundColor=[UIColor lightGrayColor];
                _pingjia1Btn.backgroundColor=[UIColor blueColor];
            }
           bule=!bule;

    
}
- (IBAction)pingjia2Action:(UIButton *)sender forEvent:(UIEvent *)event {
    if (++index3%2==0) {
        _pingjia2Btn.backgroundColor=[UIColor lightGrayColor];
        
    }else{
        _pingjia1Btn.backgroundColor=[UIColor lightGrayColor];
        _pingjia2Btn.backgroundColor=[UIColor blueColor];
        
    }

   
}
- (IBAction)juli1Action:(UIButton *)sender forEvent:(UIEvent *)event {
    if (++index3%2==0) {
        _juli1Btn.backgroundColor=[UIColor lightGrayColor];
        
    }else{
        _juli1Btn.backgroundColor=[UIColor blueColor];
        _juli2Btn.backgroundColor=[UIColor lightGrayColor];
        _juli3Btn.backgroundColor=[UIColor lightGrayColor];
    }
   
}
- (IBAction)juli2Action:(UIButton *)sender forEvent:(UIEvent *)event {
    if (++index3%2==0) {
        _juli2Btn.backgroundColor=[UIColor lightGrayColor];
        
    }else{
        _juli1Btn.backgroundColor=[UIColor lightGrayColor];
        _juli2Btn.backgroundColor=[UIColor blueColor];
        _juli3Btn.backgroundColor=[UIColor lightGrayColor];
    }
    
}
- (IBAction)juli3Action:(UIButton *)sender forEvent:(UIEvent *)event {
    if (++index3%2==0) {
        _juli3Btn.backgroundColor=[UIColor lightGrayColor];
        
    }else{
        _juli1Btn.backgroundColor=[UIColor lightGrayColor];
        _juli2Btn.backgroundColor=[UIColor lightGrayColor];
        _juli3Btn.backgroundColor=[UIColor blueColor];
    }

}
@end

