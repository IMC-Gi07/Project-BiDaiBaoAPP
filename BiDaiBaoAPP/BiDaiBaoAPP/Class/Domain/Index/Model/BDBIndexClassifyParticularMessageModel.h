//
//  BDBIndexClassifyParticularMessageModel.h
//  BiDaiBaoAPP
//
//  Created by Jamy on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBIndexClassifyParticularMessageModel : NSObject

/**
 *  标的编号
 */

@property(nonatomic,copy) NSString *ID;

/**
 *  标的内部编号
 */

@property(nonatomic,copy) NSString *BidID;

/**
 *  标的名称（标题）
 */

@property(nonatomic,copy) NSString *BidName;

/**
 *  标的金额(元)
 */

@property(nonatomic,copy) NSString *Amount;

/**
 *  标的期限（天）
 */

@property(nonatomic,copy) NSString *Term;

/**
 *  发标时间
 */

@property(nonatomic,copy) NSString *BidDT;

/**
 *  进度说明
 */

@property(nonatomic,copy) NSString *Schedule;

/**
 *  官网详细信息页面地址
 */

@property(nonatomic,copy) NSString *DetailURL;

/**
 *  年利率
 */

@property(nonatomic,copy) NSString *AnnualEarnings;

/**
 *  平台名称
 */

@property(nonatomic,copy) NSString *PlatformName;

/**
 *  进度百分比
 */

@property(nonatomic,copy) NSString *ProgressPercent;


@end
