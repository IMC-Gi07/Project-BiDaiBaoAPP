//
//  BDBButtonForTopView.m
//  BiDaiBao(比贷宝)
//
//  Created by Imcore.olddog.cn on 15/6/11.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBButtonForTopView.h"

@interface BDBButtonForTopView()

@end

@implementation BDBButtonForTopView


#pragma mark - Convenient constructor Methods

/**
 *  便利构造器
 *
 *  @param aTitle 按钮标题
 *  @param color  字体颜色
 *  @param aImage 按钮前景图片
 *
 *  @return BDBButtonForTopView
 */
+ (BDBButtonForTopView *)buttonWithTitle: (NSString *)aTitle titleColor:(UIColor *)color image: (UIImage *)aImage;{

    BDBButtonForTopView *button = [BDBButtonForTopView buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:aTitle forState:UIControlStateNormal];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    
    [button setImage:aImage forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    button.isClicked = NO;
    
    
    
    //button.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    return button;
    
}



#pragma mark - Setters And Getters Methods

- (void)setIsClicked:(BOOL)isClicked{

    _isClicked = isClicked;
    
    if(![[self titleForState:UIControlStateNormal] isEqualToString:@"筛选"]){
    
        if(_isClicked){
            
            [self setImage:[UIImage imageNamed:@"subject_btnTopview_icon_down"] forState:UIControlStateNormal];
        }
        else{
        
            [self setImage:[UIImage imageNamed:@"subject_btnTopview_icon_up"] forState:UIControlStateNormal];
        }
    }
}


#pragma mark - TitleRect ImageRect Methods

/**
 * 设置按钮内文本的frame
 */

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    [super titleRectForContentRect:contentRect];
    
    CGRect titleRect;
    
    if([[self titleForState:UIControlStateNormal] isEqualToString:@"收益率"]){
        
        titleRect = CGRectMake(contentRect.size.width / 2 - 30, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
    }
    else if ([[self titleForState:UIControlStateNormal] isEqualToString:@"进度"]){
        
        titleRect = CGRectMake(contentRect.size.width / 2 - 20, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
    }
    else if ([[self titleForState:UIControlStateNormal] isEqualToString:@"期限"]){
        
        titleRect = CGRectMake(contentRect.size.width / 2 - 20, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
    }
    else if ([[self titleForState:UIControlStateNormal] isEqualToString:@"筛选"]){
        
        titleRect = CGRectMake(contentRect.size.width / 2 - 20, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
    }
    
    return titleRect;
    
}

/**
 * 设置按钮内前景图片的frame
 */


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    [super imageRectForContentRect:contentRect];
    
    CGRect imageRect;
    
    if(![[self titleForState:UIControlStateNormal] isEqualToString:@"筛选"]){
        
        imageRect = CGRectMake(contentRect.size.width / 2 + 20, contentRect.size.height / 2 - 3, 10, 5);
    }
    else{
        
        imageRect = CGRectMake(contentRect.size.width / 2 + 14, contentRect.size.height / 2 - 5, 12, 12);
    }
    
    return imageRect;
    
}

@end
