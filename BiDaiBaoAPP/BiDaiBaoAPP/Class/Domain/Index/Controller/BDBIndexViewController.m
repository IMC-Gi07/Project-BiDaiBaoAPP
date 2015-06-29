//
//  BDBIndexViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBIndexViewController.h"
#import "BDBIndexTableViewHeader.h"

@interface BDBIndexViewController ()

/**
 *  首页，表视图
 */
@property (weak, nonatomic) IBOutlet UITableView *indexTableView;

/**
 *	表格头部视图
 */
@property(nonatomic,weak) BDBIndexTableViewHeader *indexTableViewHeader;

/**
 *  导航右按钮点击处理器
 *
 *  @param buttonItem 右部按钮
 */
- (void)rightBarButtonClickedAction:(UIBarButtonItem *)buttonItem;



/**
 *	初始化表格视图
 */
- (void)initIndexTableView;

@end

@implementation BDBIndexViewController

#pragma mark - LifeCycle Methods
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
	
	[self initIndexTableView];
}


#pragma mark - Private Methods
- (void)rightBarButtonClickedAction:(UIBarButtonItem *)buttonItem {
	[self performSegueWithIdentifier:@"ToNoticeViewControllerSegue" sender:self];
}

- (void)initIndexTableView {
	//indexTableView tableViewHeader
	BDBIndexTableViewHeader *indexTableViewHeader = [[BDBIndexTableViewHeader alloc] init];
	
	self.indexTableViewHeader = indexTableViewHeader; 

	//根据约束，实际计算Frame(适用于只能设定frame的地方)
	CGSize indexTableViewHeaderFitSize = [_indexTableViewHeader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

	//tableViewHead的高度设定，只能用Frame方式
	_indexTableViewHeader.height = indexTableViewHeaderFitSize.height;

	_indexTableView.tableHeaderView = _indexTableViewHeader;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark - UITableView Delegate Methods


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
