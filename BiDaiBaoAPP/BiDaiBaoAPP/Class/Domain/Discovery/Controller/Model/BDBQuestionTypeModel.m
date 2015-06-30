//
//  BDBQuestionTypeModel.m
//  BiDaiBao(比贷宝)
//
//  Created by moon on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBQuestionTypeModel.h"

@implementation BDBQuestionTypeModel
+ (NSDictionary *)objectClassInArray {
    return @{@"QuestionTypeList": [BDBQuestionTypeListModel class]};
}

@end
