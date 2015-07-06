//
//  BDBButtonForTopView.h
//  BiDaiBao(比贷宝)
//
//  Created by Imcore.olddog.cn on 15/6/11.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBButtonForTopView : UIButton

//判断按钮是否惦记
@property(nonatomic,assign) BOOL isClicked;


/**
 *  便利构造器
 *
 *  @param aTitle 按钮标题
 *  @param color  字体颜色
 *  @param aImage 按钮前景图片
 *
 *  @return BDBButtonForTopView
 */
+ (BDBButtonForTopView *)buttonWithTitle: (NSString *)aTitle titleColor:(UIColor *)color image: (UIImage *)aImage;

@end
