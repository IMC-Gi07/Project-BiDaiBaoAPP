//
//  BDBUserWarningSettingViewController.m
//  BiDaiBaoAPP
//
//  Created by olddog on 15/7/3.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserWarningSettingViewController.h"

@interface BDBUserWarningSettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UISwitch *notDisturbSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *jingleBellSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shakeSwitch;

@end

@implementation BDBUserWarningSettingViewController

- (instancetype)init{

    if (self = [super init]) {
        self.title = @"预警设置";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self constraintForTopView];
    
    [_notDisturbSwitch addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventValueChanged];
    
    [_jingleBellSwitch addTarget:self action:@selector(selectJingleBell:) forControlEvents:UIControlEventValueChanged];
    
    [_shakeSwitch addTarget:self action:@selector(selectShake:) forControlEvents:UIControlEventValueChanged];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//为topBlue顶部增加约束
- (void)constraintForTopView{
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:topConstraint];
    
}

- (void)selectTime: (UISwitch *)aSwitch{

    if (aSwitch.isOn) {
    
        NSLog(@"勿扰");
    }
    else{
    
        NSLog(@"可扰");
    }
}

- (void)selectJingleBell: (UISwitch *)aSwitch{
    if (aSwitch.isOn) {
        
        NSLog(@"响铃");
    }
    else{
        
        NSLog(@"不响铃");
    }
}

- (void)selectShake: (UISwitch *)aSwitch{
    if (aSwitch.isOn) {
        
        NSLog(@"震动");
    }
    else{
        
        NSLog(@"不震动");
    }
}

@end
