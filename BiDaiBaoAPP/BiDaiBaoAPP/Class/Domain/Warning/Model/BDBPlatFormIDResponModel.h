//
//  BDBPlatFormIDResponModel.h
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBPlatFormIDResponModel : NSObject

@property (nonatomic,copy) NSString *Msg;

@property (nonatomic,assign)NSUInteger Result;

@property (nonatomic,assign)NSUInteger P2PNum;

@property (nonatomic,copy) NSMutableArray *P2PList;

@end
