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

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
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
    UIBarButtonItem *barBtn5=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
    self.navigationItem.leftBarButtonItem=barBtn5;
}
-(void)leftButtonAction:(UIBarButtonItem *)sender{
    //[self.navigationController popViewControllerAnimated:YES];
     HotelDetailViewController *senCon1=[[HotelDetailViewController alloc]init];
    [self.navigationController pushViewController:senCon1 animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
