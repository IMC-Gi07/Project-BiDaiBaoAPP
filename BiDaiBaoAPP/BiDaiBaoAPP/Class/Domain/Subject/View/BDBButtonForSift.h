//
//  BDBButtonForSift.h
//  Subject_verson1
//
//  Created by olddog on 15/6/10.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBButtonForSift.h"


@interface BDBButtonForSift : UIButton

@property(nonatomic,assign) BOOL isShowMores;

@property(nonatomic,assign) BOOL isSelected;

+ (BDBButtonForSift *)showMoreButton;

+ (BDBButtonForSift *)buttonWithTitle: (NSString *)title isSelected:(BOOL)selected frame: (CGRect)aFrame;

@end
