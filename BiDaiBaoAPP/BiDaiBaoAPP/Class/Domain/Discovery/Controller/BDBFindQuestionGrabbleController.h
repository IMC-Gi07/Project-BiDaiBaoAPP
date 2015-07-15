//
//  ViewController.h
//  BDB_FindQuestionGrabble
//
//  Created by moon on 15/6/11.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBFindQuestionButton.h"


@protocol  BDBFindQuestionGrabbleControllerDelegate;
@class BDBHotTopicsResponseModel;



@interface BDBFindQuestionGrabbleController : UIViewController


@property (nonatomic,copy) NSString *questionTitle;
@property (nonatomic,assign) NSInteger questionAskTime;
@property (nonatomic,strong) NSString *textFieldText;

@property (nonatomic,weak) id<BDBFindQuestionGrabbleControllerDelegate> delegate;





@end

@protocol BDBFindQuestionGrabbleControllerDelegate <NSObject>


- (void)textField:(NSString *)textFieldText;


@end







