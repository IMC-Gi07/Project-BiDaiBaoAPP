//
//  BDBHotTopicsModel.h
//  BiDaiBao(比贷宝)
//
//  Created by Tomoxox on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBDetailReplyModel : NSObject
/**
 *  问题编号
 */
@property(nonatomic,copy) NSString *ReplyID;

/**
 *  问题类别编号
 */
@property(nonatomic,copy) NSString *Answerinfo;

/**
 *  提问者
 */
@property(nonatomic,copy) NSString *AnswerUser;
/**
 *  提问者头像
 */
@property(nonatomic,copy) NSString *UserPhoto;
/**
 *  标题
 */
@property(nonatomic,copy) NSString *Hot;
/**
 *  标题
 */
@property(nonatomic,copy) NSString *IP;
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
@property(nonatomic,copy) NSString *Timeinfo;
/**
 *  回帖数量
 */
@property(nonatomic,copy) NSString *ID;
/**
 *  回帖数量
 */
@property(nonatomic,copy) NSString *TypeID;
/**
 *  回帖数量
 */
@property(nonatomic,copy) NSString *Title;





@end
