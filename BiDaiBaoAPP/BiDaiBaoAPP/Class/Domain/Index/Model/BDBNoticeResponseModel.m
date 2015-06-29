//
//  BDBNoticeResponseModel.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/26.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBNoticeResponseModel.h"
#import "BDBNoticeModel.h"


@implementation BDBNoticeResponseModel

+ (NSDictionary *)objectClassInArray {
	return @{@"NoticeList": [BDBNoticeModel class]};
}


@end
