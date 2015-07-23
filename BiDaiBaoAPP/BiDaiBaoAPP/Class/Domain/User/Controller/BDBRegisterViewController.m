//
//  BDBRegisterViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/19.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBRegisterViewController.h"
#import "BDBUserRegisterPassViewController.h"

@interface BDBRegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *RegisterTextField;
@property (weak, nonatomic) IBOutlet UILabel *RegisterUserLabel;
@property (weak, nonatomic) IBOutlet UIButton *NextButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation BDBRegisterViewController




-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        //隐藏底部
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"注册账号";
    }
    return self;
}

- (IBAction)bdbdalegateButton:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"BDBUserDalegateViewController" sender:sender];
    
    //self.hidesBottomBarWhenPushed = YES;

}





- (IBAction)registerView:(UIButton *)sender {
    [self performSegueWithIdentifier:@"yiyouzhanghao" sender:sender];
    
//    CATransition *transition = [CATransition animation];
//    transition.type = @"suckEffect";
//    transition.duration = 0.5;
//    //    transition.delegate = self;
//    
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}
- (IBAction)NextButton:(UIButton *)sender {
    if (_RegisterTextField.text.length == 0) {
        UILabel * tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
        
        tishiLabel.text = @"请输入账号和密码";
        tishiLabel.textColor = [UIColor whiteColor];
        tishiLabel.backgroundColor = [UIColor grayColor];
        tishiLabel.font = [UIFont fontWithName:@"Arial" size:15];
        tishiLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:tishiLabel];
        
        [self performSelector:@selector(removetishi:) withObject:tishiLabel afterDelay:2];
        
        
    }
    else if (_RegisterTextField.text.length > 0 ){
        //请求判断用户名是否已经存在
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *request = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetSearchUser"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"UID"] = _RegisterTextField.text;
        [manager POST:request parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"Result"] isEqualToString:@"0"]) {
                UILabel * tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
                
                tishiLabel.text = @"该用户名已经存在";
                tishiLabel.textColor = [UIColor whiteColor];
                tishiLabel.backgroundColor = [UIColor grayColor];
                tishiLabel.font = [UIFont fontWithName:@"Arial" size:15];
                tishiLabel.textAlignment = NSTextAlignmentCenter;
                
                [self.view addSubview:tishiLabel];
                
                [self performSelector:@selector(removetishi:) withObject:tishiLabel afterDelay:2];
            }
            else if ([responseObject[@"Result"]isEqualToString:@"1"]){
                
            [self performSegueWithIdentifier:@"BDBUserRegisterPassViewController" sender:sender];
        }
            else if ([responseObject[@"Result"]isEqualToString:@"2"]){
                UILabel * tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
                
                tishiLabel.text = @"未知注册错误信息";
                tishiLabel.textColor = [UIColor whiteColor];
                tishiLabel.backgroundColor = [UIColor grayColor];
                tishiLabel.font = [UIFont fontWithName:@"Arial" size:15];
                tishiLabel.textAlignment = NSTextAlignmentCenter;
                
                [self.view addSubview:tishiLabel];
                
                [self performSelector:@selector(removetishi:) withObject:tishiLabel afterDelay:2];

            
            
            }
                

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"%@",error);
}];

        
        
        
        
        
    }
    
}
-(void)removetishi:(UILabel *)laber{
    
    [laber removeFromSuperview];
    
}


- (IBAction)dagouButton:(UIButton *)sender {
    

    //得到正常状态下的图片
    if([sender imageForState:UIControlStateNormal] == nil){
        [sender  setImage:[UIImage imageNamed:@"dagou"] forState:UIControlStateNormal];
        if (_RegisterTextField.text.length > 10) {
            self.NextButton.enabled = YES;
        }
        
    }
    else{
    
        [sender setImage:nil forState:UIControlStateNormal];
        self.NextButton.enabled = NO;
    }
    
    
    
}

//-(void)buttonImageChange:(UIButton*)button{
//
//    
//}


- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _RegisterTextField.delegate = self;
    self.NextButton.enabled = NO;
    
    
    // Do any additional setup after loading the view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"BDBUserRegisterPassViewController"]) {
        id thesegue = segue.destinationViewController;
        [thesegue setValue:_RegisterTextField.text forKey:@"number"];
    }
    



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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_RegisterTextField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    [_RegisterTextField resignFirstResponder];
    return YES;
    
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = textField.text;
    // Handling 'delete'
    if (range.length == 1 &&
        [string isEqualToString:@""])
    {
        _RegisterUserLabel.text = [str substringToIndex:([str length] - 1)];
    }else{
        _RegisterUserLabel.text = [str stringByAppendingString:string];
    }
    
    
    if (_RegisterTextField.text.length <= 9) {
        self.NextButton.enabled = NO;
    }
    if (_RegisterTextField.text.length >9 && [self.selectButton imageForState:UIControlStateNormal]!= nil) {
        self.NextButton.enabled = YES;
    }
    
    return YES;
    
    
    
    
}




@end
