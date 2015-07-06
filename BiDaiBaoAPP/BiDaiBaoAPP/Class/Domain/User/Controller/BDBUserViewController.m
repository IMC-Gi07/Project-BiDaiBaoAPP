//
//  BDBUserViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/6.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserViewController.h"
#import "BDBUserInfoViewController.h"
#import "BDBUserQAViewController.h"
#import "BDBUserAssistantViewController.h"
#import "BDBUserWarningSettingViewController.h"
#import "BDBUserSettingViewController.h"

@interface BDBUserViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableview
@property (weak, nonatomic) IBOutlet UITableView *userTableview;
/**
 *  收藏的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *StoreNum;
/**
 *  我的消息的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *MsgNum;


- (void)cellOfSettingClickedAction: (UIGestureRecognizer *)gesture;

- (void)cellOfWarningSettingClickedAction: (UIGestureRecognizer *)gesture;

- (void)cellOfAssistantClickedAction: (UIGestureRecognizer *)gesture;

- (void)cellOfQAClickedAction:(UIGestureRecognizer *)gesture;

- (void)cellOfInfoClickedAction:(UIGestureRecognizer *)gesture;


@end

@implementation BDBUserViewController
/**
 *  通过点击我的收藏来转场
 *
 *  @param sender 按钮
 */
- (IBAction)myCollectView:(UITapGestureRecognizer *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"PSW"] == nil) {
        UILabel * dengruLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
        dengruLabel.text = @"您还没有登录呢！";
        dengruLabel.textColor = [UIColor whiteColor];
        dengruLabel.backgroundColor = [UIColor grayColor];
        dengruLabel.font = [UIFont fontWithName:@"Arial" size:15];
        dengruLabel.textAlignment = NSTextAlignmentCenter;
        
        [[UIApplication sharedApplication].keyWindow addSubview:dengruLabel];
        [self performSelector:@selector(removedengruchenggong:) withObject:dengruLabel afterDelay:2];
    }
    else {
        [self performSegueWithIdentifier:@"BDBMyCollectViewController" sender:sender];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *defaultsStoreNum = [defaults objectForKey:@"StoreNum"];
        NSString *defaultsMsgNum = [defaults objectForKey:@"MsgNum"];
        if (defaultsMsgNum != nil && defaultsStoreNum != nil) {
            _StoreNum.text = defaultsStoreNum;
            _MsgNum.text = defaultsMsgNum;
        }

    }
//    CATransition *transition = [CATransition animation];
//    transition.type = @"rippleEffect";
//    transition.duration = 0.5f;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}

-(void)removedengruchenggong:(UILabel *)laber{
    
    [laber removeFromSuperview];
}






/**
 *  通过点击立即登入
 *
 *  @param sender 按钮
 */
- (IBAction)registerViewButton:(UIButton *)sender {
    //登入button的identifier
    [self performSegueWithIdentifier:@"BDBUserRegisterViewController" sender:sender];
    //增加一个专场的动画
//    CATransition *transition = [CATransition animation];
//    transition.type = @"rippleEffect";
//    transition.duration = 0.5f;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    /**
     *  是否隐藏navigationController
     */
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _userTableview.delegate =self;
    _userTableview.dataSource =self;
    /**
     *  //读取保存的数据
     */
        
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

#pragma mark - UITableView Cell Clicked Methods


- (void)cellOfInfoClickedAction:(UIGestureRecognizer *)gesture{
    
    BDBUserInfoViewController *infoViewController = [[BDBUserInfoViewController alloc] init];
    
    [self.navigationController pushViewController:infoViewController animated:YES];
}

- (void)cellOfQAClickedAction:(UIGestureRecognizer *)gesture{
    
    BDBUserQAViewController *qaViewController = [[BDBUserQAViewController alloc] init];
    
    [self.navigationController pushViewController:qaViewController animated:YES];
}

- (void)cellOfAssistantClickedAction:(UIGestureRecognizer *)gesture{
    
    BDBUserAssistantViewController *assistantController = [[BDBUserAssistantViewController alloc] init];
    
    [self.navigationController pushViewController:assistantController animated:YES];
}

- (void)cellOfWarningSettingClickedAction: (UIGestureRecognizer *)gesture{
    
    BDBUserWarningSettingViewController *warningConstroller = [[BDBUserWarningSettingViewController alloc] init];
    
    [self.navigationController pushViewController:warningConstroller animated:YES];
}

- (void)cellOfSettingClickedAction: (UIGestureRecognizer *)gesture{
    
    BDBUserSettingViewController *settingViewController = [[BDBUserSettingViewController alloc] init];
    
    [self.navigationController pushViewController:settingViewController animated:YES];
}

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

/**
 *  个人资料，设置等界面
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"dsfdsfs"];
    
    UITapGestureRecognizer *tapGesture;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImage *image = [UIImage imageNamed:@"person_info_icon"];
            cell.imageView.image = image;
            cell.textLabel.text = @"个人资料";
            
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellOfInfoClickedAction:)];
            
        }
        if (indexPath.row == 1) {
            UIImageView *imageSection1_row2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person_answer_question_icon"]];
            cell.imageView.image = imageSection1_row2.image;
            cell.textLabel.text = @"我的问答";
            
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellOfQAClickedAction:)];
        }
        if (indexPath.row == 2) {
            UIImageView *imageSection1_row3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"assistant_icon"]];
            cell.imageView.image = imageSection1_row3.image;
            cell.textLabel.text = @"网贷助手";
            
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellOfAssistantClickedAction:)];
        }
    }
    if (indexPath.section == 1 ) {
        UIImageView *imageSection2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_warning_icon"]];
        cell.imageView.image = imageSection2.image;
        cell.textLabel.text = @"预警设置";
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellOfWarningSettingClickedAction:)];
    }
    if (indexPath.section == 2) {
        UIImageView *imageSection3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting_icon"]];
        cell.imageView.image = imageSection3.image;
        cell.textLabel.text = @"设置";
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellOfSettingClickedAction:)];
    }
    
    [cell addGestureRecognizer:tapGesture];
    return cell;
}


@end