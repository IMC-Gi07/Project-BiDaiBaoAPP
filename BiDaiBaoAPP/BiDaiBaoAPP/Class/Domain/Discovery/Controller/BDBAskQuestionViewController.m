//
//  BDBAskQuestionViewController.m
//  BiDaiBaoAPP
//
//  Created by moon on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBAskQuestionViewController.h"

@interface BDBAskQuestionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *questionType;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
