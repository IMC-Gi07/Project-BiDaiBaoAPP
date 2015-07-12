//
//  BDBProfitCalculatorViewController.m
//  User_version_2
//
//  Created by Imcore.olddog.cn on 15/6/19.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserPrestigeCalculatorController.h"

//#import "IQKeyboardReturnKeyHandler.h"


@interface BDBUserPrestigeCalculatorController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBlueView;
@property (weak, nonatomic) IBOutlet UIView *percentageView;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *prestigeLabel;
@property (weak, nonatomic) IBOutlet UILabel *prestigeIncreaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *outnumberLabel;

@property (weak, nonatomic) IBOutlet UITextField *depositTextField;
@property (weak, nonatomic) IBOutlet UITextField *salaryTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *yearsTextField;

//@property(nonatomic,strong) IQKeyboardReturnKeyHandler *keyBoardManager;

- (void)loadPickerView;
- (void)showPickerView;
- (void)percentageViewClickedAction;

@end

@implementation BDBUserPrestigeCalculatorController

- (instancetype)init{

    if(self = [super init]){
    
        self.title = @"身价计算器";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self constraintForTopBlueView];
    
    [self loadPickerView];
    
    [self percentageViewClickedAction];
    
    _depositTextField.delegate = self;
    _depositTextField.tag = 100;
    
    _salaryTextFiled.delegate = self;
    _salaryTextFiled.tag = 101;
    
    _yearsTextField.delegate = self;
    _yearsTextField.tag = 102;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

//为topBlue增加约束
- (void)constraintForTopBlueView{

    NSArray *hConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topBlueView]|" options:0 metrics:nil views:@{@"topBlueView":_topBlueView}];
    
    [self.view addConstraints:hConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_topBlueView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:topConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_topBlueView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200.0f];
    
    [_topBlueView addConstraint:heightConstraint];
}

//为percentageView添加点击事件

- (void)percentageViewClickedAction{

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickerView)];
    
    [_percentageView addGestureRecognizer:gesture];
}

//创建百分比选择器

- (void)loadPickerView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.tag = 500;
    
    view.backgroundColor = [UIColor darkGrayColor];
    
    view.alpha = 0.8;

    UIPickerView *pickView = [[UIPickerView alloc] init];
    
    pickView.center = self.view.center;
    
    pickView.tag = 501;
    
    pickView.delegate = self;
    
    pickView.dataSource = self;
    
    pickView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:view];
    [self.view addSubview:pickView];
    
    view.hidden = YES;
    pickView.hidden = YES;
}

- (void)showPickerView{

    [self.view viewWithTag:500].hidden = NO;
    [self.view viewWithTag:501].hidden = NO;
}

#pragma mark - PickerView DataSource And Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return 10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 60.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    NSString *string;
    
    switch (row) {
        case 0:
            string = @"10%";
            break;
        case 1:
            string = @"20%";
            break;
        case 2:
            string = @"30%";
            break;
        case 3:
            string = @"40%";
            break;
        case 4:
            string = @"50%";
            break;
        case 5:
            string = @"60%";
            break;
        case 6:
            string = @"70%";
            break;
        case 7:
            string = @"80%";
            break;
        case 8:
            string = @"90%";
            break;
        case 9:
            string = @"100%";
            break;
        default:
            break;
    }
    return string;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    NSString *string;
    
    switch (row) {
        case 0:
            string = @"10%";
            break;
        case 1:
            string = @"20%";
            break;
        case 2:
            string = @"30%";
            break;
        case 3:
            string = @"40%";
            break;
        case 4:
            string = @"50%";
            break;
        case 5:
            string = @"60%";
            break;
        case 6:
            string = @"70%";
            break;
        case 7:
            string = @"80%";
            break;
        case 8:
            string = @"90%";
            break;
        case 9:
            string = @"100%";
            break;
        default:
            break;
    }
    _percentageLabel.text = string;
    [self.view viewWithTag:500].hidden = YES;
    [self.view viewWithTag:501].hidden = YES;
}

#pragma mark TextFiled Delegate Methods

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

    CGFloat deposit = 0.0f;
    CGFloat salary = 0.0f;
    CGFloat year = 0.0f;
    
    if(textField.tag == 100){
        //增加一个数
        if(range.length == 0){
            deposit = [[textField.text stringByAppendingString:tmpstring] doubleValue];
        }
        //删除一个数
        else{
            
            deposit = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue];
        }
        
        if(_salaryTextFiled.text.length > 0 && _yearsTextField.text.length > 0){
            
            salary = [_salaryTextFiled.text doubleValue];
            
            year = [_yearsTextField.text doubleValue];
        }
    }
    
    if(textField.tag == 101){
        //增加一个数
        if(range.length == 0){
            salary = [[textField.text stringByAppendingString:tmpstring] doubleValue];
        }
        //删除一个数
        else{
            
            salary = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue];
        }
        
        if(_depositTextField.text.length > 0 && _yearsTextField.text.length > 0){
            
            deposit = [_depositTextField.text doubleValue];
            
            year = [_yearsTextField.text doubleValue];
        }
    }
    if(textField.tag == 102){
        //增加一个数
        if(range.length == 0){
            year = [[textField.text stringByAppendingString:tmpstring] doubleValue];
        }
        //删除一个数
        else{
            
            year = [[textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)] doubleValue];
        }
        
        if(_depositTextField.text.length > 0 && _salaryTextFiled.text.length > 0){
            
            deposit = [_depositTextField.text doubleValue];
            
            salary = [_salaryTextFiled.text doubleValue];
        }
    }
    
    NSLog(@"%g,%g,%g",deposit,salary,year);
    
    return flag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
