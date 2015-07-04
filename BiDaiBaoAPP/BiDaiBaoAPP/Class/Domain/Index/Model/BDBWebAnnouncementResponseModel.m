//
//  BDBWebAnnouncementModel.m
//  BiDaiBaoAPP
//
//  Created by Jamy on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBWebAnnouncementResponseModel.h"
#import "BDBNoticeModel.h"
@implementation BDBWebAnnouncementResponseModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"NoticeList": [BDBNoticeModel class]};
}

@end
