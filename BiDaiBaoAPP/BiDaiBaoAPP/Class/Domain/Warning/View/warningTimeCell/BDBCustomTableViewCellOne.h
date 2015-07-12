//
//  BDBCustomTableViewCellOne.h
//  warning_time
//
//  Created by mianshuai on 15/6/8.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDBCustomTableViewCellOneDelegate <NSObject>

- (void)transferTitleText:(NSString *)titleText;

@end


@interface BDBCustomTableViewCellOne : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak,nonatomic) id<BDBCustomTableViewCellOneDelegate>delegate;

@end


