//
//  MyAviationViewController.m
//  GetHotel
//
//  Created by admin1 on 2017/8/25.
//  Copyright © 2017年 com. All rights reserved.
//

#import "MyAviationViewController.h"

@interface MyAviationViewController ()

@end

@implementation MyAviationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//设置导航栏样式
- (void)setNavigationItem{
    self.navigationItem.title = @"我的航空";
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    //[self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 326);
}
@end
