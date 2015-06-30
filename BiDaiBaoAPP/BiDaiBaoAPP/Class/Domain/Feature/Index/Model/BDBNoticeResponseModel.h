//
//  BDBNoticeResponseModel.h
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/26.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBNoticeResponseModel : NSObject

/**
 *  返回状态(0:表示成功，1：表示失败)
 */
@property(nonatomic,assign) NSUInteger Result;

/**
 *  附加消息
 */
@property(nonatomic,copy) NSString *Msg;

/**
 *  公告数量
 */
@property(nonatomic,assign) NSUInteger NoticeNum;

/**
 *  公告列表
 */
@property(nonatomic,strong) NSMutableArray *NoticeList;



@end
