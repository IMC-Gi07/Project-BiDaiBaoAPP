//
//  BDBIndexClassifyParticularMessageModel.h
//  BiDaiBaoAPP
//
//  Created by Jamy on 15/6/30.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBIndexClassifyParticularMessageResponseModel : NSObject
/**
 *  返回状态(0:表示成功，1：表示失败)
 */

@property(nonatomic,assign) NSUInteger Result;

/**
 *  附加消息，存放异常说明
 */

@property(nonatomic,copy) NSString *Msg;

/**
 *  所有页的总标的数（条）
 */

@property(nonatomic,copy) NSString *BidCount;

/**
 *  返回当前页的BidListNum中的标的数量（条）
 */

@property(nonatomic,copy) NSString *BidListNum;

/**
 *  标的列表
 */

@property(nonatomic,copy) NSArray *BidList;

























@end
