//
//  modelForBDBAssitant.m
//  User_version_2
//
//  Created by olddog on 15/6/17.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserAssitantCellModel.h"

@implementation BDBUserAssitantCellModel

+ (BDBUserAssitantCellModel *)ModelWithImage: (UIImage *)aImage title: (NSString *)aTitle detail:(NSString *)aDetail tapGesture:(UITapGestureRecognizer *)aTapGesture{

    BDBUserAssitantCellModel *modelForBDBAssitant = [[BDBUserAssitantCellModel alloc] init];
    
    modelForBDBAssitant.image = aImage;
    
    modelForBDBAssitant.titlStr =aTitle;
    
    modelForBDBAssitant.detailStr = aDetail;
    
    modelForBDBAssitant.tapGesture = aTapGesture;
    
    return modelForBDBAssitant;
}

@end
