//
//  BDBUserRegisterPassViewController.m
//  BiDaiBaoAPP
//
//  Created by Carrie's baby on 15/6/30.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserRegisterPassViewController.h"
#import <CommonCrypto/CommonDigest.h>
@interface BDBUserRegisterPassViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UILabel *UserWordLabel;

@property (strong,nonatomic) NSString *number;
@end

@implementation BDBUserRegisterPassViewController
/**
 *  初始化按钮
 *
 *  @param aDecoder aDecoder description
 *
 *  @return return value description
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"注册";
    }
    
    return self;

}
- (IBAction)UserOfOver:(UIButton *)sender {
    
     if (_passWordTextField.text.length > 0 ){
         
            //创建一个httprequesoperationmanger
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //定义网址和接口   接口接在网址后面
            NSString *request = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetRegister"];
         NSString *scanfPassWord = _passWordTextField.text;
         NSString *MD5passWord = [[self md5HexDigest:scanfPassWord]uppercaseString];
         
            //创建一个字典用来穿参数
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
         parameters[@"UID"] = _number;
         parameters[@"PSW"] = MD5passWord;
         parameters[@"UserType"] = @"0";
         parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
         parameters[@"Device"] = @"0";
         
         [manager POST:request parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"注册账户名:%@",_UserWordLabel);
             NSLog(@"请求成功%@",responseObject[@"Msg"]);
             NSLog(@"请求成功%@",responseObject[@"Result"]);
             NSLog(@"加密后密码%@",MD5passWord);
             NSLog(@"responseObject:%@",responseObject);
             if ([responseObject[@"Result"] isEqualToString:@"0"]) {
                 
                 UILabel * tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
                 
                 tishiLabel.text = @"恭喜你注册成功";
                 tishiLabel.textColor = [UIColor whiteColor];
                 tishiLabel.backgroundColor = [UIColor grayColor];
                 tishiLabel.font = [UIFont fontWithName:@"Arial" size:15];
                 tishiLabel.textAlignment = NSTextAlignmentCenter;
                 
                 //[self.view addSubview:tishiLabel];
                 [[UIApplication sharedApplication].keyWindow addSubview:tishiLabel];
                 
                 [self performSelector:@selector(removetishi:) withObject:tishiLabel afterDelay:1];
                 
                 
                 
                 [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@",error);
         }];
         
         
         
     }
}

-(void)removetishi:(UILabel *)laber{
    
    [laber removeFromSuperview];
    
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
    
    NSLog(@"Encryption Result = %@",mdfiveString);
    return mdfiveString;
}



-(void)viewDidLoad{
    NSLog(@"%@",_number);
    _passWordTextField.delegate = self;
    NSString *str = _number;
    NSString *xingxingStr =  [str stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    _UserWordLabel.text = xingxingStr;



}
- (IBAction)seePassButton:(UIButton *)sender {
    
    if (_passWordTextField.secureTextEntry == YES) {
        _passWordTextField.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ ciphertext_icon"] forState:UIControlStateNormal];
    }
    else{
        _passWordTextField.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ plaintext_icon"] forState:UIControlStateNormal];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_passWordTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_passWordTextField resignFirstResponder];
 
    return YES;
    
}




@end
