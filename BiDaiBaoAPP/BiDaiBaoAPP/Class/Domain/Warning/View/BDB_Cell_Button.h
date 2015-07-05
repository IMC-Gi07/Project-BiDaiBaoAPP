//
//  BDB_Cell_Button.h
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BDB_Cell_ButtonDelegate;

@interface BDB_Cell_Button : UIButton

@property (weak, nonatomic) id<BDB_Cell_ButtonDelegate>delegate;

@end

@protocol BDB_Cell_ButtonDelegate <NSObject>

- (void)PlatFormIDButtonClickedAction:(NSInteger)buttonValue;

@end