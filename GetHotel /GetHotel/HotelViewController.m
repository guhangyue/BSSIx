//
//  HotelViewController.m
//  GetHotel
//
//  Created by IMAC on 2017/8/25.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HotelViewController.h"

@interface HotelViewController ()

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
    if (![self.navigationController.viewControllers containsObject:self]) {
        //在这里先释放所有监听（包括：Action事件；protocol协议；Gesture手势；notification通知...）
        //所有通过storeboard故事板添加的控件以及监听都会自动释放。
        //所有设置为new的方法都有一个专用的方法来释放
    }
}

@end
