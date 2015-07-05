//
//  BDBAssistantViewController.m
//  User_Version
//
//  Created by Imcore.olddog.cn on 15/6/16.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserAssistantViewController.h"
#import "BDBUserAssitantCellModel.h"
#import "BDBUserPrestigeCalculatorController.h"
#import "BDBUserCPIViewController.h"
#import "BDBUserProfitCalculatorViewController.h"
#import "BDBUserProfitCompareViewController.h"

static NSString *const kCellIdentifier = @"cellIdentifier";

@interface BDBUserAssistantViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) UITableView *tableView;

@property(nonatomic,copy) NSArray *cellDatas;

@end

@implementation BDBUserAssistantViewController

- (instancetype)init{
    
    if(self = [super init]){
        
        self.title = @"网贷助手";
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self loadcCllDatas];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTableView{

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor colorWithRed:240 / 255.0f green:240 / 255.0f blue:240 / 255.0f alpha:1.0f];
    
    tableView.scrollEnabled = NO;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(tableView);
    
    NSString *constraintsVFL = @"|[tableView]|";
    
    NSArray *hConstaints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewDict];
    
    constraintsVFL = @"V:[tableView]|";
    
    NSArray *vConstaints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewDict];
    
    NSLayoutConstraint *vConstraintTop = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:vConstraintTop];
    
    [self.view addConstraints:hConstaints];
    
    [self.view addConstraints:vConstaints];
}

- (void)loadcCllDatas{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBDBProfitCalculator:)];
    
    BDBUserAssitantCellModel *profitModel = [BDBUserAssitantCellModel ModelWithImage:[UIImage imageNamed:@"user_assistant_profit"] title:@"收益计算器" detail:@"收益看不见？谁说的" tapGesture:tapGesture];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBDBCPI:)];
    
    BDBUserAssitantCellModel *cpiModel = [BDBUserAssitantCellModel ModelWithImage:[UIImage imageNamed:@"user_assistant_cpi_icon"] title:@"CPI跟踪器" detail:@"来龙去脉，一眼便知" tapGesture:tapGesture];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBDBCompare:)];
    
    BDBUserAssitantCellModel *compareModel = [BDBUserAssitantCellModel ModelWithImage:[UIImage imageNamed:@"user_assistant_compare_icon"] title:@"收益对比器" detail:@"钱投哪里，一算贬值" tapGesture:tapGesture];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBDBPretige:)];
    
    BDBUserAssitantCellModel *prestigeModel = [BDBUserAssitantCellModel ModelWithImage:[UIImage imageNamed:@"user_assistant_prestige_icon"] title:@"身价计算器" detail:@"身价预估，未雨绸缪" tapGesture:tapGesture];
    
    self.cellDatas = @[profitModel,cpiModel,compareModel,prestigeModel];
}

- (void)showBDBProfitCalculator: (UIGestureRecognizer *)gesture{

    BDBUserProfitCalculatorViewController *profitCalculator = [[BDBUserProfitCalculatorViewController alloc] init];
    
    [self.navigationController pushViewController: profitCalculator animated:YES];
}

- (void)showBDBCPI:(UIGestureRecognizer *)gesture{

    BDBUserCPIViewController *cpi = [[BDBUserCPIViewController alloc] init];
    
    [self.navigationController pushViewController:cpi animated:YES];
    
}

- (void)showBDBCompare:(UIGestureRecognizer *)gesture{

    BDBUserProfitCompareViewController *profitCalculator = [[BDBUserProfitCompareViewController alloc] init];

    
    [self.navigationController pushViewController: profitCalculator animated:YES];
}

- (void)showBDBPretige:(UIGestureRecognizer *)gesture{
    
    BDBUserPrestigeCalculatorController *profitCalculator = [[BDBUserPrestigeCalculatorController alloc] init];
    
    
    [self.navigationController pushViewController: profitCalculator animated:YES];
}

#pragma mark - TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _cellDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    
    BDBUserAssitantCellModel *model = _cellDatas[indexPath.row];
    
    cell.imageView.image = model.image;
    
    cell.textLabel.text = model.titlStr;
    
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.detailTextLabel.text = model.detailStr;
    
    cell.userInteractionEnabled = YES;
    
    [cell addGestureRecognizer:model.tapGesture];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70.0f;
}

@end
