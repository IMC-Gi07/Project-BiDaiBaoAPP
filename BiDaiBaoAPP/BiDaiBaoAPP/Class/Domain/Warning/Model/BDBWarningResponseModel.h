//
//  BDBWarningResponseModel.h
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBWarningResponseModel : NSObject

@property (nonatomic,copy) NSString *Msg;

@property(nonatomic,assign) NSUInteger Result;

@property (nonatomic,copy) NSString *AlarmMode;

@property (nonatomic,copy) NSString *SlientFrom_Hour;

@property (nonatomic,copy) NSString *SlientFrom_Minute;

@property (nonatomic,copy) NSString *SlientTo_Hour;

@property (nonatomic,copy) NSString *SlientTo_Minute;

@property (nonatomic,copy) NSString *SlientSettingActive;

@property (nonatomic,assign) NSUInteger AlarmEarningsNum;

@property (nonatomic,strong) NSMutableArray *AlarmEarningsList;

@property (nonatomic,assign) NSUInteger AlarmRingNum;

@property (nonatomic,strong) NSMutableArray *AlarmRingList;

@end
