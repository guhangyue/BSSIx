//
//  MyinfoViewController.m
//  GetHotel
//
//  Created by admin1 on 2017/8/25.
//  Copyright © 2017年 com. All rights reserved.
//

#import "MyinfoViewController.h"
#import "MyinfoTableViewCell.h"
@interface MyinfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) NSArray *myInfoArr;
@end

@implementation MyinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myInfoArr = @[@{@"leftIcon":@"酒店详情小图标",@"title":@"我的酒店"},@{@"leftIcon":@"航空",@"title":@"我的航空"},@{@"leftIcon":@"我的消息",@"title":@"我的消息"},@{@"leftIcon":@"设置",@"title":@"账户设置"},@{@"leftIcon":@"使用协议",@"title":@"使用协议"},@{@"leftIcon":@"联系客服",@"title":@"联系客服"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - table view

//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myInfoArr.count;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyinfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myInfoArr[indexPath.section];
    cell.leftIcon.image = [UIImage imageNamed:dict[@"leftIcon"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
    return 1.f;
}

//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"myInfoToHotel" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"myInfoToAviation" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"myInfoToInformation" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"myInfoToSetting" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"myInfoToProtocol" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"myInfoToSerview" sender:self];
            break;
    }
}

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
