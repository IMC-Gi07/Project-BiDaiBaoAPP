//
//  BDBImformationCell.h
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/13.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBImformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *firstSection;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *publisher;
@property (weak, nonatomic) IBOutlet UILabel *DT;
@property (weak, nonatomic) IBOutlet UILabel *PopularIndex;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;

@end
