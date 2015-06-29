//
//  BDBButtonForSift.m
//  Subject_verson1
//
//  Created by olddog on 15/6/10.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBButtonForSift.h"

@interface BDBButtonForSift ()




- (void)swithIsSelected;

- (void)swithIsShowMore;

@end

@implementation BDBButtonForSift

+ (BDBButtonForSift *)showMoreButton{
    
    BDBButtonForSift *button = [BDBButtonForSift buttonWithType:UIButtonTypeCustom];
    
    button.isShowMores = NO;
    
    button.frame = CGRectMake(SCREEN_WIDTH - 30, 9, 16, 22);
        
    return button;
}

+ (BDBButtonForSift *)buttonWithTitle: (NSString *)title section:(NSUInteger)aSection isSelected:(BOOL)selected frame: (CGRect)aFrame{
    
    BDBButtonForSift *button = [BDBButtonForSift buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    button.isSelected = selected;
    
    [button addTarget:button action:@selector(swithIsSelected) forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = aFrame;
    
    return button;
}

- (void)swithIsSelected{

    if(_isSelected){
        
        self.isSelected = NO;
    }
    else{
    
        self.isSelected = YES;
    }
    
    _singleSelectForSiftBlock([self titleForState:UIControlStateNormal],_isSelected);
}

- (void)swithIsShowMore{

    if(_isShowMores){
    
        self.isShowMores = NO;
    }
    else{
    
        self.isShowMores = YES;
    }
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
    
    if(_updataButtonInfo != nil){
    
        _updataButtonInfo([self titleForState:UIControlStateNormal],_isSelected);
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
