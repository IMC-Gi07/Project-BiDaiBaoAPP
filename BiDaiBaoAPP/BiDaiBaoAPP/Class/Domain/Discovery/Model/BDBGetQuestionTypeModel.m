//
//  BDBGetQuestionTypeModel.m
//  BiDaiBaoAPP
//
//  Created by moon on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBGetQuestionTypeModel.h"
#import "BDBGetQuestionTypeListModel.h"
@implementation BDBGetQuestionTypeModel

+ (NSDictionary *)objectClassInArray {
    return @{@"QuestionTypeList": [BDBGetQuestionTypeListModel class]};
}

@end
