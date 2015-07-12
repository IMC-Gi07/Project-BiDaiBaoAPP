//
//  IMCGetP2PListResponseModel.m
//  Demo_数据存储(SQLite3)
//
//  Created by zhang xianglu on 15/7/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBGetP2PListResponseModel.h"
#import "MJExtension.h"
#import "BDBP2PPlatformModel.h"

@interface BDBGetP2PListResponseModel ()

@end

@implementation BDBGetP2PListResponseModel

+ (NSDictionary *)objectClassInArray {
	return @{@"P2PList":[BDBP2PPlatformModel class]};
} 




@end
