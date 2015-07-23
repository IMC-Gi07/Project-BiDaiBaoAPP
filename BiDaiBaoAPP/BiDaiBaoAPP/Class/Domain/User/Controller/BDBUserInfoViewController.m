//
//  BDBInfoViewController.m
//  User_Version
//
//  Created by Imcore.olddog.cn on 15/6/16.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserInfoViewController.h"

#import "BDBCustomTextField.h"
#import <CommonCrypto/CommonDigest.h>
#import "BDBUserChangeViewController.h"



@interface BDBUserInfoViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>




@property(nonatomic,weak) BDBCustomTextField *nameTextField;
@property(nonatomic,weak) BDBCustomTextField *emialTextField;
//@property(nonatomic,weak) BDBCustomTextField *passwordTextField;

@property(nonatomic,weak) UIImageView *currentHeadImageView;
@property(nonatomic,strong) UIImage *headerImage;
@property(nonatomic,weak) UILabel *userNameLabel;

- (void)changeHeadImage: (UIGestureRecognizer *)gesture;

@end

@implementation BDBUserInfoViewController

#pragma mark - Instancetype Methods

- (instancetype)init{

    if(self = [super init]){
    
        self.title = @"个人资料";
        
        self.hidesBottomBarWhenPushed = YES;
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        NSString *archivePath = [cachesPath stringByAppendingPathComponent:@"HeartPhoto.atchive"];
        
        UIImage *heartImage = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        
        if (heartImage != nil) {
            self.headerImage = heartImage;
        }
        else{
            self.headerImage = [UIImage imageNamed:@"default_head_img"];
        }
        
    }
    
    return self;
}

#pragma mark - Life CirCle Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyboard:)];
    
    [self.view addGestureRecognizer:tapGesture];
    [self subViewOfTopArea];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultsNiName = [defaults objectForKey:@"NiName"];
    NSString *defaultsUID = [defaults objectForKey:@"UID"];
    NSString *defaultsEmial = [defaults objectForKey:@"EMail"];
    _userNameLabel.text = defaultsNiName;
    _nameTextField.text = defaultsNiName;
    if (defaultsNiName == nil) {
        _userNameLabel.text = defaultsUID;
        _nameTextField.text = defaultsUID;
    }
    if (defaultsEmial != nil) {
        _emialTextField.text = defaultsEmial;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnKeyboard: (UIGestureRecognizer *)gesture{

    [self.view endEditing:YES];
}

- (void)subViewOfTopArea{

    UIImage *backgroundImage = [UIImage imageNamed:@"user_home_background_img"];
    
    UIImageView *userBackgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [self.view addSubview:userBackgroundImageView];
    
    userBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstrainsForUserBackgroundView = [NSLayoutConstraint constraintsWithVisualFormat:@"|[userBackgroundImageView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"userBackgroundImageView":userBackgroundImageView}];
    
    NSLayoutConstraint *topConstraintForUserBackgroundView = [NSLayoutConstraint constraintWithItem:userBackgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *heightConstraintForUserBackgroundView = [NSLayoutConstraint constraintWithItem:userBackgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:userBackgroundImageView attribute:NSLayoutAttributeWidth multiplier:0.6f constant:0.0f];
    [self.view addConstraints:hConstrainsForUserBackgroundView];
    
    [self.view addConstraint:topConstraintForUserBackgroundView];
    
    [userBackgroundImageView addConstraint:heightConstraintForUserBackgroundView];
    
    UIImage *headBackgroundImage = [UIImage imageNamed:@"user_head_circle_img"];
    
    UIImageView *headBackgroundImageView = [[UIImageView alloc] initWithImage:headBackgroundImage];
    
    [self.view addSubview:headBackgroundImageView];
    
    headBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerYConstraintForheadBackgroundImageView = [NSLayoutConstraint constraintWithItem:headBackgroundImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:userBackgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *centerXConstraintForheadBackgroundImageView = [NSLayoutConstraint constraintWithItem:headBackgroundImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:userBackgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *widthConstraintForheadBackgroundImageView = [NSLayoutConstraint constraintWithItem:headBackgroundImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:headBackgroundImage.size.width];
    
    NSLayoutConstraint *heightConstraintForheadBackgroundImageView = [NSLayoutConstraint constraintWithItem:headBackgroundImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:headBackgroundImage.size.height];
    
    [self.view addConstraint:centerXConstraintForheadBackgroundImageView];
    [self.view addConstraint:centerYConstraintForheadBackgroundImageView];
    [headBackgroundImageView addConstraint:heightConstraintForheadBackgroundImageView];
    [headBackgroundImageView addConstraint:widthConstraintForheadBackgroundImageView];
    
    
    //用户头像
   // UIImage *defaultHeadImage = [UIImage imageNamed:@"user_default_head_img"];
    
    UIImageView *defaultHeadImageView = [[UIImageView alloc] initWithImage:_headerImage];
    
    defaultHeadImageView.layer.cornerRadius = 45.0f;
    
    defaultHeadImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage:)];
    
    defaultHeadImageView.userInteractionEnabled = YES;
    
    [defaultHeadImageView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:defaultHeadImageView];
    
    self.currentHeadImageView = defaultHeadImageView;
    
    defaultHeadImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint *centerYConstraintForDefaultHeadImageView = [NSLayoutConstraint constraintWithItem:defaultHeadImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headBackgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *centerXConstraintForDefaultHeadImageView = [NSLayoutConstraint constraintWithItem:defaultHeadImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headBackgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *heightConstraintForDefaultHeadImageView = [NSLayoutConstraint constraintWithItem:defaultHeadImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:90.0f];
    
    NSLayoutConstraint *widthConstraintForDefaultHeadImageView = [NSLayoutConstraint constraintWithItem:defaultHeadImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:90.0f];
    
    [self.view addConstraint:centerXConstraintForDefaultHeadImageView];
    [self.view addConstraint:centerYConstraintForDefaultHeadImageView];
    [defaultHeadImageView addConstraint:heightConstraintForDefaultHeadImageView];
    [defaultHeadImageView addConstraint:widthConstraintForDefaultHeadImageView];
    
    
    //*此为动态生成，后期修改
    UILabel *userNameLabel = [[UILabel alloc] init];
    
    //userNameLabel.text = @"用户名";
    
    userNameLabel.textColor = [UIColor whiteColor];
    
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:userNameLabel];
    
    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerXConstraintForUserNameLabel = [NSLayoutConstraint constraintWithItem:userNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headBackgroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *BottomConstraintForUserNameLabel = [NSLayoutConstraint constraintWithItem:userNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headBackgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:10.0f];
    
    
    [self.view addConstraint:centerXConstraintForUserNameLabel];
    [self.view addConstraint:BottomConstraintForUserNameLabel];
    _userNameLabel = userNameLabel;
    
    
    //修改昵称
    
    BDBCustomTextField *nameTextField = [[BDBCustomTextField alloc] init];
    
    nameTextField.delegate = self;
    
    UIButton *nameTextFieldRightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    nameTextFieldRightButton.tag = 100;
    
    [nameTextFieldRightButton addTarget:self action:@selector(modifyUserInformations:) forControlEvents:UIControlEventTouchUpInside];
    
    [nameTextFieldRightButton setBackgroundImage:[UIImage imageNamed:@"user_info_btn_bg"] forState:UIControlStateNormal];
    
    [nameTextFieldRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    nameTextFieldRightButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    
    [nameTextFieldRightButton setTitle:@"立即修改" forState:UIControlStateNormal];
    
    UIImageView *nameTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_info_name_icon"]];
    
    nameTextField.leftView = nameTextFieldLeftView;
    
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    nameTextField.rightView = nameTextFieldRightButton;
    
    nameTextField.rightViewMode = UITextFieldViewModeAlways;
    
    nameTextField.placeholder = @"昵称";
    
    nameTextField.borderStyle = UITextBorderStyleNone;
    
    [self.view addSubview:nameTextField];
    
    self.nameTextField = nameTextField;
    
    nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hContraintForNameTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"|[nameTextField]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"nameTextField":nameTextField}];
    
    NSArray *vContraintForNameTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[userBackgroundImageView][nameTextField(44)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"nameTextField":nameTextField,@"userBackgroundImageView":userBackgroundImageView}];
    
    [self.view addConstraints:hContraintForNameTextField];
    [self.view addConstraints:vContraintForNameTextField];
    
    UIView *firstSeparatorView = [[UIView alloc] init];
    
    firstSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:firstSeparatorView];
    
    firstSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstraintsForFirstSeparatorView = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[firstSeparatorView]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"firstSeparatorView":firstSeparatorView}];
    NSArray *vConstraintsForFirstSeparatorView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameTextField][firstSeparatorView(1)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"nameTextField":nameTextField,@"firstSeparatorView":firstSeparatorView}];
    
    [self.view addConstraints:hConstraintsForFirstSeparatorView];
    [self.view addConstraints:vConstraintsForFirstSeparatorView];
    
    
    //修改邮箱
    BDBCustomTextField *emailTextField = [[BDBCustomTextField alloc] init];
    
    emailTextField.delegate = self;
    
    UIButton *emailTextFieldButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    emailTextFieldButton.tag = 101;
    
    [emailTextFieldButton addTarget:self action:@selector(modifyUserInformations:) forControlEvents:UIControlEventTouchUpInside];
    
    [emailTextFieldButton setBackgroundImage:[UIImage imageNamed:@"user_info_btn_bg"] forState:UIControlStateNormal];
    
    [emailTextFieldButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    emailTextFieldButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    
    [emailTextFieldButton setTitle:@"立即修改" forState:UIControlStateNormal];
    
    UIImageView *emailTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_info_email_icon"]];
    
    emailTextField.leftView = emailTextFieldLeftView;
    
    emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    emailTextField.rightView = emailTextFieldButton;
    
    emailTextField.rightViewMode = UITextFieldViewModeAlways;
    
    emailTextField.placeholder = @"邮箱";
    
    emailTextField.borderStyle = UITextBorderStyleNone;
    
    [self.view addSubview:emailTextField];
    
    self.emialTextField = emailTextField;
    
    emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hContraintsForEmailTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"|[emailTextField]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"emailTextField":emailTextField}];
    
    NSArray *vContraintsForEmailTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstSeparatorView][emailTextField(44)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"emailTextField":emailTextField,@"firstSeparatorView":firstSeparatorView}];
    
    [self.view addConstraints:hContraintsForEmailTextField];
    [self.view addConstraints:vContraintsForEmailTextField];
    
    UIView *secondSeparatorView = [[UIView alloc] init];
    
    secondSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:secondSeparatorView];
    
    secondSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstraintsForSecondSeparatorView = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[secondSeparatorView]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"secondSeparatorView":secondSeparatorView}];
    NSArray *vConstraintsForSecondSeparatorView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[emailTextField][secondSeparatorView(1)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"emailTextField":emailTextField,@"secondSeparatorView":secondSeparatorView}];
    
    [self.view addConstraints:hConstraintsForSecondSeparatorView];
    [self.view addConstraints:vConstraintsForSecondSeparatorView];
    
    //修改密码
    
    UIView *passwordView = [[UIView alloc] init];
    
    //passwordView.delegate = self;
    //passwordTextField.enabled = NO;
    
    UIButton *passwordTextFieldButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    passwordTextFieldButton.tag = 102;
    
    [passwordTextFieldButton addTarget:self action:@selector(modifyUserInformations:) forControlEvents:UIControlEventTouchUpInside];
    
    [passwordTextFieldButton setBackgroundImage:[UIImage imageNamed:@"user_info_btn_bg"] forState:UIControlStateNormal];
    
    [passwordTextFieldButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    passwordTextFieldButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    
    [passwordTextFieldButton setTitle:@"立即修改" forState:UIControlStateNormal];
    
//    UIImageView *passwordTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_info_password_icon"]];
    
   // passwordView.leftView = passwordTextFieldLeftView;
    
    //passwordView.leftViewMode = UITextFieldViewModeAlways;
    
    //passwordView.rightView = passwordTextFieldButton;
    
   // passwordView.rightViewMode = UITextFieldViewModeAlways;
    
   // passwordView.placeholder = @"密码修改";
    
   // passwordView.borderStyle = UITextBorderStyleNone;
    
    [self.view addSubview:passwordView];
    
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 20, 20)];
    leftView.image = [UIImage imageNamed:@"user_info_password_icon"];
    
    [passwordView addSubview:leftView];
    
    
    UILabel *passWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
    passWordLabel.text = @"修改密码";
    passWordLabel.backgroundColor = [UIColor whiteColor];
    passWordLabel.textColor = UIColorWithRGB(187, 186, 194);
    passWordLabel.font = [UIFont systemFontOfSize:15];
    
    [passwordView addSubview:passWordLabel];
    
    
    UIImageView *jiantouView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 10, 10, 20)];
    jiantouView.image = [UIImage imageNamed:@"jiantouicon"];
    
    [passwordView addSubview:jiantouView];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChangePassWord)];
    
    [passwordView addGestureRecognizer:tapGestureRecognizer];
    
    passwordView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hContraintsForPasswordTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"|[passwordTextField]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"passwordTextField":passwordView}];
    
    NSArray *vContraintsForPasswordTextField = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[secondSeparatorView][passwordTextField(44)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"passwordTextField":passwordView,@"secondSeparatorView":secondSeparatorView}];
    
    [self.view addConstraints:hContraintsForPasswordTextField];
    [self.view addConstraints:vContraintsForPasswordTextField];
    
    UIView *thirdSeparatorView = [[UIView alloc] init];
    
    thirdSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:thirdSeparatorView];
    
    thirdSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstraintsForThirdSeparatorView = [NSLayoutConstraint constraintsWithVisualFormat:@"|[thirdSeparatorView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"thirdSeparatorView":thirdSeparatorView}];
    NSArray *vConstraintsForThirdSeparatorView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[passwordTextField][thirdSeparatorView(1)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"passwordTextField":passwordView,@"thirdSeparatorView":thirdSeparatorView}];
    
    [self.view addConstraints:hConstraintsForThirdSeparatorView];
    [self.view addConstraints:vConstraintsForThirdSeparatorView];

    

}


-(void)ChangePassWord{
    
    BDBUserChangeViewController *changeViewController = [[BDBUserChangeViewController alloc]init];
    
    [self.navigationController pushViewController:changeViewController animated:YES];



}


- (void)changeHeadImage: (UIGestureRecognizer *)gesture{

    [self.view endEditing:YES];
    
    UIActionSheet *alertSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    
    [alertSheet showInView:self.view];
    
}
//立即修改按钮事件
- (void)modifyUserInformations: (UIButton *)button{
    
    if(button.tag == 102){
    
        BDBUserChangeViewController *changeViewController = [[BDBUserChangeViewController alloc]init];
        
        [self.navigationController pushViewController:changeViewController animated:YES];
    }
    else{
    
        [self loadSetUserInf:button.tag];
    }
  
}

- (void)loadSetUserInf: (NSUInteger)buttonTag{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultsUID = [defaults objectForKey:@"UID"];
    NSString *defaultsPSW = [defaults objectForKey:@"PSW"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetUserInf"];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    
    parameterDict[@"UID"] = defaultsUID;
    
    parameterDict[@"UserType"] = @"0";
    
    parameterDict[@"PSW"] = defaultsPSW;
    
    parameterDict[@"Machine_id"] = @"0";
    
    parameterDict[@"Device"] = @"0";
    
    if (buttonTag == 100) {
        if (_nameTextField.text.length != 0) {
            parameterDict[@"NiName"] = _nameTextField.text;
            [defaults setObject:_nameTextField.text forKey:@"NiName"];
            _userNameLabel.text = _nameTextField.text;
        }
    }
    if(buttonTag == 101){
        if (_emialTextField.text.length != 0) {
            parameterDict[@"EM ail"] = _emialTextField.text;
            
        }

    }
    
   [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if ([responseObject[@"Result"] isEqualToString:@"0"]) {
           UILabel * tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
           
           tishiLabel.text = @"修改成功";
           tishiLabel.textColor = [UIColor whiteColor];
           tishiLabel.backgroundColor = [UIColor grayColor];
           tishiLabel.font = [UIFont fontWithName:@"Arial" size:15];
           tishiLabel.textAlignment = NSTextAlignmentCenter;
           
           [self.view addSubview:tishiLabel];
           
           [self performSelector:@selector(removetishi:) withObject:tishiLabel afterDelay:2];
           
           //[_passwordTextField setText:@""];
           [_emialTextField setText:@""];
           [_nameTextField setText:@""];
           
       }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"error%@",error);
   }];
}

-(void)removetishi:(UILabel *)laber{
    
    [laber removeFromSuperview];
    
}

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
    
    NSLog(@"Encryption Result = %@",mdfiveString);
    return mdfiveString;
}


#pragma mark - UIActionSheet Delegate Methods;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self loadHeaderImageFromCamera];
            break;
        case 1:
            [self loadHeaderImageFormAlum];
            break;
            
        default:
            break;
    }

}

- (void)loadHeaderImageFromCamera{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
        
        pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        pickController.delegate = self;
        
        [self presentViewController:pickController animated:YES completion:nil];
    
    }
    else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alertView show];
    
    }

}

- (void)loadHeaderImageFormAlum{
    
    UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
    
    pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    pickController.delegate = self;
    
    [self presentViewController:pickController animated:YES completion:nil];

}

#pragma mark - UIImagePickerConstroller Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *headerImage = info[UIImagePickerControllerOriginalImage];
    
    self.currentHeadImageView.image = headerImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *archiveFilePath = [cachesPath stringByAppendingPathComponent:@"HeartPhoto.atchive"];
    
    [self requestPushHeardPhoton];
    
    [NSKeyedArchiver archiveRootObject:headerImage toFile:archiveFilePath];
    
    

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - UITextFiled Delegate Methods;

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

-(void)requestPushHeardPhoton{
    
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *archivePath = [cachesPath stringByAppendingPathComponent:@"HeartPhoto.atchive"];
    
    UIImage *heartImage = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    NSData *data = UIImagePNGRepresentation(heartImage);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultsUID = [defaults objectForKey:@"UID"];
    NSString * photo64 = [self base64EncodingWithData:data];
    NSLog(@"%@",photo64);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetUserInf"];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    
    parameterDict[@"Photo"] = photo64;
    parameterDict[@"UID"] = defaultsUID;
    parameterDict[@"UserType"] = @"0";
    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"Msg"]);
        NSLog(@"%@",responseObject[@"Result"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"sfsfsd");
         }];


}

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString *)base64EncodingWithData:(NSData *)aData
{
    if ([aData length] == 0)
        return @"";
    
    char *characters = malloc((([aData length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [aData length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [aData length])
            buffer[bufferLength++] = ((char *)[aData bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}


@end
