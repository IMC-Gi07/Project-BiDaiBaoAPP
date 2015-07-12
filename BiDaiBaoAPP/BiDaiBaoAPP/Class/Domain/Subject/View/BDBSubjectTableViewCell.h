//
//  BDBTableViewCell.h
//  Subject_verson1
//
//  Created by Imcore.olddog.cn on 15/6/8.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBSujectModel.h"

typedef void (^UpdateCollectButtonSelected)(BOOL);
typedef void (^UpdateCellisRefresh)(BOOL);
typedef void (^UpdateCellModel)(BDBSujectModel *);
typedef void (^PushWebView)();

@interface BDBSubjectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UIButton *loanButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property(nonatomic,assign) BOOL isRrefreshing;

@property(nonatomic,strong) BDBSujectModel *model;

@property(nonatomic,copy)UpdateCollectButtonSelected updateCollectButtonSelected;

@property(nonatomic,copy)UpdateCellisRefresh updateCellisRefresh;

@property(nonatomic,copy) UpdateCellModel updateCellModel;

@property(nonatomic,copy) PushWebView pushWebView;

+ (BDBSubjectTableViewCell *)cell;

- (void)depoySubViewWithModel: (BDBSujectModel *) model controller:(UIViewController *)viewController indexPath: (NSIndexPath *)aIndexPath;

@end
