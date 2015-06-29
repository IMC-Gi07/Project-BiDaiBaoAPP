//
//  BDBSujectRespondModel.m
//  BiDaiBao(比贷宝)
//
//  Created by Imcore.olddog.cn on 15/6/28.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBSujectRespondModel.h"
#import "BDBSujectModel.h"

@implementation BDBSujectRespondModel

+ (NSDictionary *)objectClassInArray{

    return @{@"BidList":[BDBSujectModel class]};
}

@end
