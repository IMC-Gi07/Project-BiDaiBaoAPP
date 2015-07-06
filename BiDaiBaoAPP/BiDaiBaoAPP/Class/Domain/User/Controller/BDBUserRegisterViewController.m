//
//  BDBUserRegisterViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/15.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserRegisterViewController.h"
//引进模型头文件
#import "BDBUserReturnResponseModel.h"
#import <CommonCrypto/CommonDigest.h>



@interface BDBUserRegisterViewController () <UITextFieldDelegate>
/**
 *  帐号输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/**
 *  密码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *
userPassWordTextField;

/**
 *  更新微信支付宝等第三方登入按钮约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWith;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *qwe;



/**
 *  声明md5加密方法
 *
 *  @param password 输入的密码
 *
 *  @return 加密后的密码
 */
- (NSString *)md5HexDigest:(NSString*)password;

@end

@implementation BDBUserRegisterViewController

/**
 *  忘记密码按钮
 */
- (IBAction)forgetPassWord:(UIButton *)sender {
    [self performSegueWithIdentifier:@"BDBForgetPasswordViewController" sender:sender];
//    CATransition *transition = [CATransition animation];
//    transition.type = @"rippleEffect";
//    transition.duration = 0.5f;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}
/**
 *  注册帐号按钮
 *
 *  @param sender sender description
 */
- (IBAction)UserRegest:(UIButton *)sender {
    [self performSegueWithIdentifier:@"BDBRegisterViewController" sender:sender];
//    CATransition *transition = [CATransition animation];
//    transition.type = @"rippleEffect";
//    transition.duration = 0.5f;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}
/**
 *  更新约束方法
 */
-(void)updateViewConstraints{
    
    [self autoArrayBoxWithConstraints:@[self.button1,
                                        self.button2,
                                        self.button3,
                                        self.button4] width:self.buttonWith.constant];
    [super updateViewConstraints];



}
/**
 *  更新约束方法
 *
 *  @param autoConstranitsArray autoConstranitsArray description
 *  @param width                width description
 */
-(void)autoArrayBoxWithConstraints:(NSArray *)autoConstranitsArray width:(CGFloat)width{
    CGFloat step = (self.view.frame.size.width - (width * autoConstranitsArray.count)) / (autoConstranitsArray.count + 1);
    
    for (int i  = 0; i < autoConstranitsArray.count; i++) {
        NSLayoutConstraint * constraint = autoConstranitsArray[i];
        constraint.constant = step * (i + 1) + width * i;
    }
}



- (IBAction)returnButton:(UISwipeGestureRecognizer *)sender {
    
    
//    CATransition *transition = [CATransition animation];
//    transition.type = @"suckEffect";
//    transition.duration = 0.5;
////    transition.delegate = self;
//    
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
    

    //[ addAnimation:transition forKey:nil];
    
    
    
    //利用手势返回上一个界面
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}
/**
 *  是否显示密码按钮
 *
 *  @param sender sender description
 */
- (IBAction)showPassWordButton:(UIButton *)sender {
    
    if (_userPassWordTextField.secureTextEntry == YES) {
        _userPassWordTextField.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ ciphertext_icon"] forState:UIControlStateNormal];
    }
    else{
        _userPassWordTextField.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ plaintext_icon"] forState:UIControlStateNormal];
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
/**
 *  登录按钮
 *
 *  @param sender sender description
 */
- (IBAction)logonButton:(UIButton *)sender {
    
    /**
     *  输入为空提示"请输入账号和密码"
     */
    if (_userNameTextField.text.length == 0 || _userPassWordTextField.text.length == 0) {
        UILabel * tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
        
        tishiLabel.text = @"请输入账号和密码";
        tishiLabel.textColor = [UIColor whiteColor];
        tishiLabel.backgroundColor = [UIColor grayColor];
        tishiLabel.font = [UIFont fontWithName:@"Arial" size:15];
        tishiLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:tishiLabel];
        /**
         *  一秒后移除提示
         *
         *  @param removetishi: removetishi: description
         *
         *  @return return value description
         */
        [self performSelector:@selector(removetishi:) withObject:tishiLabel afterDelay:1];
        
        
        
    }
    
    
    /**
     *      开始请求数据
     */
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
        //网址后面加上getlogin接口
        NSString *userName = _userNameTextField.text;
        NSString *passWord = _userPassWordTextField.text;
        NSString *requesturl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetLogin"];
        NSString *resultStr = [[self md5HexDigest:passWord]uppercaseString];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"UID"] = userName;
        parameters[@"PSW"] = resultStr;
        parameters[@"UserType"] = @"0";
        parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
        parameters[@"Device"] = @"0";
    
    [manager POST:requesturl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"返回结果:%@",responseObject[@"Msg"]);
        NSLog(@"%@",userName);
        NSLog(@"%@",passWord);
        NSLog(@"rusult%@",responseObject[@"Result"]);
        NSLog(@"%@",resultStr);
        
        
        
        /**
         *  如果数据请求成功
         */
        if ([responseObject[@"Result"] isEqualToString:@"0"]) {
            
            /**
             *  获取偏好设置，立刻把账号和密码写到沙盒里面
             */
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userName forKey:@"UID"];
            [userDefaults setObject:resultStr forKey:@"PSW"];
            [userDefaults synchronize];
            /**
             提示登入成功
             */
            UILabel * dengruLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
            dengruLabel.text = @"登录成功";
            dengruLabel.textColor = [UIColor whiteColor];
            dengruLabel.backgroundColor = [UIColor grayColor];
            dengruLabel.font = [UIFont fontWithName:@"Arial" size:15];
            dengruLabel.textAlignment = NSTextAlignmentCenter;
            
            [[UIApplication sharedApplication].keyWindow addSubview:dengruLabel];
            [self performSelector:@selector(removedengruchenggong:) withObject:dengruLabel afterDelay:1];
            
            
            /**
             *  返回一个字典 用模型承接
             */
            BDBUserReturnResponseModel *noticeResponseModel = [BDBUserReturnResponseModel objectWithKeyValues:responseObject];
            
            
            NSLog(@"图像地址:%@",noticeResponseModel.Photo);
            NSLog(@"msg信息:%@",noticeResponseModel.Msg);
            NSLog(@"昵称:%@",noticeResponseModel.NiName);
            NSLog(@"用户名:%@",noticeResponseModel.UserName);
            
            
            
//再次请求收藏和我的消息借口
            
            //获取偏好设置帐号和密码
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //读取保存的数据
            NSString *defaultsUID = [defaults objectForKey:@"UID"];
            NSString *defaultsPSW = [defaults objectForKey:@"PSW"];
            NSLog(@"帐号 = %@,密码 ＝ %@",defaultsUID,defaultsPSW);
            
            
            AFHTTPRequestOperationManager *GetMyParamManager = [AFHTTPRequestOperationManager manager];
            //够造网址
            NSString *GetMyParamUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetMyParam"];
            //数据请求的参数
            NSMutableDictionary *GetMyParamParameters = [NSMutableDictionary dictionary];
            GetMyParamParameters[@"UID"] = defaultsUID;
            GetMyParamParameters[@"PSW"] = defaultsPSW;
            
            [GetMyParamManager POST:GetMyParamUrl parameters:GetMyParamParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"得出我的收藏%@",responseObject[@"StoreNum"]);
                NSLog(@"得出我的消息%@",responseObject[@"MsgNum"]);
                NSLog(@"得出字典%@",responseObject);
                
                NSUserDefaults *GetMyParamDefaults = [NSUserDefaults standardUserDefaults];
                [GetMyParamDefaults setObject:responseObject[@"StoreNum"] forKey:@"StoreNum"];
                [GetMyParamDefaults setObject:responseObject[@"MsgNum"] forKey:@"MsgNum"];
                [GetMyParamDefaults synchronize];
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
            
            
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
        
        /**
         *  如果请求不成功
         *
         *  @param 0 0 description
         *
         *  @return return value description
         */
        else if ([responseObject[@"Result"] isEqualToString:@"1"] && _userNameTextField.text.length > 0 && _userPassWordTextField.text.length > 0) {
            
            UILabel * dengruLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
            
            dengruLabel.text = @"账户或密码错误";
            dengruLabel.textColor = [UIColor whiteColor];
            dengruLabel.backgroundColor = [UIColor grayColor];
            dengruLabel.font = [UIFont fontWithName:@"Arial" size:15];
            dengruLabel.textAlignment = NSTextAlignmentCenter;
            
            [self.view addSubview:dengruLabel];
            [self performSelector:@selector(removedengru:) withObject:dengruLabel afterDelay:1];
            
        }
        
        
        
        
        
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误信息:%@",error);
}];
  
    
}


//MD5加密方法
- (NSString *)md5HexDigest:(NSString*)password
{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    
    //NSLog(@"Encryption Result = %@",mdfiveString);
    return mdfiveString;
}

//移除输入账号密码方法
-(void)removetishi:(UILabel *)laber{
    
    [laber removeFromSuperview];

}
//移除登入失败方法
-(void)removedengru:(UILabel *)laber{
    
    [laber removeFromSuperview];
    
}
//移除登入成功方法
-(void)removedengruchenggong:(UILabel *)laber{
    
    [laber removeFromSuperview];
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userNameTextField.delegate = self;
    _userPassWordTextField.delegate = self;
    self.qwe.constant = [UIScreen mainScreen].bounds.size.width;
    [super updateViewConstraints];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  锁键盘
 *
 *  @param touches touches description
 *  @param event   event description
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userNameTextField resignFirstResponder];
    [_userPassWordTextField resignFirstResponder];
}
/**
 *  缩键盘
 *
 *  @param textField textField description
 *
 *  @return return value description
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_userPassWordTextField resignFirstResponder];
    [_userNameTextField resignFirstResponder];
    return YES;
    
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