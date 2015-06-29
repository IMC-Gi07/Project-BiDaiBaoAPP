//
//  UIButton+Extensions.h
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HandleBlock)();

@interface UIButton(BlockHandler)

@property(readonly) NSMutableDictionary *event;

- (void)handleControlEvent:(UIControlEvents)controlEvent withHandleBlock:(HandleBlock)action;

@end
