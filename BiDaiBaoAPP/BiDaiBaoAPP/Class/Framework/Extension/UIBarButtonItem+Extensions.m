//
//  UIBarButtonItem.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "UIBarButtonItem+Extensions.h"



@implementation UIBarButtonItem(Creation)

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage clickedHandler:(HandleBlock)clickedHandleBlock {
	//自定义返回按钮
	UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barButton.size = CGSizeMake(30, 30);
	//barButton.backgroundColor = [UIColor redColor];
	
	//设置图片
	[barButton setImage:image forState:UIControlStateNormal];
	[barButton setImage:highlightedImage forState:UIControlStateHighlighted];
	
	//设置处理器
	[barButton handleControlEvent:UIControlEventTouchUpInside withHandleBlock:clickedHandleBlock];
	
	return [[UIBarButtonItem alloc] initWithCustomView:barButton];
}

@end
