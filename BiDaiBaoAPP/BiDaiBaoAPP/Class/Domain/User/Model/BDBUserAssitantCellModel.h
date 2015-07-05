//
//  modelForBDBAssitant.h
//  User_version_2
//
//  Created by olddog on 15/6/17.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface BDBUserAssitantCellModel : NSObject

@property(nonatomic,strong) UIImage *image;

@property(nonatomic,strong) NSString *titlStr;

@property(nonatomic,strong) NSString *detailStr;

@property(nonatomic,strong) UITapGestureRecognizer *tapGesture;

+ (BDBUserAssitantCellModel *)ModelWithImage: (UIImage *)aImage title: (NSString *)aTitle detail:(NSString *)aDetail tapGesture:(UITapGestureRecognizer *)aTapGesture;

@end
