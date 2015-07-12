//
//  IMCGetP2PListResponseModel.h
//  Demo_数据存储(SQLite3)
//
//  Created by zhang xianglu on 15/7/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDBGetP2PListResponseModel : NSObject 

@property(nonatomic,copy) NSString *Result;

@property(nonatomic,copy) NSString *Msg;

@property(nonatomic,assign) NSUInteger P2PNum;

@property(nonatomic,copy) NSArray *P2PList;

@end
