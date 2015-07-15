//
//  BDBUserQAviewModel.h
//  BiDaiBaoAPP
//
//  Created by Carrie's baby on 15/7/6.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBUserQAviewModel : NSObject

/**
 *  返回状态(0:表示成功，1：表示失败)
 */
@property(nonatomic,assign) NSUInteger Result;

/**
 *  附加消息
 */
@property(nonatomic,copy) NSString *Msg;


@end
