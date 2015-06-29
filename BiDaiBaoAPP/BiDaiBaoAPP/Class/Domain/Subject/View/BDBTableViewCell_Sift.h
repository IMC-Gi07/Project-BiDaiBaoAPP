//
//  BDBTableViewCell_Sift.h
//  Subject_verson1
//
//  Created by Imcore.olddog.cn on 15/6/10.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBButtonForSift.h"


@interface BDBTableViewCell_Sift : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

+ (BDBTableViewCell_Sift *)cell;

- (void)createContentsAccordingSection: (NSUInteger)section;

@end
