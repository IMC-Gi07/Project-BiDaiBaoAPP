//
//  BDB_TableViewCell_One.m
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import "BDB_TableViewCell_One.h"
#import "BDB_Cell_Button.h"
#import "BDB_Model.h"

@implementation BDB_TableViewCell_One

- (void)awakeFromNib {
    //    实例化第一排button设置标题、字体、标题颜色
    
    
    
    BDB_Cell_Button *button1 = [[BDB_Cell_Button alloc] init];
    [button1 setTitle:@"人人贷" forState:UIControlStateNormal];
//    button1.titleLabel.text =
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button1.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
   [self addSubview:button1];
    button1.translatesAutoresizingMaskIntoConstraints = NO;
    
    BDB_Cell_Button *button2 = [[BDB_Cell_Button alloc] init];
    [button2 setTitle:@"招财宝" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:button2];
    button2.translatesAutoresizingMaskIntoConstraints = NO;
    BDB_Cell_Button *button3 = [[BDB_Cell_Button alloc] init];
    [self addSubview:button3];
    button3.translatesAutoresizingMaskIntoConstraints = NO;
    BDB_Cell_Button *button4 = [[BDB_Cell_Button alloc] init];
    [self addSubview:button4];
    button4.translatesAutoresizingMaskIntoConstraints = NO;
    
    
//    设置第一排的宽度约束  间距不变button宽度变
     NSString *hVFL_1 = @"H:|-13-[button1(==button2)]-20-[button2(==button3)]-20-[button3(==button4)]-20-[button4(==button1)]-13-|";
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hVFL_1 options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"button1": button1,@"button2": button2,@"button3": button3,@"button4":button4}];
    [self addConstraints:hConstraints];
    
    //    实例化第一排button设置标题、字体、标题颜色
    BDB_Cell_Button *button5 = [[BDB_Cell_Button alloc] init];
    [self addSubview:button5];
    button1.translatesAutoresizingMaskIntoConstraints = NO;
    BDB_Cell_Button *button6 = [[BDB_Cell_Button alloc] init];
    [self addSubview:button6];
    button2.translatesAutoresizingMaskIntoConstraints = NO;
    BDB_Cell_Button *button7 = [[BDB_Cell_Button alloc] init];
    [self addSubview:button7];
    button3.translatesAutoresizingMaskIntoConstraints = NO;
    BDB_Cell_Button *button8 = [[BDB_Cell_Button alloc] init];
    [self addSubview:button8];
    button4.translatesAutoresizingMaskIntoConstraints = NO;
    
//    设置第二排的宽度约束  间距不变button宽度变
    NSString *hVFL_2 = @"H:|-13-[button5(==button6)]-20-[button6(==button7)]-20-[button7(==button8)]-20-[button8(==button5)]-13-|";
    NSArray *hConstraints_2 = [NSLayoutConstraint constraintsWithVisualFormat:hVFL_2 options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"button5": button5,@"button6": button6,@"button7": button7,@"button8":button8}];
    [self addConstraints:hConstraints_2];
   
//    设置第一排和第二排的间距
    NSString *vVFL = @"V:|[button1]-13-[button5]";
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:@{@"button1": button1,@"button5": button5,}];
    [self addConstraints:vConstraints];

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
