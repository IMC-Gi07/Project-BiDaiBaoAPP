//
//  UIBarButtonItem.h
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIButton+Extensions.h"

@interface UIBarButtonItem(Creation)

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage clickedHandler:(HandleBlock)clickedHandleBlock;

@end
