//
//  BDBRegisterResponseModel.h
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/28.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBRegisterResponseModel : NSObject

/**
 *  用户登入名
 */
@property(nonatomic,copy) NSString *UID;

/**
 *  账户类型   0:比贷网（默认）1:QQ账户 2:微信账户 3:新浪账户
 */
@property(nonatomic,assign) NSUInteger *UserType;

/**
 *  用户登入密码 (MD5加密)
 */
@property(nonatomic,copy) NSString *PSW;

/**
 *  移动端机器码
 */
@property(nonatomic,copy) NSString *Machine_id;

/**
 *  移动设备类型 0:IOS 1:Android 2:其他
 */
@property(nonatomic,assign) NSUInteger *Device;


/**
 *  通信密钥
 */
@property(nonatomic,copy) NSString *Key;



@end
