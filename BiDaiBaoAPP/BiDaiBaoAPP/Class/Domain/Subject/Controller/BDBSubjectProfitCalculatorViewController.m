//
//  BDBSujectProfitCalculatorViewController.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/4.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBSubjectProfitCalculatorViewController.h"


/**
 *  模拟贷款－》收益计算器
 */
@interface BDBSubjectProfitCalculatorViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topBlueView;

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *interestLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyOfEveryMonthLabel;

@property (weak, nonatomic) IBOutlet UITextField *interestRateOfYearTextField;

@property (weak, nonatomic) IBOutlet UITextField *loanDaysTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *inputMoneyTextField;


@end

@implementation BDBSubjectProfitCalculatorViewController

- (instancetype)init{

    if(self = [super init]){
    
        self.title = @"收益计算器";
        self.hidesBottomBarWhenPushed = YES;
		
		
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	 /**
	  *	放置根视图被导航栏遮住
	  */
	if(SYSTEM_VERSION_GREATER_THAN(@"7.0")){
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}
    
    UITapGestureRecognizer *rootViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backKeyboardMethods:)];
    
    [self.view addGestureRecognizer:rootViewGesture];    
    
    _loanDaysTextFiled.text = _Term;
    
    _interestRateOfYearTextField.text = [NSString stringWithFormat:@"%.2f",[_AnnualEarnings doubleValue] * 100];;
    
    _inputMoneyTextField.delegate = self;
    
    [self constraintForTopView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backKeyboardMethods: (UIGestureRecognizer *)gesture{

    [self.view endEditing:YES];
}
//为topBlue顶部增加约束
- (void)constraintForTopView{
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_topBlueView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:topConstraint];
    
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    CGFloat totalMoney = [[textField.text stringByAppendingString:string] doubleValue];
    
    CGFloat interestEveryDay = [_AnnualEarnings doubleValue] / 365.0f;
   
    NSInteger term = [_Term integerValue];
    
    _totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney * interestEveryDay *term + totalMoney];
    
    _interestLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney * interestEveryDay *term];
    
    _moneyOfEveryMonthLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney * interestEveryDay *30];
    
    
    return YES;
}

@end
