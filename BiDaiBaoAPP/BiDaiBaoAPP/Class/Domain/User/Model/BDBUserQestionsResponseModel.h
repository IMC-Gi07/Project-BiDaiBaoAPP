//
//  BDBUserQestionsResponseModel.h
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/9.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBUserQestionsResponseModel : NSObject

@property(nonatomic,copy) NSString *Result;

@property(nonatomic,copy) NSString *Msg;

@property(nonatomic,copy) NSString *QuestionNum;

@property(nonatomic,strong) NSMutableArray *QuestionList;

@end
