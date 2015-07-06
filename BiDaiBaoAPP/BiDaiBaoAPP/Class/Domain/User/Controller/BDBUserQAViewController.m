//
//  BDBQAViewController.m
//  User_Version
//
//  Created by Imcore.olddog.cn on 15/6/16.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserQAViewController.h"
#import "BDBUserTableViewCell.h"

@interface BDBUserQAViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BDBUserQAViewController

- (instancetype)init{
    
    if(self = [super init]){
        
        self.title = @"我的问答";
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSelectQorAView];
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

- (void)loadSelectQorAView{

    UIView *questionOrAnswerBackgroundView = [[UIView alloc] init];
    
    questionOrAnswerBackgroundView.tag = 100;
    
    [self.view addSubview:questionOrAnswerBackgroundView];
    
    questionOrAnswerBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[questionOrAnswerBackgroundView]|" options:0 metrics:nil views:@{@"questionOrAnswerBackgroundView":questionOrAnswerBackgroundView}];
    
    [self.view addConstraints:hConstraints];
    
    NSLayoutConstraint *topConstrainForQorABackgroundView = [NSLayoutConstraint constraintWithItem:questionOrAnswerBackgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:topConstrainForQorABackgroundView];
    
    NSLayoutConstraint *heightConstraintForQorABackgroundView = [NSLayoutConstraint constraintWithItem:questionOrAnswerBackgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:100.0f];
    
    [questionOrAnswerBackgroundView addConstraint:heightConstraintForQorABackgroundView];
    
    UISegmentedControl *questionOrAnswerSegmented = [[UISegmentedControl alloc] initWithItems:@[@"我的问题",@"我的回答"]];
    
    questionOrAnswerSegmented.selectedSegmentIndex = 0;
    
    questionOrAnswerSegmented.bounds = CGRectMake(0, 0, 200, 30);
    
    questionOrAnswerSegmented.center = CGPointMake(SCREEN_WIDTH / 2, 50);
    
    [questionOrAnswerBackgroundView addSubview:questionOrAnswerSegmented];
    

}

- (void)loadTableView{

    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.estimatedRowHeight = 100.0f;
    
    [tableView registerNib:[UINib nibWithNibName:@"BDBUserTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"userQACellIdentifier"];

    [self.view addSubview:tableView];
    
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:@{@"tableView":tableView}];
    
    [self.view addConstraints:constraints];
    
    UIView *questionOrAnswerBackgroundView = [self.view viewWithTag:100];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[questionOrAnswerBackgroundView][tableView]|" options:0 metrics:nil views:@{@"tableView":tableView,@"questionOrAnswerBackgroundView":questionOrAnswerBackgroundView}];
    
    [self.view addConstraints:constraints];
}

#pragma mark - TableView Delegate And DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BDBUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userQACellIdentifier" forIndexPath:indexPath];
    
    cell.contentQuestionLabel.text = @"slkdjflskdjflksdjlfkjsdlkfjlsdkjflskdjflksdjlfksdjlfkjsdlkfjsldkfjlsdkfjlksdjflksjdlkfjlsdjkslkdjflskdjflksdjlfkjsdlkfjlsdkjflskdjflksdjlfksdjlfkjsdlkfjsldkfjlsdkfjlksdjflksjdlkfjlsdjkfslkdjflskdjflksdjlfkjsdlkfjlsdkjflskdjflksdjlfksdjlfkjsdlkfjsldkfjlsdkfjlksdjflksjdlkfjlsdjkff";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{

    return [tableView fd_heightForCellWithIdentifier:@"userQACellIdentifier" configuration:^(BDBUserTableViewCell *cell) {
            cell.contentQuestionLabel.text = @"slkdjflskdjflksdjlfkjsdlkfjlsdkjflskdjflksdjlfksdjlfkjsdlkfjsldkfjlsdkfjlksdjflksjdlkfjlsdjkslkdjflskdjflksdjlfkjsdlkfjlsdkjflskdjflksdjlfksdjlfkjsdlkfjsldkfjlsdkfjlksdjflksjdlkfjlsdjkfslkdjflskdjflksdjlfkjsdlkfjlsdkjflskdjflksdjlfksdjlfkjsdlkfjsldkfjlsdkfjlksdjflksjdlkfjlsdjkff";
    }];
}
@end
