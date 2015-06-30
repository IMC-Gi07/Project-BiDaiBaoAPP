//
//  BDBMainTableViewController.m
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/17.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBIndexViewController.h"
#import "BDBMessageTableViewCell.h"
#import "BDBSortTableViewCell.h"
#import "BDBDetailedMessageTableViewCell.h"
#import "BDBParameterTableViewCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "GlobalConfigurations.h"
#import "BDBIndexResponseModel.h"



@interface BDBIndexViewController ()

@property(nonatomic,strong) BDBIndexResponseModel *indexModel;

@property(nonatomic,strong) UIImageView *herderImageView;

@property (weak, nonatomic) IBOutlet UITableView *IndexTableView;


- (void)rightBarButtonClickedAction:(UIBarButtonItem *)buttonItem;


@end

@implementation BDBIndexViewController

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.title = @"比贷宝";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *rightBarButtonImage = [UIImageWithName(@"index_nav_right") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickedAction:)];

    
    
    
    
    UIImage *headerImage = [UIImage imageNamed:@"index_adv"];
    
    self.herderImageView = [[UIImageView alloc] initWithImage:headerImage];
    self.herderImageView.bounds = CGRectMake(0, 0, 0, 250.0f);
    self.IndexTableView.tableHeaderView = _herderImageView;
    
    
    __weak typeof (self) thisInstance = self;
    self.IndexTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        [thisInstance.IndexTableView.header endRefreshing];
    }];
    
    self.IndexTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        [thisInstance.IndexTableView.footer endRefreshing];
    }];
    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //调用请求对象的解析器
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //主机地址
    NSString *url = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetRealTimeStatistics"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"PlatFormID"] = @"-1";
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BDBIndexResponseModel *indexResponseModel = [BDBIndexResponseModel objectWithKeyValues:responseObject];
        self.indexModel = indexResponseModel;
//        NSLog(@"%@",self.indexModel.AmountRemain);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


- (void)rightBarButtonClickedAction:(UIBarButtonItem *)buttonItem {
    [self performSegueWithIdentifier:@"ToNoticeViewControllerSegue" sender:self];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        BDBMessageTableViewCell *cell = [BDBMessageTableViewCell cell];
        cell.userInteractionEnabled = NO;
        return cell;

    }else if (indexPath.row == 1) {
        BDBParameterTableViewCell *cell = [BDBParameterTableViewCell cell];
        cell.userInteractionEnabled = NO;
//        [cell.hideAndShowButton addTarget:self action:@selector(hideAndShow) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.row == 2) {
        BDBSortTableViewCell *cell = [BDBSortTableViewCell cell];
        NSMutableAttributedString *firstString = [[NSMutableAttributedString alloc] initWithString:@">15%"];
        [firstString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7.0f] range:NSMakeRange(3, 1)];
        [firstString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 3)];
        cell.moreThanFifteenPercentLabel.attributedText = firstString;
        NSMutableAttributedString *secondString = [[NSMutableAttributedString alloc] initWithString:@"12%-15%"];
        [secondString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 2)];
        [secondString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(4, 2)];
        [secondString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7.0f] range:NSMakeRange(2, 2)];
        [secondString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7.0f] range:NSMakeRange(6, 1)];
        cell.moreThanTwelvePercentLessThanFifteenPercentLabel.attributedText = secondString;
        NSMutableAttributedString *thirdString = [[NSMutableAttributedString alloc] initWithString:@"<12%"];
        [thirdString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 3)];
        [thirdString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7.0f] range:NSMakeRange(3, 1)];
        cell.lessThanTwelvePercentLabel.attributedText = thirdString;
        
        UITapGestureRecognizer *redViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRedMessage:)];
        [cell.redView addGestureRecognizer:redViewTapGestureRecognizer];
        
        UITapGestureRecognizer *greenViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeGreenMessage:)];
        [cell.greenView addGestureRecognizer:greenViewTapGestureRecognizer];
        
        UITapGestureRecognizer *blueViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBlueMessage:)];
        [cell.blueView addGestureRecognizer:blueViewTapGestureRecognizer];
        
        return cell;
    }else {
        BDBDetailedMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [BDBDetailedMessageTableViewCell cell];
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row - 2];
            NSMutableAttributedString *percentNumber = [[NSMutableAttributedString alloc] initWithString:@"25%"];
            [percentNumber addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(2, 1)];
            cell.messageLabel.attributedText = percentNumber;
        }
        return cell;

    }
}

- (void)hideAndShow {
    CGRect imageViewBounds = self.herderImageView.bounds;
    
    if (imageViewBounds.size.height == 250.0f) {
        imageViewBounds.size.height = 0;
    }else if (imageViewBounds.size.height == 0) {
        imageViewBounds.size.height = 250;
    }
}



#pragma mark - GestureRecognizer
- (void)changeRedMessage: (UIGestureRecognizer *)gesture {
    
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    
    //NSLog(@"%@",gesture.view.superview.superview);
    
    cell.redView.backgroundColor = [UIColor redColor];
    
    
    cell.blueView.backgroundColor = [UIColor colorWithRed:64/255.0f green:132/255.0f blue:249/255.0f alpha:1];
    
    
    cell.greenView.backgroundColor = [UIColor colorWithRed:87/255.0f green:206/255.0f blue:82/255.0f alpha:1];

    
    
}

- (void)changeGreenMessage: (UIGestureRecognizer *)gesture {
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    cell.greenView.backgroundColor = [UIColor greenColor];
    
    cell.blueView.backgroundColor = [UIColor colorWithRed:64/255.0f green:132/255.0f blue:249/255.0f alpha:1];
    
    cell.redView.backgroundColor = [UIColor colorWithRed:224/255.0f green:62/255.0f blue:74/255.0f alpha:1];
}

- (void)changeBlueMessage: (UIGestureRecognizer *)gesture {
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    cell.blueView.backgroundColor = [UIColor blueColor];
    
    cell.redView.backgroundColor = [UIColor colorWithRed:224/255.0f green:62/255.0f blue:74/255.0f alpha:1];
    
        cell.greenView.backgroundColor = [UIColor colorWithRed:87/255.0f green:206/255.0f blue:82/255.0f alpha:1];
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hight = 0;
    if (indexPath.row == 0) {
        hight = 44;
    }else if (indexPath.row == 1) {
        hight = 100;
    }else if (indexPath.row == 2) {
        hight = 66;
    }else {
        hight = 44;
    }
    return hight;
}

@end
