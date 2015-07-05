//
//  BDBAskQuestionViewController.m
//  BiDaiBaoAPP
//
//  Created by moon on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBAskQuestionViewController.h"
#import "BDBAskQuestionTypeViewController.h"
#import "BDBGetQuestionTypeListModel.h"

@interface BDBAskQuestionViewController () <BDBAskQuestionTypeViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *titleTextField;

@property (weak, nonatomic) IBOutlet UIButton *questionType;

@property (weak, nonatomic) IBOutlet UITextView *askTextView;

- (IBAction)askButtonClickedAction:(UIButton *)button;

/**
    问题模型
 **/
@property(nonatomic,strong) BDBGetQuestionTypeListModel *getQuestionTypeListModel;


@end

@implementation BDBAskQuestionViewController

- (IBAction)questionType:(UIButton *)sender {
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.title = @"百科问答";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleTextField.layer.cornerRadius = 0;
    self.askTextView.text = @"问题内容";
    [self.askTextView setTextColor:[UIColor lightGrayColor]];
    self.askTextView.delegate = self;
    self.titleTextField.text = @"请输入你要的问题";
    [self.titleTextField setTextColor:[UIColor lightGrayColor]];
    self.titleTextField.delegate = self;
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    
    if ([textView isEqual:_titleTextField]) {
        
        if ([self.titleTextField.text isEqualToString:@"请输入你要的问题"]){
            self.titleTextField.text = @"";
        }
        
    } else if ([textView isEqual:_askTextView]) {
        
        if ([self.askTextView.text isEqualToString:@"问题内容"]){
            self.askTextView.text = @"";
        }
    
    }
 
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.titleTextField.text.length < 1) {
        self.titleTextField.text = @"请输入你要的问题";
    } else if (self.askTextView.text.length < 1) {
        self.askTextView.text = @"问题内容";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"ToBDBAskQuestionTypeViewControllerSegue" isEqualToString:segue.identifier]) {
        BDBAskQuestionTypeViewController *askQuestionTypeViewController = segue.destinationViewController;
        
        askQuestionTypeViewController.delegate = self;
    }
}

#pragma mark - BDBAskQuestionTypeViewController Delegate Methods
- (void)controller:(BDBAskQuestionTypeViewController *)controller selectedQuestion:(BDBGetQuestionTypeListModel *)question{
    self.getQuestionTypeListModel = question;
}

- (void)setGetQuestionTypeListModel:(BDBGetQuestionTypeListModel *)getQuestionTypeListModel{
    if (_getQuestionTypeListModel != getQuestionTypeListModel) {
        _getQuestionTypeListModel = getQuestionTypeListModel;
        [_questionType setTitle:_getQuestionTypeListModel.TypeName forState:UIControlStateNormal];
    }
}

- (IBAction)askButtonClickedAction:(UIButton *)button {
    NSString *title = _titleTextField.text;
    if (!title || [title isEqualToString:@""]) return;
    
    NSString *ask = _askTextView.text;
    if (!ask || [ask isEqualToString:@""]) return;
    
    if (!_getQuestionTypeListModel) return;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *url = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetSubmitQuestion"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *UID = [userDefaults objectForKey:@"UID"];
    if (UID) {
        parameters[@"UID"] = UID;
        parameters[@"AskUser"] = UID;
    }
    
    parameters[@"UserType"] = @"0";
    
    NSString *PSW = [userDefaults objectForKey:@"PSW"];
    if (PSW) {
        parameters[@"PSW"] = PSW;
    }
    
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    parameters[@"TypeID"] = @(_getQuestionTypeListModel.TypeID);
    parameters[@"Title"] = title;
    parameters[@"Ask"] = ask;
    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         ZXLLOG(@"%@",error);
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.titleTextField resignFirstResponder];
    [self.askTextView resignFirstResponder];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.titleTextField resignFirstResponder];
    [self.askTextView resignFirstResponder];
    
    return YES;
}


@end
