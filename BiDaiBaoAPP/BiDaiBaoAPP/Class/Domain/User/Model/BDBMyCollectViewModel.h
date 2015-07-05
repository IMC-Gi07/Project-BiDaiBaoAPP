//
//  BDBMyCollectViewModel.h
//  BiDaiBaoAPP
//
//  Created by Carrie's baby on 15/7/3.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBMyCollectViewModel : NSObject


/**
 *  返回状态(0:表示成功，1：表示失败)
 */
@property(nonatomic,assign) NSUInteger Result;

/**
 *  附加消息
 */
@property(nonatomic,copy) NSString *Msg;

/**
 *  我的收藏
 */
@property(nonatomic,copy) NSString *StoreNum;

/**
 *  我的消息
 */
@property(nonatomic,copy) NSString *MsgNum;

/**
 *  BidList
 */
@property(nonatomic,copy) NSString *BidList;
@end


