//
//  BDBButtonClass.m
//  BDB_FindQuestionGrabble
//
//  Created by moon on 15/6/11.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import "BDBFindQuestionButton.h"

@implementation BDBFindQuestionButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"Find_blackgroundButton"] forState:UIControlStateNormal];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f
                                                                              constant:80/3];
        [self addConstraint:heightConstraint];
        
        
    }
    return self;
}

@end
