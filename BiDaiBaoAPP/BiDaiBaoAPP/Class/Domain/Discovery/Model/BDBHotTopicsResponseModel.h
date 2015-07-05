//
//  BDBHotTopicsResponseModel.h
//  BiDaiBao(比贷宝)
//
//  Created by Tomoxox on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBHotTopicsResponseModel : NSObject
/**
 *  返回状态(0:表示成功，1：表示失败)
 */
@property(nonatomic,assign) NSUInteger Result;

/**
 *  附加消息
 */
@property(nonatomic,copy) NSString *Msg;

/**
 *  问题数量
 */
@property(nonatomic,assign) NSUInteger QuestionNum;

/**
 *  问题列表
 */
@property(nonatomic,strong) NSMutableArray *QuestionList;

@end
