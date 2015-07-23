//
//  ZXLLoadDataIndicatePage.h 全局数据加载提示页
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/19.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXLLoadDataIndicatePage : UIView

+ (instancetype)showInView:(UIView *)view;

- (void)hide;

/**
 *  显示加载按钮
 */
- (void)showReloadButtonWithClickedHandler:(void (^)())clickedHandler;

@end
