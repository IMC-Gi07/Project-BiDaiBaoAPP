//
//  BDBUserAnswerResponseModel.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/10.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserAnswerResponseModel.h"
#import "BDBUserAnswerModel.h"
@implementation BDBUserAnswerResponseModel

+ (NSDictionary *)objectClassInArray{

    return @{@"QuestionReplyList":[BDBUserAnswerModel class]};
}

@end
