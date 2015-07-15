//
//  BDBNoticeModel.h
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/26.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBDiscoveryModel : NSObject

/**
 *  资讯编号
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
 *  详细内容页面地址
 */
@property(nonatomic,copy) NSString *DetailURL;

/**
 *  头部图片地址
 */
@property(nonatomic,copy) NSString *PicURL;
/**
 *  热度
 */
@property(nonatomic,copy) NSString *PopularIndex;
/**
 *  评论次数
 */
@property(nonatomic,copy) NSString *CommentNum;
/**
 *  图片存储日期
 */
@property(nonatomic,copy) NSString *PicDate;


@end
