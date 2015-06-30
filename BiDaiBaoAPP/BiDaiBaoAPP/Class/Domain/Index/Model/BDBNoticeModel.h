//
//  BDBNoticeModel.h
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/26.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBNoticeModel : NSObject

/**
 *  公告编号
 */
@property(nonatomic,copy) NSString *NewsID;

/**
 *  发布者
 */
@property(nonatomic,copy) NSString *Publisher;

/**
 *  发布时间
 */
@property(nonatomic,copy) NSString *DT;

/**
 *  标题
 */
@property(nonatomic,copy) NSString *Title;

/**
 *  内容简要
 */
@property(nonatomic,copy) NSString *FirstSection;

/**
 *  详细页面内容地址
 */
@property(nonatomic,copy) NSString *DetailURL;

@end
