//
//  BDBSubjectSievingContronller.h
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBSubjectDeepexcavationContronller : UIViewController

@property(nonatomic,strong)NSMutableDictionary *filterCondition;


//被选中的平台按钮
@property(nonatomic,strong) NSMutableArray *selectedPlatformArray;

//被选中的收益率按钮
@property(nonatomic,strong) NSMutableArray *selectedProfitArray;

//被选中的期限按钮
@property(nonatomic,strong) NSMutableArray *selectedTermArray;

//被选中的进度按钮
@property(nonatomic,strong) NSMutableArray *selectedProgressArray;

@end
