//
//  BDBUserQuestionTypeResponseModel.h
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/10.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBUserQuestionTypeResponseModel : NSObject

@property(nonatomic,copy) NSString *Result;

@property(nonatomic,copy) NSString *Msg;

@property(nonatomic,copy) NSString *QuestionTypeNum;

@property(nonatomic,strong) NSMutableArray *QuestionTypeList;

@end
