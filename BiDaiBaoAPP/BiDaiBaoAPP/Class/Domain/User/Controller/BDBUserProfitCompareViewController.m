//
//  BDBProfitCalculatorViewController.m
//  User_version_2
//
//  Created by Imcore.olddog.cn on 15/6/19.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserProfitCompareViewController.h"

//#import "IQKeyboardReturnKeyHandler.h"


@interface BDBUserProfitCompareViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topBlueView;
@property (weak, nonatomic) IBOutlet UILabel *yebLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankDemand;
@property (weak, nonatomic) IBOutlet UILabel *bankTerm;

@property (weak, nonatomic) IBOutlet UITextField *grossInvestmentTextField;

@property (weak, nonatomic) IBOutlet UITextField *yearsInvestmentTextField;



- (void)constraintForTopBlueView;

//@property(nonatomic,strong) IQKeyboardReturnKeyHandler *keyBoardManager;

@end

@implementation BDBUserProfitCompareViewController

- (instancetype)init{

    if(self = [super init]){
    
        self.title = @"收益对比器";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _grossInvestmentTextField.delegate = self;
    
    _grossInvestmentTextField.tag = 100;
    
    _yearsInvestmentTextField.delegate = self;
    _yearsInvestmentTextField.tag = 101;
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

//计算结果

- (void)calculateResultWithGrossInvestment: (CGFloat)grossInvestment yearsInvestment:(CGFloat)aYearsInvestment{

    _yebLabel.text = [NSString stringWithFormat:@"%.2f", grossInvestment * aYearsInvestment * 3.77 / 100];
    
    _bankDemand.text = [NSString stringWithFormat:@"%.2f",grossInvestment * aYearsInvestment * 0.35 / 100];
    
    _bankTerm.text = [NSString stringWithFormat:@"%.2f",grossInvestment * aYearsInvestment * 4.25 / 100];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
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
    else{
        
        tmpstring = @"";
    }
    
    //投资金额
    CGFloat grossInvestment = 0.0f;
    //投资年限
    CGFloat yearsInvestment = 0.0f;
    if(textField.tag == 100){
        //增加一个数
        if(range.length == 0){
            grossInvestment = [[textField.text stringByAppendingString:tmpstring] doubleValue];
        }
        //删除一个数
        else{
            
            grossInvestment = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue];
        }
        
        if(_yearsInvestmentTextField.text.length > 0){
            
            yearsInvestment = [_yearsInvestmentTextField.text doubleValue];
        
        }
        
    }

    if(textField.tag == 101){
        
        //增加一个数
        if(range.length == 0){
            yearsInvestment = [[textField.text stringByAppendingString:tmpstring] doubleValue];
        }
        //删除一个数
        else{
            
            yearsInvestment = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue];
        }
        
        if(_grossInvestmentTextField.text.length > 0){
            
             grossInvestment = [_grossInvestmentTextField.text doubleValue];
        }
        
    }
    
    [self calculateResultWithGrossInvestment:grossInvestment yearsInvestment:yearsInvestment];
    
    return flag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
