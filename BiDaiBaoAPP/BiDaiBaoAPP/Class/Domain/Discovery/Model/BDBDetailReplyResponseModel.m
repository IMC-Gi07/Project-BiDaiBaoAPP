//
//  BDBHotTopicsResponseModel.m
//  BiDaiBao(比贷宝)
//
//  Created by Tomoxox on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBDetailReplyResponseModel.h"
#import "BDBDetailReplyModel.h"
@implementation BDBDetailReplyResponseModel
+ (NSDictionary *)objectClassInArray {
    return @{@"QuestionReplyList": [BDBDetailReplyModel class]};
}

@end
