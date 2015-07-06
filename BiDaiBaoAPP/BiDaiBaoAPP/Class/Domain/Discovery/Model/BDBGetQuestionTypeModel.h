//
//  BDBGetQuestionTypeModel.h
//  BiDaiBaoAPP
//
//  Created by moon on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBGetQuestionTypeModel : NSObject

//0:成功 1：异常
@property(nonatomic,assign) NSInteger Result;

//附加消息，存放异常说明
@property(nonatomic,copy) NSString *Msg;

//返回的问题分类数量
@property(nonatomic,assign) NSInteger QuestionTypeNum;

//问题类型列表
@property(nonatomic,assign) NSMutableArray *QuestionTypeList;

@end
