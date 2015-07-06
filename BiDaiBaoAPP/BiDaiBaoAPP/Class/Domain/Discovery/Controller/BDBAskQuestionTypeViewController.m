//
//  BDBAskQuestionTypeViewController.m
//  BiDaiBaoAPP
//
//  Created by moon on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBAskQuestionTypeViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FLAnimatedImage.h"
#import "ZXLLoadDataIndicatePage.h"

#import "BDBGetQuestionTypeModel.h"
#import "BDBGetQuestionTypeListModel.h"

#import "BDBQuestionTypeButton.h"
#import "BDBQuestionTypeGapButton.h"

#import "ZXLLoadDataIndicatePage.h"

@interface BDBAskQuestionTypeViewController ()

@property(nonatomic,strong) NSMutableArray *QuestionTypeModels;

@property (nonatomic,assign) NSInteger buttonGap;

@property (nonatomic,strong) ZXLLoadDataIndicatePage *indecatePage;

@end

@implementation BDBAskQuestionTypeViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.buttonGap = SCREEN_WIDTH / 12;
        NSLog(@"%li",_buttonGap);
    }
    return self;
}


- (void)viewDidLoad {
    [self loadMoreDatas];

    [super viewDidLoad];
    
    self.indecatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    


}

- (void)loadMoreDatas {

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestionType"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
        ZXLLOG(@"success response: %@",responseObject);
        
        BDBGetQuestionTypeModel *questionTypeModel = [BDBGetQuestionTypeModel objectWithKeyValues:responseObject];
        NSLog(@"%@",questionTypeModel);
        //将更多的数据，追加到数组后面
        self.QuestionTypeModels = [NSMutableArray array];
        [_QuestionTypeModels addObjectsFromArray:questionTypeModel.QuestionTypeList];

        for (NSInteger i = 0; i < questionTypeModel.QuestionTypeNum ; i++) {
            
             BDBGetQuestionTypeListModel *listModel = (BDBGetQuestionTypeListModel *)_QuestionTypeModels[i];
           
            
            
            BDBQuestionTypeButton *button = [[BDBQuestionTypeButton alloc] init];
            [button setTitle:listModel.TypeName forState:UIControlStateNormal];
            [button setTitleColor:UIColorWithRGB(36, 130, 232) forState:UIControlStateNormal];
            button.tag = listModel.TypeID;
            
            button.getQuestionTypeListModel = listModel;
            
            [self.view addSubview:button];
            
//            UIButton *button1 = (UIButton*)[self.view viewWithTag:i];
            
            [button addTarget:self action:@selector(buttonTouches:) forControlEvents:UIControlEventTouchDown];
            
            NSLayoutConstraint *buttonGapConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:_buttonGap + (i % 3) * (SCREEN_WIDTH / 4)];

            [self.view addConstraint:buttonGapConstraint];
            
            NSLayoutConstraint *buttonHeightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:100 + (i / 3) * 40];
            [self.view addConstraint:buttonHeightConstraint];
            self.indecatePage.hidden = YES;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
    
}

- (void)buttonTouches:(BDBQuestionTypeButton *)button {
    //查看代理对象是否包含这个方法
    if ([_delegate respondsToSelector:@selector(controller:selectedQuestion:)]) {
        [_delegate controller:self selectedQuestion:button.getQuestionTypeListModel];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
