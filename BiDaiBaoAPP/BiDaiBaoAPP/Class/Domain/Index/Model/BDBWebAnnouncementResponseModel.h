//
//  BDBWebAnnouncementModel.h
//  BiDaiBaoAPP
//
//  Created by Jamy on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBWebAnnouncementResponseModel : NSObject

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
@property(nonatomic,copy) NSArray *NoticeList;


@end
