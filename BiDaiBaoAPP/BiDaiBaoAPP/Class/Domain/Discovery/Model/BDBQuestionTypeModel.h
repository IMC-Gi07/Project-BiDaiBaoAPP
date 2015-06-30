//
//  BDBQuestionTypeModel.h
//  BiDaiBao(比贷宝)
//
//  Created by moon on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBQuestionTypeListModel.h"

@interface BDBQuestionTypeModel : NSObject

@property (nonatomic,assign) NSInteger Result;

@property (nonatomic,copy) NSString *Msg;

@property (nonatomic,assign) NSInteger QuestionTypeNum;

@property (nonatomic,strong) NSMutableArray *QuestionTypeList;




@end
