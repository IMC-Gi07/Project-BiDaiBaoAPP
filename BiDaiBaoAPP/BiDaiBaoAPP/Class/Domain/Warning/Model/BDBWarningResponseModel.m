//
//  BDBWarningResponseModel.m
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBWarningResponseModel.h"
#import "BDBWarningModelOne.h"
#import "BDBWarningModelTwo.h"

@implementation BDBWarningResponseModel

+ (NSDictionary *)objectClassInArray{
    return @{@"AlarmEarningsList":[BDBWarningModelOne class],@"AlarmRingList":[BDBWarningModelTwo class]};
}



@end
