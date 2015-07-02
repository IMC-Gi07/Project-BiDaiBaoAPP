//
//  BDBIndexClassifyParticularMessageModel.m
//  BiDaiBaoAPP
//
//  Created by Jamy on 15/6/30.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBIndexClassifyParticularMessageResponseModel.h"
#import "BDBIndexClassifyParticularMessageModel.h"

@implementation BDBIndexClassifyParticularMessageResponseModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"NoticeList": [BDBIndexClassifyParticularMessageModel class]};
}

@end
