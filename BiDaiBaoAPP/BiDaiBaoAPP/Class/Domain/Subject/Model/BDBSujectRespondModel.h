//
//  BDBSujectRespondModel.h
//  BiDaiBao(比贷宝)
//
//  Created by Imcore.olddog.cn on 15/6/28.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBSujectRespondModel : NSObject

@property(nonatomic,copy) NSString *Result;

@property(nonatomic,copy) NSString *Msg;

@property(nonatomic,copy) NSString *BidCount;

@property(nonatomic,copy) NSString *BidListNum;

@property(nonatomic,copy) NSArray *BidList;

@end
