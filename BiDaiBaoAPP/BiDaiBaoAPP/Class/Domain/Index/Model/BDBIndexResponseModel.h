//
//  BDBIndexResponseModel.h
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/28.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBIndexResponseModel : NSObject

/**
 *  返回状态(0:表示成功，1：表示失败)
 */

@property(nonatomic,assign) NSUInteger Result;

/**
 *  附加消息，存放异常说明
 */

@property(nonatomic,copy) NSString *Msg;

/**
 *  当前数据日期，格式如：2014-11-02
 */

@property(nonatomic,copy) NSString *Date;

/**
 *  平台名称
 */

@property(nonatomic,copy) NSString *PlatformName;

/**
 *  今日的最高收益
 */

@property(nonatomic,copy) NSString *EarningsMax;

/**
 *  今日可投金额
 */

@property(nonatomic,copy) NSString *AmountRemain;

/**
 *  今日发标数量
 */

@property(nonatomic,copy) NSString *BidNum;

/**
 *  今日发标金额
 */

@property(nonatomic,copy) NSString *BidAmount;


/**
 *  今日投资者人数
 */

@property(nonatomic,copy) NSString *InvestorNum;





















@end
