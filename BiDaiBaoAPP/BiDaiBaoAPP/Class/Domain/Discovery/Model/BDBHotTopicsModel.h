//
//  BDBHotTopicsModel.h
//  BiDaiBao(比贷宝)
//
//  Created by Tomoxox on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBHotTopicsModel : NSObject
/**
 *  问题编号
 */
@property(nonatomic,copy) NSString *ID;

/**
 *  问题类别编号
 */
@property(nonatomic,copy) NSString *TypeID;

/**
 *  提问者
 */
@property(nonatomic,copy) NSString *AskUser;
/**
 *  提问者头像
 */
@property(nonatomic,copy) NSString *UserPhoto;
/**
 *  标题
 */
@property(nonatomic,copy) NSString *Title;
/**
 *  是否推荐。0：不推荐；1：推荐；其他值不限
 */
@property(nonatomic,copy) NSString *Recomand;

/**
 *  解决状态。 0：未解决 ； 1：已解决 ；
 */
@property(nonatomic,copy) NSString *State;
/**
 *  回帖数量
 */
@property(nonatomic,copy) NSString *ReplyNum;
/**
 *  点赞数量（对官方回复）
 */
@property(nonatomic,copy) NSString *Hot;
/**
 *  提问时间
 */
@property(nonatomic,copy) NSString *AskTime;
/**
 *  首条回复的内容（如果有官方回复的话，则返回官方回复的内容）
 */
@property(nonatomic,copy) NSString *FirstReply;
/**
 *  首条回复时间
 */
@property(nonatomic,copy) NSString *FirstReplyDate;



@end
