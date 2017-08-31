//
//  SignInViewController.m
//  GetHotel
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SignInViewController.h"
#import "UserModel.h"
@interface SignInViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userPhonetextword;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWordtextword;
- (IBAction)signAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property(strong,nonatomic) UIActivityIndicatorView *aiv;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _signBtn.enabled = NO;
    _signBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    [_userPhonetextword addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_passWordtextword addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self naviConfig];
    
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
//当textField结束编辑的时候调用
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _userPhonetextword || textField == _passWordtextword){
        //当用户名和密码都输入后，按钮才能被点击
        if(_userPhonetextword.text.length != 0 && textField.text.length !=0){
            _signBtn.enabled = YES;
        }
    }
    
}
//输入框内容改变的监听事件
- (void)textChange:(UITextField *)textField{
    //当文本框中的内容改变时判断内容长度是否为0，是：启用按钮，否：禁用按钮
    if(_userPhonetextword.text.length != 0 && _passWordtextword.text.length != 0){
        _signBtn.enabled = YES;
        _signBtn.backgroundColor = UIColorFromRGB(99, 163, 210);
        [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        _signBtn.enabled = NO;
        _signBtn.backgroundColor = UIColorFromRGB(153, 153, 153);
    }
}

//设置导航栏样式
- (void)naviConfig{
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    //[self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//键盘收回
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _userPhonetextword || textField == _passWordtextword){
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)signAction:(UIButton *)sender forEvent:(UIEvent *)event
{
    if (_userPhonetextword.text.length==0)
    {
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    if (_passWordtextword.text.length==0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的密码" andTitle:nil onView:self];
        return;
    }
    if (_passWordtextword.text.length<6||_passWordtextword.text.length>18)
    {
        [Utilities popUpAlertViewWithMsg:@"您输入的密码必须在6到18位之间" andTitle:nil onView:self];
        return;
    }
        //判断某个字符串中是否都是数字
        NSCharacterSet *notDigits=[[NSCharacterSet decimalDigitCharacterSet]invertedSet];
        if ([_userPhonetextword.text rangeOfCharacterFromSet:notDigits].location!=NSNotFound||_userPhonetextword.text.length<11)
        {
            [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
            return;
        }
        //无输入异常的情况下，开始正式执行登录接口
        [self readyForEncoding];
        
}
-(void)readyForEncoding{
    _aiv=[Utilities getCoverOnView:self.view];
    [RequestAPI requestURL:@"/login" withParameters:@{@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject)
        {
            //NSLog(@"responseObject":%@,responseObject);
            if ([responseObject[@"resultFlag"]integerValue]==8001)
            {
                NSDictionary *result=responseObject[@"result"];
                NSString *modulus = result[@"modulus"];
                NSString *exponent = result[@"exponent"];
                //对内容进行MD5加密
                NSString *md5Str=[_passWordtextword.text getMD5_32BitString];
                
                
                //用模数和指数对MD5密码进行加密过后的密码进行加密   categary
                NSString *rsaStr=[NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
                [self signInWithEncryptPwd:rsaStr];
            }else{
                [_aiv stopAnimating];
                NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
                [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];

            }
        }failure:^(NSInteger statusCode, NSError *error) {
            [_aiv stopAnimating];
             //业务逻辑失败的情况下
            [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
        }];
        
}
    
-(void)signInWithEncryptPwd:(NSString *)encryptPwd
{
     [RequestAPI requestURL:@"/login" withParameters:@{@"userName":_userPhonetextword.text, @"password":encryptPwd,@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
            [_aiv stopAnimating];
            NSLog(@"responseObject=%@",responseObject);
    if ([responseObject[@"resultFlag"]integerValue]==1) {
                NSDictionary *result=responseObject[@"result"];
        UserModel *user=[[UserModel alloc]initWhitDictionary:result];
                //将用户获取到的信息打包存储到单例化全局变量
                [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:user];
                //单独将用户的ID也存储进去单例化全局变量中来作为用户是否已经登录的判断依据，同时也方便其他所有的页面更快捷的使用用户ID这个参数
                [[StorageMgr singletonStorageMgr]addKey:@"MemberId" andValue:user.memberId];
                //如果键盘还开着 就让他收回去
                [self.view endEditing:YES];
                //清空密码输入框的内容
                _passWordtextword.text=@"";
                //记忆用户名
                [Utilities setUserDefaults:@"Username" content:_userPhonetextword.text];
                //用model的方式返回上一页
                [self dismissViewControllerAnimated:YES completion:nil];
                
        }else{
                NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
                [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
            [_aiv stopAnimating];
            //业务逻辑失败的情况下
            [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
    }];
}

@end
