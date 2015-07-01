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
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPassWordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWith;



- (NSString *)md5HexDigest:(NSString*)password;

@end

@implementation BDBUserRegisterViewController

//忘记密码
- (IBAction)forgetPassWord:(UIButton *)sender {
    [self performSegueWithIdentifier:@"789" sender:sender];
//    CATransition *transition = [CATransition animation];
//    transition.type = @"rippleEffect";
//    transition.duration = 0.5f;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}

- (IBAction)UserRegest:(UIButton *)sender {
    [self performSegueWithIdentifier:@"meiyouzhanghao" sender:sender];
//    CATransition *transition = [CATransition animation];
//    transition.type = @"rippleEffect";
//    transition.duration = 0.5f;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}

-(void)updateViewConstraints{
    
    [self autoArrayBoxWithConstraints:@[self.button1,
                                        self.button2,
                                        self.button3,
                                        self.button4] width:self.buttonWith.constant];
    [super updateViewConstraints];



}

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
    
    
    
    
//    
//    UIViewController *TestViewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"12"];
//    [self.navigationController pushViewController:TestViewController animated:YES];
    
}
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

- (IBAction)logonButton:(UIButton *)sender {
    
    if (_userNameTextField.text.length == 0 || _userPassWordTextField.text.length == 0) {
        UILabel * tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
        
        tishiLabel.text = @"请输入账号和密码";
        tishiLabel.textColor = [UIColor whiteColor];
        tishiLabel.backgroundColor = [UIColor grayColor];
        tishiLabel.font = [UIFont fontWithName:@"Arial" size:15];
        tishiLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:tishiLabel];
        [self performSelector:@selector(removetishi:) withObject:tishiLabel afterDelay:1];
        
        
        
    }
    
    
    
    
    
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
        
        
        
        
        if ([responseObject[@"Result"] isEqualToString:@"0"] && _userNameTextField.text.length > 0 && _userPassWordTextField.text.length > 0) {
            
            //获取偏好设置，立刻把账号和密码写到沙盒里面
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userName forKey:@"UID"];
            [userDefaults setObject:resultStr forKey:@"PSW"];
            [userDefaults synchronize];
            
            UILabel * dengruLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
            
            dengruLabel.text = @"登录成功";
            dengruLabel.textColor = [UIColor whiteColor];
            dengruLabel.backgroundColor = [UIColor grayColor];
            dengruLabel.font = [UIFont fontWithName:@"Arial" size:15];
            dengruLabel.textAlignment = NSTextAlignmentCenter;
            
            [[UIApplication sharedApplication].keyWindow addSubview:dengruLabel];
            [self performSelector:@selector(removedengruchenggong:) withObject:dengruLabel afterDelay:1];
            
            BDBUserReturnResponseModel *noticeResponseModel = [BDBUserReturnResponseModel objectWithKeyValues:responseObject];
            NSLog(@"图像地址:%@",noticeResponseModel.Photo);
            NSLog(@"msg信息:%@",noticeResponseModel.Msg);
            NSLog(@"昵称:%@",noticeResponseModel.NiName);
            NSLog(@"用户名:%@",noticeResponseModel.UserName);
            
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
        
        
        else if ([responseObject[@"Result"] isEqualToString:@"1"] && _userNameTextField.text.length > 0 && _userPassWordTextField.text.length > 0) {
            
            UILabel * dengruLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
            
            dengruLabel.text = @"账户或密码错误";
            dengruLabel.textColor = [UIColor whiteColor];
            dengruLabel.backgroundColor = [UIColor grayColor];
            dengruLabel.font = [UIFont fontWithName:@"Arial" size:15];
            dengruLabel.textAlignment = NSTextAlignmentCenter;
            
            [self.view addSubview:dengruLabel];
            [self performSelector:@selector(removedengru:) withObject:dengruLabel afterDelay:1];
            
            
            //self.navigationController
        }
        
        
        
        
        
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误信息:%@",error);
}];
  
    
}


//MD5
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

    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userNameTextField resignFirstResponder];
    [_userPassWordTextField resignFirstResponder];
}

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
