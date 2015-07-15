//
//  ViewController.h
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@protocol BDBWarningAddViewControllerDlegate <NSObject>

- (void)CompleteWarningAdd;

@end

@interface BDBWarningAddViewController : UIViewController

@property(nonatomic,strong)NSMutableDictionary *filterCondition;
@property (nonatomic,retain) id<BDBWarningAddViewControllerDlegate> TBDelegate;

@end

