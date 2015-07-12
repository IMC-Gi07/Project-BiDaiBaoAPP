//
//  BDBwarningAddTableViewCellBtn.h
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/8.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDBwarningAddTableViewCellBtnDelegate <NSObject>

- (void)gainBtnTagAction:(NSInteger)btnTag;

@end

@interface BDBwarningAddTableViewCellBtn : UITableViewCell

@property(nonatomic,weak) id<BDBwarningAddTableViewCellBtnDelegate>btnDelegate;

@end
