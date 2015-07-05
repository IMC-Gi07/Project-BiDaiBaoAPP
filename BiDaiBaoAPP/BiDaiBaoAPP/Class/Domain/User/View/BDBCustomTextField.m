//
//  BDBCustomTextField.m
//  User_version_2
//
//  Created by olddog on 15/6/16.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBCustomTextField.h"

@interface BDBCustomTextField()

@property(nonatomic,assign) CGRect textRect;


@end

@implementation BDBCustomTextField

- (CGRect)textRectForBounds:(CGRect)bounds{

    CGRect textRect = CGRectMake(70, 0, 100, 100);
    
    self.textRect = textRect;
    return textRect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    
    return _textRect;

}

- (CGRect)editingRectForBounds:(CGRect)bounds{

    return _textRect;
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds{

    CGRect leftViewRect = CGRectMake(25,10, 25, 25);

    return leftViewRect;
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.size.width - 150, 10, 20, 20);
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds{

    return CGRectMake(bounds.size.width - 70,10, 50, 25);
    
}

@end
