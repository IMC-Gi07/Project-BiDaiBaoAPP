//
//  BDBWarningModel.h
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBWarningModelOne : NSObject

@property(nonatomic,copy) NSString *ID;

@property(nonatomic,copy) NSString *PlatFormID;

@property(nonatomic,copy) NSString *Item;

@property(nonatomic,copy) NSString *Comparison;

@property(nonatomic,copy) NSString *ThresHold;

@property(nonatomic,copy) NSString *Active;

/**
 *  自添加属性，记录平台名称
 */
@property(nonatomic,copy) NSString *PlatformName;

@end
