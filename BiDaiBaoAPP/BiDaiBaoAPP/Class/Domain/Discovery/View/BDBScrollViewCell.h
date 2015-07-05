//
//  BDBScrollViewCell.h
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/12.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBScrollViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *imagesArray;
@end
