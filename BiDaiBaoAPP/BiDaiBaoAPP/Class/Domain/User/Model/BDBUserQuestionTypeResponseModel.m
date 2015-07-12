//
//  BDBUserQuestionTypeResponseModel.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/10.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserQuestionTypeResponseModel.h"

#import "BDBUserQuestionTypeModel.h"

@implementation BDBUserQuestionTypeResponseModel

+ (NSDictionary *)objectClassInArray{

    return @{@"QuestionTypeList":[BDBUserQuestionTypeModel class]};
}

@end
