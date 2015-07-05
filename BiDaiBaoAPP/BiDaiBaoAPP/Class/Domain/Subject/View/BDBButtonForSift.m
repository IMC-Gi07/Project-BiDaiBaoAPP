//
//  BDBButtonForSift.m
//  Subject_verson1
//
//  Created by olddog on 15/6/10.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBButtonForSift.h"

@interface BDBButtonForSift ()

@end

@implementation BDBButtonForSift

+ (BDBButtonForSift *)showMoreButton{
    
    BDBButtonForSift *button = [BDBButtonForSift buttonWithType:UIButtonTypeCustom];
    
    button.isShowMores = NO;
    
    button.frame = CGRectMake(SCREEN_WIDTH - 30, 10, 16, 16);
        
    return button;
}

+ (BDBButtonForSift *)buttonWithTitle: (NSString *)title isSelected:(BOOL)selected frame: (CGRect)aFrame{
    
    BDBButtonForSift *button = [BDBButtonForSift buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    button.isSelected = selected;
    
    button.frame = aFrame;
    
    return button;
}


#pragma mark - Setter And Getter Methods

- (void)setIsSelected:(BOOL)isSelected{
    
    _isSelected = isSelected;
    
    if(_isSelected){
        
        [self setBackgroundImage:[UIImage imageNamed:@"subject_cell_sift_btn_platform_highlight_img"] forState:UIControlStateNormal];

    }
    else{
    
        [self setBackgroundImage:[UIImage imageNamed:@"subject_cell_sift_btn_platform_img"] forState:UIControlStateNormal];
    }
    
}

- (void)setIsShowMores:(BOOL)isShowMores{
    
    _isShowMores = isShowMores;
    
    if(_isShowMores){
        
        [self setImage:[UIImage imageNamed:@"subject_cell_sift_up_img"] forState:UIControlStateNormal];
        
    }
    else{
    
        [self setImage:[UIImage imageNamed:@"subject_cell_sift_down_img"] forState:UIControlStateNormal];
    }
}

@end
