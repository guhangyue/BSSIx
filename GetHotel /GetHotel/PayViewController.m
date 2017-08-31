//
//  PayViewController.m
//  GetHotel
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 com. All rights reserved.
//

#import "PayViewController.h"
#import "HotelDetailViewController.h"

@interface PayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (strong,nonatomic)NSArray *arr;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
    [self uiLayout];
    [self dataInitialize];
    [self setFootViewForTableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置导航栏样式
-(void)setNavigationItem{
    self.navigationItem.title = @"支付";
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
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
-(void)uiLayout{
    //_hotelNameLabel.text= _hotelModel.hotelName;
    //_startTimeLabel.tag= _hotelModel.startTime;
    // _endTimeLabel.tag=_hotelModel.endTime;
    // _payLabel.text=[NSString stringWithFormat:@"%@元",_hotelModel.hotelMoney];
    self.tableView.tableFooterView =[UIView new];
    //将表格视图设置为"编辑中"
    self.tableView.editing = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表格视图中某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
-(void)dataInitialize{
    _arr=@[@"支付宝支付",@"微信支付",@"银联支付"];
}
//设置tableview的底部视图
- (void)setFootViewForTableView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 45)];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.frame = CGRectMake(0, 5, UI_SCREEN_W, 40.f);
    [exitBtn setTitle:@"确定支付" forState:UIControlStateNormal];
    //设置按钮标题的字体大小
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [exitBtn setTitleColor:UIColorFromRGB(221.f, 129.f, 116.f) forState:UIControlStateNormal];
    exitBtn.backgroundColor = [UIColor whiteColor];
    [exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:exitBtn];
    
    [_tableView setTableFooterView:view];
}

-(void)payAction{
    
}
//按钮的点击事件
- (void)exitAction: (UIButton *)button{
    //NSLog(@"%@", @"退出");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要支付？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        [self exit];
    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
    cell.textLabel.text=_arr[indexPath.row];
    // Configure the cell...
    
    return cell;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
//设置组的标题文字
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//   return @"支付方式";
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //遍历表格视图中所有选中状态下的细胞
    for (NSIndexPath*eachIP in tableView.indexPathsForSelectedRows) {
        //当选中的细胞不是当前正在按的这个细胞的情况下
        if (eachIP !=indexPath) {
            //将细胞从选中状态改为不选中状态
            [tableView deselectRowAtIndexPath:eachIP animated:YES];
        }
    }
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
}
@end
