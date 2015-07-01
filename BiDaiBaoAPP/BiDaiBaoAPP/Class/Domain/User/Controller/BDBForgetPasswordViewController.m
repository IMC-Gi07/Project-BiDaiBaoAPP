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
- (IBAction)ForgetButton:(UIButton *)sender {
    
    if (_ForgetPasswordUser.text.length == 0) {
        
        UILabel *forgetLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
        
        forgetLabel.text = @"请输入手机号或邮箱";
        forgetLabel.textColor = [UIColor whiteColor];
        forgetLabel.backgroundColor = [UIColor grayColor];
        forgetLabel.font = [UIFont fontWithName:@"Arial" size:15];
        forgetLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [self.view addSubview:forgetLabel];
        
        [self performSelector:@selector(removeForgetLabel:) withObject:forgetLabel afterDelay:1];
        
    }
}

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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_ForgetPasswordUser resignFirstResponder];
    [_Forgetpasswordagain resignFirstResponder];
}

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
