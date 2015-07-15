//
//  BDBForgetPasswordViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/19.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBForgetPasswordViewController.h"

@interface BDBForgetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ForgetPasswordUser;
@property (weak, nonatomic) IBOutlet UITextField *Forgetpasswordagain;

@end

@implementation BDBForgetPasswordViewController

/**
 *  类的初始化
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"找回密码";
    }
    
    return self;
    
}

/**
 *  确认按钮
 */
- (IBAction)ForgetButton:(UIButton *)sender {
    /**
     *  如果输入为空提示"请输入手机号或者邮箱"
     */
    if (_ForgetPasswordUser.text.length == 0) {
        
        UILabel *forgetLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
        forgetLabel.text = @"请输入手机号或邮箱";
        forgetLabel.textColor = [UIColor whiteColor];
        forgetLabel.backgroundColor = [UIColor grayColor];
        forgetLabel.font = [UIFont fontWithName:@"Arial" size:15];
        forgetLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:forgetLabel];
        /**
         * 提示"请输入手机号或邮箱后一秒将提示移除"
         */
        [self performSelector:@selector(removeForgetLabel:) withObject:forgetLabel afterDelay:2];
        
    }
    else if (![_ForgetPasswordUser.text isEqualToString:_Forgetpasswordagain.text]){
    
        UILabel *forgetLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
        forgetLabel.text = @"两次输入不一致";
        forgetLabel.textColor = [UIColor whiteColor];
        forgetLabel.backgroundColor = [UIColor grayColor];
        forgetLabel.font = [UIFont fontWithName:@"Arial" size:15];
        forgetLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:forgetLabel];
        /**
         * 提示"请输入手机号或邮箱后一秒将提示移除"
         */
        [self performSelector:@selector(removeForgetLabel:) withObject:forgetLabel afterDelay:2];
    
    
    
    }
    /**
     *  输入两次的结果一次,运行代码
     */
    else if ([_ForgetPasswordUser.text isEqualToString:_Forgetpasswordagain.text]){
        
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        
        NSString *requesturl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetUserPassword"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"UID"] =_ForgetPasswordUser.text;
        parameters[@"UserType"] = @"0";
        parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
        parameters[@"Device"] = @"0";
        
        [manger POST:requesturl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        
            if ([responseObject[@"Msg"] isEqualToString:@"用户没有绑定邮箱或者手机"]) {
                UILabel *forgetLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
                forgetLabel.text = @"用户没有绑定邮箱或者手机";
                forgetLabel.textColor = [UIColor whiteColor];
                forgetLabel.backgroundColor = [UIColor grayColor];
                forgetLabel.font = [UIFont fontWithName:@"Arial" size:15];
                forgetLabel.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:forgetLabel];
                /**
                 * 提示"请输入手机号或邮箱后一秒将提示移除"
                 */
                [self performSelector:@selector(removeForgetLabel:) withObject:forgetLabel afterDelay:2];

            }
            else if ([responseObject[@"Result"] isEqualToString:@"0"]){
                ZXLLOG(@"dd%@",responseObject[@"EMail"]);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ZXLLOG(@"错误信息:%@",error);
    }];
        
}
    
    
    
    
    
    
    
}
/**
 *  移除提示方法
 *
 *  @param label 提示视图
 */
-(void)removeForgetLabel:(UILabel *)label{

    [label removeFromSuperview];

}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ForgetPasswordUser.delegate = self;
    _Forgetpasswordagain.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  缩键盘
 *
 *  @param touches 键盘外的地方
 *  @param event   键盘外的地方
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_ForgetPasswordUser resignFirstResponder];
    [_Forgetpasswordagain resignFirstResponder];
}
/**
 *  缩键盘
 *
 *  @param textField 键盘外的地方
 *
 *  @return 键盘外的地方
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_ForgetPasswordUser resignFirstResponder];
    [_Forgetpasswordagain resignFirstResponder];
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
