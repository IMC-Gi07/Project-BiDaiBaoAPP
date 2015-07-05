//
//  BDBSujectP2PListResponseModel.h
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/2.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBSujectP2PListModel.h"
@interface BDBSujectP2PListResponseModel : NSObject

@property(nonatomic,strong) NSString *Result;

@property(nonatomic,strong) NSString *Msg;

@property(nonatomic,strong) NSString *P2PNum;

@property(nonatomic,strong) NSArray *P2PList;

@end
