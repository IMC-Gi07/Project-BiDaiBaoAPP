//
//  BDBMyMeassageViewController.m
//  BiDaiBaoAPP
//
//  Created by Carrie's baby on 15/7/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBMyMeassageViewController.h"
#import "BDBMyMassageCellCoustom.h"

@interface BDBMyMeassageViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myMeassageTableView;

@end

@implementation BDBMyMeassageViewController

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _myMeassageTableView.delegate = self;
    _myMeassageTableView.dataSource = self;
    _myMeassageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myMeassageTableView.rowHeight = 80;
    //隐藏tableview的头
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [_myMeassageTableView registerNib:[UINib nibWithNibName:@"BDBMyMassageCellCoustom" bundle:nil] forCellReuseIdentifier:@"messageIdentify"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BDBMyMassageCellCoustom *cell = [[NSBundle mainBundle]loadNibNamed:@"BDBMyMassageCellCoustom" owner:nil options:nil][0];
    
    
    return cell;
}


@end
