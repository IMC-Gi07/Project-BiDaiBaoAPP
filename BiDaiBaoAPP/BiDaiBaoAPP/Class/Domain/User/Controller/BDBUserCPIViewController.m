//
//  BDBCPIViewController.m
//  User_version_2
//
//  Created by Imcore.olddog.cn on 15/6/19.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserCPIViewController.h"

@interface BDBUserCPIViewController ()

@property (weak, nonatomic) IBOutlet UIView *topBlueView;

@end

@implementation BDBUserCPIViewController

- (instancetype)init{

    if(self  = [super init]){
    
        self.title = @"CPI跟踪器";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self constraintForTopBlueView];
    // Do any additional setup after loading the view from its nib.
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
@end
