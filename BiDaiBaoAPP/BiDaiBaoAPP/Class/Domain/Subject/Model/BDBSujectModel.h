//
//  BDBSujectModel.h
//  BiDaiBao(比贷宝)
//
//  Created by Imcore.olddog.cn on 15/6/28.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBSujectModel : NSObject

@property(nonatomic,copy) NSString *ID;

@property(nonatomic,copy) NSString *BidID;

@property(nonatomic,copy) NSString *BidName;

@property(nonatomic,copy) NSString *Amount;

@property(nonatomic,copy) NSString *Term;

@property(nonatomic,copy) NSString *BidDT;

@property(nonatomic,copy) NSString *Schedule;

@property(nonatomic,copy) NSString *DetailURL;

@property(nonatomic,copy) NSString *AnnualEarnings;

@property(nonatomic,copy) NSString *PlatformName;

@property(nonatomic,copy) NSString *ProgressPercent;

@end
