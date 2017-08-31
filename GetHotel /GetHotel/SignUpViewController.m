//
//  SignUpViewController.m
//  GetHotel
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SignUpViewController.h"


@interface SignUpViewController ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userPhonetextfiled;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *passWordtextfiled;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasstextfiled;
- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *registrationBtn;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiLayout];
    [self naviConfig];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uiLayout{
    _headImageView.layer.borderColor = [UIColor blueColor].CGColor;
    //判断是否存在记忆体
    if (![[Utilities  getUserDefaults:@"userPhone"] isKindOfClass:[NSNull class]]) {
        if ([Utilities  getUserDefaults:@"userPhone"] != nil) {
            //将它显示在用户名输入框中
            _userPhonetextfiled.text = [Utilities getUserDefaults:@"userPhone"];
        }
    }
    
}

//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)naviConfig {
    //设置导航条标题文字
    self.navigationItem.title = @"注册会员";
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

//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _userPhonetextfiled || textField == _passWordtextfiled || textField == _confirmPasstextfiled) {
        if (_userPhonetextfiled.text.length != 0 && _passWordtextfiled.text.length != 0 && _confirmPasstextfiled.text.length != 0) {
            _registrationBtn.enabled =YES;
        }
    }
}
//按键盘的return收回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _userPhonetextfiled || textField == _passWordtextfiled || textField == _confirmPasstextfiled) {
        [textField resignFirstResponder];
    }
    return YES;
}

//让根视图结束编辑状态，到达收起键盘的目的
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if(_userPhonetextfiled.text.length==0 ||_userPhonetextfiled.text.length<11){
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号" andTitle:nil onView:self];
        return;
    }
    if(_passWordtextfiled.text.length==0)
    {
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self];
        return;
    }
    if(_passWordtextfiled.text.length<6||_passWordtextfiled.text.length>18){
        [Utilities popUpAlertViewWithMsg:@"您输入的密码必须在6到18位之间" andTitle:nil onView:self];
        return;
    }
    //判断电话号码是否都是数字
    NSCharacterSet *notDigits=[[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if(_userPhonetextfiled.text.length<11||[_userPhonetextfiled.text rangeOfCharacterFromSet:notDigits].location!=NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请输入有效手机号" andTitle:nil onView:self];
    }
    //确认无误后，执行网络请求
    [self signUpRequest];
}

- (void)signUpRequest{
    // 创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para=@{@"tel":_userPhonetextfiled.text,@"pwd":_passWordtextfiled.text};
    NSLog(@"para = %@", para);
    //开始请求
    [RequestAPI requestURL:@"/register" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [_aiv stopAnimating];
        NSLog(@"注册：%@", responseObject);
        if ([responseObject[@"result"] integerValue]==1) {
            [Utilities popUpAlertViewWithMsg:@"注册成功" andTitle:@"提示" onView:self];
            [self performSegueWithIdentifier:@"signInToLogin" sender:self];
        }
        else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self ];
        }
        
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        NSLog(@"%ld",(long)statusCode);
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅" andTitle:nil onView:self];
        
    }];
    
}

@end
