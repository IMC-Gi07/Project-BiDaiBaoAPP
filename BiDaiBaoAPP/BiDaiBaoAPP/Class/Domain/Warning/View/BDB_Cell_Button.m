//
//  BDB_Cell_Button.m
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import "BDB_Cell_Button.h"

@implementation BDB_Cell_Button


//设置button的图片、增加高度和宽度约束
- (instancetype)init {
    if (self = [super init]) {
        
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_icon_user_highlighted"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"waring_blackgroundButton"] forState:UIControlStateSelected];

        
        
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *heightConstranint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30];
        
        [_delegate PlatFormIDButtonClickedAction:self.tag];
        
        self.selected = YES;
        [self addConstraint:heightConstranint];
//        [self addConstraint:widthConstranint];
    }
    return self;
}






@end
