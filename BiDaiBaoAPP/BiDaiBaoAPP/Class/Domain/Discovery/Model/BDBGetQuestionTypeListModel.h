//
//  BDBQuestionTypeListModel.h
//  BiDaiBaoAPP
//
//  Created by moon on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBGetQuestionTypeListModel : NSObject


//类别编号
@property(nonatomic,assign) NSInteger TypeID;

//类别名称
@property(nonatomic,copy) NSString *TypeName;

//是否显示 0：不显示 1：显示
@property(nonatomic,assign) NSInteger Visible;


@end
