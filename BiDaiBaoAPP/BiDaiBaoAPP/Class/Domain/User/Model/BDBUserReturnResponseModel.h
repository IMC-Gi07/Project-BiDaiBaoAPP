//
//  BDBNoticeResponseModel.h
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/28.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBUserReturnResponseModel : NSObject

/**
 *  返回状态(0:表示成功，1：表示失败)
 */
@property(nonatomic,assign) NSUInteger Result;

/**
 *  附加消息
 */
@property(nonatomic,copy) NSString *Msg;

/**
 *  头像文件地址
 */
@property(nonatomic,copy) NSString *Photo;

/**
 *  昵称
 */
@property(nonatomic,copy) NSString *NiName;

/**
 *  用户名
 */
@property(nonatomic,copy) NSString *UserName;

@end
