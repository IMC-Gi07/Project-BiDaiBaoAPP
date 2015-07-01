//
//  BDBUserViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/6.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserViewController.h"

@interface BDBUserViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *userTableview;


@end

@implementation BDBUserViewController
- (IBAction)myCollectView:(UITapGestureRecognizer *)sender {
    
    [self performSegueWithIdentifier:@"456" sender:sender];
//    CATransition *transition = [CATransition animation];
//    transition.type = @"rippleEffect";
//    transition.duration = 0.5f;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}
- (IBAction)registerViewButton:(UIButton *)sender {
    //登入button的identifier
    [self performSegueWithIdentifier:@"123" sender:sender];
    //增加一个专场的动画
//    CATransition *transition = [CATransition animation];
//    transition.type = @"rippleEffect";
//    transition.duration = 0.5f;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   // _userTableview.rowHeight = 100;
    
    
    
    
    _userTableview.delegate =self;
    _userTableview.dataSource =self;
    //self.userTableview.rowHeight = 100;
    // Do any additional setup after loading the view.
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"dsfdsfs"];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImage *image = [UIImage imageNamed:@"person_info_icon"];
            cell.imageView.image = image;
            cell.textLabel.text = @"个人资料";
            
        }
        if (indexPath.row == 1) {
            UIImageView *imageSection1_row2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person_answer_question_icon"]];
            cell.imageView.image = imageSection1_row2.image;
            cell.textLabel.text = @"我的问答";
        }
        if (indexPath.row == 2) {
            UIImageView *imageSection1_row3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"assistant_icon"]];
            cell.imageView.image = imageSection1_row3.image;
            cell.textLabel.text = @"网贷助手";
        }
    }
    if (indexPath.section == 1 ) {
        UIImageView *imageSection2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"help_centre_icon"]];
        cell.imageView.image = imageSection2.image;
        cell.textLabel.text = @"帮助中心";
    }
    if (indexPath.section == 2) {
        UIImageView *imageSection3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting_icon"]];
        cell.imageView.image = imageSection3.image;
        cell.textLabel.text = @"设置";
    }
    
    
    return cell;
}


@end
