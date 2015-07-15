//
//  BDBMyColletDateModel.m
//  BiDaiBaoAPP
//
//  Created by Carrie's baby on 15/7/3.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBMyColletDateModel.h"
#import "BDBMyColletDateBidListModel.h"

@implementation BDBMyColletDateModel

+ (NSDictionary *)objectClassInArray {
    return @{@"BidList": [BDBMyColletDateBidListModel class]};
}

@end
