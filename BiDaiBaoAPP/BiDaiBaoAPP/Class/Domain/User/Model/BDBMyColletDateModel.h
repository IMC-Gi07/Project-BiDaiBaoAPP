//
//  BDBMyColletDateModel.h
//  BiDaiBaoAPP
//
//  Created by Carrie's baby on 15/7/3.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBMyColletDateModel : NSObject

/**
 *  返回状态(0:表示成功，1：表示失败)
 */
@property(nonatomic,copy) NSString *Result;

/**
 *  附加消息
 */
@property(nonatomic,copy) NSString *Msg;

/**
 *  所有页总标的数
 */
@property(nonatomic,copy) NSString *BidCount;

/**
 *  返回当前页的BidListNum
 */
@property(nonatomic,copy) NSString *BidListNum;

/**
 *  BidList
 */
@property(nonatomic,strong) NSMutableArray *BidList;



@end
