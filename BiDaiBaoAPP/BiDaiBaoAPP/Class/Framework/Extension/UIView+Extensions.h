//
//  UIView+Extensions.h
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/6.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Frame方面的扩展
 */
@interface UIView(Frame)

/**
 *  origin
 */
@property(nonatomic,assign) CGPoint origin;

/**
 *  x坐标
 */
@property(nonatomic,assign) CGFloat x;

/**
 *  y坐标
 */
@property(nonatomic,assign) CGFloat y;


/**
 *  size
 */
@property(nonatomic,assign) CGSize size;
 
/**
 *  width
 */
@property(nonatomic,assign) CGFloat width; 
 
/**
 *  height
 */
@property(nonatomic,assign) CGFloat height;

/**
 *  centerX
 */
@property(nonatomic,assign) CGFloat centerX;

/**
 *  centerY
 */
@property(nonatomic,assign) CGFloat centerY;

@end


