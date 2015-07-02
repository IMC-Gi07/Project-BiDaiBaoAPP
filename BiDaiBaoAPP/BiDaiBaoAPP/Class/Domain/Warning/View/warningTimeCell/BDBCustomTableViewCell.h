//
//  BDBCustomTableViewCell.h
//  warning_time
//
//  Created by mianshuai on 15/6/8.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BDBCustomTableViewCellDelegate;




@interface BDBCustomTableViewCell : UITableViewCell
@property (nonatomic,weak) id<BDBCustomTableViewCellDelegate>delegate;
@property (nonatomic, assign) BOOL onOFF;

@end





@protocol BDBCustomTableViewCellDelegate <NSObject>

- (void)shrinkButtonClickedForChangingHeightOfRow:(UIButton *) sender;

@end