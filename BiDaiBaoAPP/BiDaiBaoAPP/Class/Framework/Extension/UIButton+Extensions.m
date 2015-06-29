//
//  UIButton+Extensions.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "UIButton+Extensions.h"

#import <objc/message.h>

static char overviewKey;

@implementation UIButton(BlockHandler)

@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withHandleBlock:(HandleBlock)handleBlock {
	//利用运行时机制，动态添加成员变量block
	objc_setAssociatedObject(self, &overviewKey, handleBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
	//给按钮设置事件处理器
	[self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
	HandleBlock handleBlock = (HandleBlock)objc_getAssociatedObject(self, &overviewKey);
	if (handleBlock) {
		handleBlock();
	}
}

@end
