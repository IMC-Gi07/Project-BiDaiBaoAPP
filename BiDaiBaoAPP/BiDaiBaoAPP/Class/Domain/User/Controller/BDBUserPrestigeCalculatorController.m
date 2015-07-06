//
//  BDBProfitCalculatorViewController.m
//  User_version_2
//
//  Created by Imcore.olddog.cn on 15/6/19.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserPrestigeCalculatorController.h"

//#import "IQKeyboardReturnKeyHandler.h"


@interface BDBUserPrestigeCalculatorController ()




@property (weak, nonatomic) IBOutlet UIView *topBlueView;

//@property(nonatomic,strong) IQKeyboardReturnKeyHandler *keyBoardManager;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



@end
