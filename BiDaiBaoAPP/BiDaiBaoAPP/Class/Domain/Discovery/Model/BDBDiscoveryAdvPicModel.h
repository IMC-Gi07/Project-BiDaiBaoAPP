//
//  BDBDiscoveryAdvPicModel.h
//  BiDaiBaoAPP
//
//  Created by Tomoxox on 15/6/30.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBDiscoveryAdvPicModel : NSObject
/**
 *  返回状态(0:表示成功，1：表示失败)
 */
@property(nonatomic,assign) NSUInteger Result;

/**
 *  附加消息
 */
@property(nonatomic,copy) NSString *Msg;

/**
 *  图片URL
 */
@property(nonatomic,copy) NSString *PicList;
@end
