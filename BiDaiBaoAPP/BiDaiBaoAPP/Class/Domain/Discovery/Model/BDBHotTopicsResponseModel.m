//
//  BDBHotTopicsResponseModel.m
//  BiDaiBao(比贷宝)
//
//  Created by Tomoxox on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBHotTopicsResponseModel.h"
#import "BDBHotTopicsModel.h"
@implementation BDBHotTopicsResponseModel
+ (NSDictionary *)objectClassInArray {
    return @{@"QuestionList": [BDBHotTopicsModel class]};
}

@end
