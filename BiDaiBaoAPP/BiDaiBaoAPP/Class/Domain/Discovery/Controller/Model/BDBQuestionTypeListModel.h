//
//  BDBQuestionTypeListModel.h
//  BiDaiBao(比贷宝)
//
//  Created by moon on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    unvisible,
    visible
}VisibleType;


@interface BDBQuestionTypeListModel : NSObject

@property (nonatomic,copy) NSString *TypeID;

@property (nonatomic,copy) NSString *TypeName;

@property (nonatomic,assign) VisibleType Visible;

@end
