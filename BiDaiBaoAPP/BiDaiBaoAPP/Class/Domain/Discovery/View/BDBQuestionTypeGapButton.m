//
//  BDBQuestionTypeGapButton.m
//  BiDaiBaoAPP
//
//  Created by moon on 15/7/2.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBQuestionTypeGapButton.h"

@implementation BDBQuestionTypeGapButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *buttonWidthConstranint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50];
        
        NSLayoutConstraint *buttonHeightConstranint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:SCREEN_HEIGHT / 30];
        
        [self addConstraint:buttonHeightConstranint];
        [self addConstraint:buttonWidthConstranint];
    }
    return self;
}

@end
