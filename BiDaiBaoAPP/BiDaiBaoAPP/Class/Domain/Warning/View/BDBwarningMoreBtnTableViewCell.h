//
//  BDBwarningMoreBtnTableViewCell.h
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/9.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BDBwarningMoreBtnTableViewCellDelegate <NSObject>

- (void)gainMoreBtnTagAction:(NSInteger)btnTag;
- (void)shinkTheMoreButton:(UIButton *)SMBtn;

@end

@interface BDBwarningMoreBtnTableViewCell : UITableViewCell

@property(nonatomic,weak) id<BDBwarningMoreBtnTableViewCellDelegate>btnDelegate;

@end
