//
//  BDBCPIViewController.m
//  User_version_2
//
//  Created by Imcore.olddog.cn on 15/6/19.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserCPIViewController.h"
#import "BDBUserCPIResponseModel.h"


//根据cpi 计算不正确，请修改
@interface BDBUserCPIViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBlueView;

@property(nonatomic,strong) NSString *CPI;

@property(nonatomic,strong) NSString *MaxEarning;

@property (weak, nonatomic) IBOutlet UILabel *accordingCPILabel;

@property (weak, nonatomic) IBOutlet UILabel *accordingBDBLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentCPILabel;

@property (weak, nonatomic) IBOutlet UITextField *currentMoneyTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *termTextFiled;

@property(weak,nonatomic) NSLayoutConstraint *topConstraint_topView;

@property(weak,nonatomic) NSLayoutConstraint *heightConstraint_messageView;

@property(weak,nonatomic) UILabel *msgLabel;

@end

@implementation BDBUserCPIViewController

- (instancetype)init{

    if(self  = [super init]){
    
        self.title = @"CPI跟踪器";
        [self loadMaxEarnings];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentMoneyTextFiled.delegate = self;
    _currentMoneyTextFiled.tag = 100;
    
    _termTextFiled.delegate = self;
    _termTextFiled.tag = 101;
    
    [self constraintForTopBlueView];
    
    [self loadMessage];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//为topBlue顶部增加约束
- (void)constraintForTopBlueView{
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_topBlueView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:topConstraint];
    
    self.topConstraint_topView = topConstraint;
    
}
- (void)loadMaxEarnings{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetMaxEarnings"];
    
    [manager POST:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BDBUserCPIResponseModel *responseModel = [BDBUserCPIResponseModel objectWithKeyValues:responseObject];
        self.CPI = responseModel.CPI;
        
        self.MaxEarning = responseModel.MaxEarnings;
        
        _currentCPILabel.text = _CPI;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"%@",error);
    }];
}

//红色提示框

- (void)loadMessage{

    UIView *messageView = [[UIView alloc] init];
    
    messageView.backgroundColor = UIColorWithRGB(230, 92, 99);
    
    [self.view addSubview: messageView];
    
    messageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[messageView]|" options:0 metrics:nil views:@{@"messageView":messageView}];
    
    [self.view addConstraints:hConstraint];
    
    NSLayoutConstraint *topConstraint_messageView = [NSLayoutConstraint constraintWithItem:messageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:topConstraint_messageView];
    
    NSLayoutConstraint *heightConstraint_messageView = [NSLayoutConstraint constraintWithItem:messageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
    
    self.heightConstraint_messageView = heightConstraint_messageView;
    
    [messageView addConstraint:heightConstraint_messageView];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    
    messageLabel.textColor = [UIColor whiteColor];
    
    messageLabel.tag = 200;
    
    messageLabel.frame = CGRectMake(20, 5, SCREEN_WIDTH, 20);
    
    [messageView addSubview:messageLabel];
    
    self.msgLabel = messageLabel;
    
}

//弹出红色框
- (void)showMessage :(NSString *)msg{
    
    _msgLabel.text = [msg stringByAppendingString:@"年后,推算你的财富为:"];

    self.heightConstraint_messageView.constant = 30.0f;
    
    self.topConstraint_topView.constant = 30.0f;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    
    BOOL flag = NO;
    NSString *tmpstring;
    if(textField.tag != 101){
        tmpstring = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]];
    }
    else{
        
        tmpstring = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]];
    }
    
    if(tmpstring.length > 0)
    {
        flag = NO;
        
    }
    else{
        
        if([string isEqualToString:@"."]){
            
            if(textField.text.length > 0 && [textField.text rangeOfString:@"."].location == NSNotFound){
                
                flag = YES;
            }
            else{
                
                flag = NO;
            }
            
        }else{
            flag = YES;
        }
        
    }
    
    if (flag) {
        tmpstring = string;
    }
    
    CGFloat cpi = [_CPI doubleValue];
    CGFloat maxEarning = [_MaxEarning doubleValue];
    if(textField.tag == 100){
        
        CGFloat currenMoney = 0.0f;
        
        //增加一个数
        if(range.length == 0){
            currenMoney = [[textField.text stringByAppendingString:tmpstring] doubleValue];
        }
        //删除一个数
        else{
            
            currenMoney = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue];
        }
    
        if(_termTextFiled.text.length > 0){
        
            CGFloat term = [_termTextFiled.text doubleValue];
            

            _accordingCPILabel.text = [NSString stringWithFormat:@"%.2f",currenMoney - (cpi / currenMoney * term)];
            
            NSLog(@"%g",currenMoney - (cpi / currenMoney * term));
            
            
            for(NSInteger i = 0;i < term ;i ++){
            
                currenMoney = currenMoney * (maxEarning + 1);
                
            }
            
            _accordingBDBLabel.text = [NSString stringWithFormat:@"%.2f",currenMoney];
            
            [self showMessage:_termTextFiled.text];
        }
    }
    
    if(textField.tag == 101){
        
        CGFloat term = 0;
        
        //增加一个数
        if(range.length == 0){
            term = [[textField.text stringByAppendingString:tmpstring] doubleValue];
        }
        //删除一个数
        else{
            
            term = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue];
        }
        
        if(_currentMoneyTextFiled.text.length > 0){
            
            CGFloat currenMoney = [_currentMoneyTextFiled.text doubleValue];
            
            _accordingCPILabel.text = [NSString stringWithFormat:@"%.2f",currenMoney - cpi / currenMoney * term];
            
            for(NSInteger i = 0;i < term ;i ++){
                
                currenMoney = currenMoney * (maxEarning + 1);
                
            }
            
            _accordingBDBLabel.text = [NSString stringWithFormat:@"%.2f",currenMoney];
            
            [self showMessage:[NSString stringWithFormat:@"%g",term]];

        }
    }
    
    return flag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
@end
