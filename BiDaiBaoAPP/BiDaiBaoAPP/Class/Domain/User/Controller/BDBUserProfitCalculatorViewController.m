//
//  BDBProfitCalculatorViewController.m
//  User_version_2
//
//  Created by Imcore.olddog.cn on 15/6/19.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserProfitCalculatorViewController.h"

//#import "IQKeyboardReturnKeyHandler.h"


@interface BDBUserProfitCalculatorViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalInterestLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyOfEveryMonthLabel;

@property (weak, nonatomic) IBOutlet UITextField *investmentMoneyTextField;

@property (weak, nonatomic) IBOutlet UITextField *InterestRateOfYearTextField;
@property (weak, nonatomic) IBOutlet UITextField *termTextField;

@property (weak, nonatomic) IBOutlet UIView *topBlueView;


- (void)constraintForTopBlueView;

- (void)calculateResultWithTotalMoney:(CGFloat)totalMoney interestRateOfDay:(CGFloat)aInterestRateOfDay term:(CGFloat)aTerm;

//@property(nonatomic,strong) IQKeyboardReturnKeyHandler *keyBoardManager;

@end

@implementation BDBUserProfitCalculatorViewController

- (instancetype)init{

    if(self = [super init]){
    
        self.title = @"收益计算器";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _investmentMoneyTextField.delegate = self;
    _investmentMoneyTextField.tag = 100;
    
    _InterestRateOfYearTextField.delegate = self;
    _InterestRateOfYearTextField.tag = 101;
    
    _termTextField.delegate = self;
    _termTextField.tag = 102;
    
    if(_investmentMoneyText != nil){
    
        _investmentMoneyTextField.text = _investmentMoneyText;
    }
    
    if(_interestRateText != nil){
    
        _InterestRateOfYearTextField.text = _interestRateText;
        _InterestRateOfYearTextField.enabled = NO;
    }
    
    if(_termText != nil){
    
        _termTextField.text = _termText;
        _termTextField.enabled = NO;
    }
    
    [self constraintForTopBlueView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//为topBlue顶部增加约束
- (void)constraintForTopBlueView{
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_topBlueView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:topConstraint];
    
}

//计算结果

- (void)calculateResultWithTotalMoney:(CGFloat)totalMoney interestRateOfDay:(CGFloat)aInterestRateOfDay term:(CGFloat)aTerm{
    
    _totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney * aInterestRateOfDay * aTerm + totalMoney];
    
    _totalInterestLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney * aInterestRateOfDay * aTerm];
    
    _moneyOfEveryMonthLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney * aInterestRateOfDay * 30];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL flag = NO;
    NSString *tmpstring;
    if(textField.tag != 102){
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
    else{
    
        tmpstring = @"";
    }
    
    
    //投资金额
    CGFloat totalMoney = 0.0f;
    //年化利率
    CGFloat interestRateOfDay = 0.0f;
    //借款天数
    CGFloat term = 0.0f;
    
    if(textField.tag == 100){
        
        //增加一个数
        if(range.length == 0){
            totalMoney = [[textField.text stringByAppendingString:tmpstring] doubleValue];
        }
        //删除一个数
        else{
        
            totalMoney = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue];
        }
        
        if(_InterestRateOfYearTextField.text.length > 0 && _termTextField.text.length > 0){
            
            interestRateOfDay = [_InterestRateOfYearTextField.text doubleValue] / 365.0f / 100.0f;
            
            term = [_termTextField.text doubleValue];
            
        }

    }
    
    if(textField.tag == 101){
        
        if(range.length == 0){
            interestRateOfDay = [[textField.text stringByAppendingString:tmpstring] doubleValue] / 365.0f / 100.0f;
        }
        else{
            
            interestRateOfDay = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue] / 365.0f / 100.0f;
        }
        
        if(_investmentMoneyTextField.text.length > 0 && _termTextField.text.length > 0){
                
            
            totalMoney = [_investmentMoneyTextField.text doubleValue];
            
            term = [_termTextField.text doubleValue];
        }
        
    }
    
    if(textField.tag == 102){
        
        //增加一个数
        if(range.length == 0){
            term = [[textField.text stringByAppendingString:tmpstring] doubleValue];
        }
        //删除一个数
        else{
            
            term = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue];
        }
        
        if(_InterestRateOfYearTextField.text.length > 0 && _investmentMoneyTextField.text.length > 0){
            
                 totalMoney = [_investmentMoneyTextField.text doubleValue];
                
                 interestRateOfDay = [_InterestRateOfYearTextField.text doubleValue] / 365.0f / 100.0f;
        }
        
    }
    if(totalMoney == 0 || interestRateOfDay == 0 || term == 0){
    
        _totalMoneyLabel.text = @"0.00";
        _totalInterestLabel.text = @"0.00";
        _moneyOfEveryMonthLabel.text = @"0.00";
    }
    else{
        
        [self calculateResultWithTotalMoney:totalMoney interestRateOfDay:interestRateOfDay term:term];
    }
    

    return flag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

@end
