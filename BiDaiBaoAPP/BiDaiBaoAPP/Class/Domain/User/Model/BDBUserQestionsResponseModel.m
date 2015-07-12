//
//  BDBUserQestionsResponseModel.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/9.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserQestionsResponseModel.h"
#import "BDBUserQestionsModel.h"
@implementation BDBUserQestionsResponseModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"QuestionList":[BDBUserQestionsModel class]};
}

@end
