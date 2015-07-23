//
//  BDBUserChangeViewController.m
//  BiDaiBaoAPP
//
//  Created by Carrie's baby on 15/7/15.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserChangeViewController.h"
#import <CommonCrypto/CommonDigest.h>


@interface BDBUserChangeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *agoPassWord;
@property (weak, nonatomic) IBOutlet UITextField *newsPassWord;

@property (weak, nonatomic) IBOutlet UITextField *againNewsPassWord;

@property (nonatomic,copy) NSString *agopassword;
@property (nonatomic,copy) NSString *newspassword;

@end

@implementation BDBUserChangeViewController

- (instancetype)init{

    if (self = [super init]) {
        self.title = @"修改密码";
    }
    return self;
}

- (IBAction)SeePassWord:(UIButton *)sender {
    
    if (_agoPassWord.secureTextEntry == YES) {
        _agoPassWord.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ ciphertext_icon"] forState:UIControlStateNormal];
    }
    else{
        _agoPassWord.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ plaintext_icon"] forState:UIControlStateNormal];
    }

    
}
- (IBAction)newsPassWord:(UIButton *)sender {
    
    
    if (_newsPassWord.secureTextEntry == YES) {
        _newsPassWord.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ ciphertext_icon"] forState:UIControlStateNormal];
    }
    else{
        _newsPassWord.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ plaintext_icon"] forState:UIControlStateNormal];
    }

}
- (IBAction)againNewsPassWord:(UIButton *)sender {
    
    
    if (_againNewsPassWord.secureTextEntry == YES) {
        _againNewsPassWord.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ ciphertext_icon"] forState:UIControlStateNormal];
    }
    else{
        _againNewsPassWord.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"user_ plaintext_icon"] forState:UIControlStateNormal];
    }

}
- (IBAction)sureChangeButton:(UIButton *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //读取保存的数据
    NSString *defaultsUID = [defaults objectForKey:@"UID"];
    //得到以前加密过的密码
    _agopassword = [[self md5HexDigest:_agoPassWord.text]uppercaseString];
    ZXLLOG(@"原来的密码加密%@",_agopassword);
    _newspassword = [[self md5HexDigest:_newsPassWord.text]uppercaseString];
    ZXLLOG(@"新密码加密%@",_newspassword);
    
    if ([_newsPassWord.text isEqualToString:_againNewsPassWord.text]) {
        
        AFHTTPRequestOperationManager *SetUserInfmanager = [AFHTTPRequestOperationManager manager];
        NSString *SetUserInfURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetUserInf"];
        //数据请求的参数
        NSMutableDictionary *SetUserInfParameters = [NSMutableDictionary dictionary];
        SetUserInfParameters[@"UID"] = defaultsUID;
        SetUserInfParameters[@"UserType"] = @"0";
        SetUserInfParameters[@"PSW"] = _agopassword;
        SetUserInfParameters[@"NewPSW"] = _newspassword;
        
        [SetUserInfmanager POST:SetUserInfURL parameters:SetUserInfParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject[@"Msg"]);
            
            
            if ([responseObject[@"Result"] isEqualToString:@"0"]) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_newspassword forKey:@"PSW"];
                NSLog(@"写进沙盒里面的密码 %@",_newspassword);
                [defaults synchronize];
                _agoPassWord.text = @"";
                _newsPassWord.text = @"";
                _againNewsPassWord.text = @"";
                
                UILabel * dengruLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
                dengruLabel.text = @"恭喜你修改成功！";
                dengruLabel.textColor = [UIColor whiteColor];
                dengruLabel.backgroundColor = [UIColor grayColor];
                dengruLabel.font = [UIFont fontWithName:@"Arial" size:15];
                dengruLabel.textAlignment = NSTextAlignmentCenter;
                
                [[UIApplication sharedApplication].keyWindow addSubview:dengruLabel];
                [self performSelector:@selector(removetishi:) withObject:dengruLabel afterDelay:1];
                
               
            
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ZXLLOG(@"sdfsdf");
        }];
        
        
    }

    else{
        UILabel * dengruLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
        dengruLabel.text = @"两次的密码输入不一致";
        dengruLabel.textColor = [UIColor whiteColor];
        dengruLabel.backgroundColor = [UIColor grayColor];
        dengruLabel.font = [UIFont fontWithName:@"Arial" size:15];
        dengruLabel.textAlignment = NSTextAlignmentCenter;
        
        [[UIApplication sharedApplication].keyWindow addSubview:dengruLabel];
        [self performSelector:@selector(removetishi:) withObject:dengruLabel afterDelay:1];
        
    
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

@end
