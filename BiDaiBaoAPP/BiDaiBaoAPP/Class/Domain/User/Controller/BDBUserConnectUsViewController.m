//
//  BDBUserConnectUsViewController.m
//  BiDaiBaoAPP
//
//  Created by Carrie's baby on 15/7/9.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserConnectUsViewController.h"

@interface BDBUserConnectUsViewController ()<UIAlertViewDelegate>

@end

@implementation BDBUserConnectUsViewController
- (IBAction)ConnectUS:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"0592-5989961" delegate:self cancelButtonTitle:nil otherButtonTitles:@"拨打",@"取消", nil];
    alertView.backgroundColor = [UIColor blackColor];
    alertView.tintColor = [UIColor blueColor];
    [alertView show];
}
- (IBAction)localCompanny:(UIButton *)sender {
    UILabel * tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.center.y, 320, 60)];
    tishiLabel.numberOfLines = 3;
    tishiLabel.text = @"厦门市思明区观音山商务运营中心4号楼12层1205";
    tishiLabel.textColor = [UIColor whiteColor];
    tishiLabel.backgroundColor = [UIColor grayColor];
    tishiLabel.font = [UIFont fontWithName:@"Arial" size:15];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:tishiLabel];

    
    
    
}
- (IBAction)bankerURL:(UIButton *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
#pragma mark - UIAlertViewDelegate Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://05925989961"]];
            break;
        
        }
            
        case 1:{
            [alertView removeFromSuperview];
            break;
        }
            
        default:
            break;
    }
    
}

@end
