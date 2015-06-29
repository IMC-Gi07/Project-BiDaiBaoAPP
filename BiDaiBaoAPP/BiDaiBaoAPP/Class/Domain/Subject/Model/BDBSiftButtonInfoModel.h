//
//  SiftButtonInfo.h
//  BiDaiBao(比贷宝)
//
//  Created by Imcore.olddog.cn on 15/6/11.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBSiftButtonInfoModel : NSObject

@property(nonatomic,strong) NSString *title;

@property(nonatomic,assign) BOOL isSelected;

@property(nonatomic,assign) NSInteger xPoint;

@property(nonatomic,assign) NSInteger yPoint;

@end
