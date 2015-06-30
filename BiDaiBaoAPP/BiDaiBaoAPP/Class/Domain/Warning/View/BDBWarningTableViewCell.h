//
//  BDBWarningTableViewCell.h
//  BDB_Draft
//
//  Created by Tomoxox on 15/6/8.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BDBWarningTableViewCellDelegate;

@interface BDBWarningTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *colorBlock;
@property (weak, nonatomic) id<BDBWarningTableViewCellDelegate>delegate;

@end
@protocol BDBWarningTableViewCellDelegate <NSObject>

- (void)deleteButtonClickedAction:(UIButton *)button;

@end