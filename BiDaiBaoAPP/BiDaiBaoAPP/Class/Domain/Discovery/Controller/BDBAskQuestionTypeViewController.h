//
//  BDBAskQuestionTypeViewController.h
//  BiDaiBaoAPP
//
//  Created by moon on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDBAskQuestionTypeViewControllerDelegate;

@class BDBGetQuestionTypeListModel;


@interface BDBAskQuestionTypeViewController : UIViewController

@property (nonatomic,assign) NSString *buttonTitle;

@property(nonatomic,weak) id<BDBAskQuestionTypeViewControllerDelegate> delegate;

@end


@protocol BDBAskQuestionTypeViewControllerDelegate <NSObject>

/**
    controller将数据返回
 **/
- (void)controller:(BDBAskQuestionTypeViewController *)controller selectedQuestion:(BDBGetQuestionTypeListModel *)question;

@end