//
//  BDBwarningMoreBtnTableViewCell.m
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/9.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBwarningMoreBtnTableViewCell.h"
#import "BDBButtonForSift.h"
#import "BDBPlatFormIDModel.h"
#import "BDBSiftButtonInfoModel.h"
#import "BDBSujectP2PListModel.h"
#import "BDBSujectP2PListResponseModel.h"
#import "BDBWarningAddViewController.h"

@interface BDBwarningMoreBtnTableViewCell()
@property(nonatomic,weak) UIScrollView *filterScrollView;

@property(nonatomic,weak) UILabel *selectedPlatformName;

@property(nonatomic,weak) NSLayoutConstraint *heigtConstraintForPlatformView;

@property(nonatomic,strong) NSMutableArray *selectedPlatformArray;

@property(nonatomic,strong) NSMutableArray *selectedFilterArray;

@property(nonatomic,strong) NSMutableDictionary *filterCondition;

@property(nonatomic,strong) NSMutableArray *platformArray;

@property(nonatomic,weak) UIScrollView *platformView;

@property(nonatomic,assign)BOOL isChangeWhite;

@property(nonatomic,assign)BOOL isShink;

@end


@implementation BDBwarningMoreBtnTableViewCell


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.selectedPlatformArray = [NSMutableArray array];
        
        self.selectedFilterArray = [NSMutableArray array];
        
        self.filterCondition = [NSMutableDictionary dictionary];
		
		
        
        _filterCondition[@"平台"] = @"";
        
        self.isChangeWhite = NO;
		
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
	
	self.platformArray = [NSMutableArray array];
	[self loadP2PList];
    
}

//加载所有平台信息

- (void)loadP2PList{
	FMDatabase *database = [FMDatabase databaseWithPath:[CACHE_DIRECTORY stringByAppendingPathComponent:BDBGlobal_CacheDatabaseName]];
	if ([database open]) {
		NSString *sql = @"SELECT * FROM t_platform";
		
		FMResultSet *resultSet = [database executeQuery:sql];
		
		while ([resultSet next]) {
			BDBP2PPlatformModel *P2PPlatformModel = [[BDBP2PPlatformModel alloc] init];
			P2PPlatformModel.PlatFormID = [resultSet stringForColumn:@"pid"];
			P2PPlatformModel.PlatformName = [resultSet stringForColumn:@"name"];
			P2PPlatformModel.WebSite = [resultSet stringForColumn:@"website"];
			P2PPlatformModel.Deal = [resultSet stringForColumn:@"deal"];
			P2PPlatformModel.Popularity = [resultSet stringForColumn:@"popularity"];
			P2PPlatformModel.Earnings = [resultSet stringForColumn:@"earnings"];
			
			[_platformArray addObject:P2PPlatformModel];
		}
		
		[database close];
	}
	
	//[self loadFilterScrollView];
	
	[self loadFilterScrollViewSubView];
	
    
}

- (void)loadFilterScrollViewSubView{
    
    //筛选页面－》选择平台
    UIScrollView *platformView = [[UIScrollView alloc] init];
    
    platformView.tag = 200;
	
	platformView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
	
	platformView.contentSize = platformView.frame.size;
	
    [self.contentView addSubview:platformView];
	
	self.platformView = platformView;
    
    //筛选页面－》选择平台(选择平台)
    
    UILabel *platformLabel = [[UILabel alloc] init];
    
    platformLabel.text = @"选择平台:";
    
    [platformView addSubview:platformLabel];
    
    platformLabel.font  = [UIFont systemFontOfSize:15.0f];
    
    platformLabel.frame = CGRectMake(10, 10, 70, 15);
    
    //筛选页面－》选择平台(显示更多平台按钮)
    
    BDBButtonForSift *showMoreButton = [BDBButtonForSift showMoreButton];
    
    [showMoreButton addTarget:self action:@selector(showMoreButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [platformView addSubview:showMoreButton];
	
    
    //选择平台按钮
    
    [self layoutFilterViewPlatformButtonsWith:_platformArray view:platformView];
    
    //展开平台区（如需一开始展开平台请打开）
//	[self performSelector:@selector(showMoreButtonClickedAction:) withObject:showMoreButton];
}


/**
 *  显示更多平台
 */
- (void)showMoreButtonClickedAction: (BDBButtonForSift *)button{
    
    //代理，接受收缩按钮触发事件
   [_btnDelegate shinkTheMoreButton:button];
    
    if(button.isShowMores){
        ZXLLOG(@"闭合");
                
        button.isShowMores = NO;
        [UIView animateWithDuration:0.5f animations:^{
			_platformView.frame = CGRectMake(0, 0,SCREEN_WIDTH, 65);
			_platformView.contentSize = _platformView.frame.size;
            
        }];
        
    }
    else{
        ZXLLOG(@"张开");

        button.isShowMores = YES;
        [UIView animateWithDuration:0.5f animations:^{

			CGFloat heigth = 0.0f;
            
            NSInteger buttonCount = _platformArray.count;
            
            if(buttonCount % 4 == 0){
                
                heigth = buttonCount / 4 * 30 +  (buttonCount / 4 - 1) * 10 + 40;
            }
            else{
                
                heigth = (buttonCount / 4 + 1) * 30 + buttonCount / 4  * 10 + 40;
            }
            
			_platformView.frame = CGRectMake(0, 0,SCREEN_WIDTH, heigth);
			_platformView.contentSize = _platformView.frame.size;
        }];
    }
    
}


//平台按钮

- (void)layoutFilterViewPlatformButtonsWith:(NSArray *)array view: (UIView *)aView{
    //更改横坐标
    NSInteger hButtonCount = 0;
    
    //更改纵坐标
    NSInteger vButtonCount = 0;
    
    
    for (BDBSujectP2PListModel *model in array) {
        
        BDBSiftButtonInfoModel *buttonModel = [[BDBSiftButtonInfoModel alloc] init];
        buttonModel.title = model.PlatformName;
        buttonModel.isSelected = NO;
        buttonModel.xPoint = hButtonCount;
        buttonModel.yPoint = vButtonCount;
        
        CGFloat platformButtonHorizontalMargin;
        CGRect frame;
        platformButtonHorizontalMargin = (SCREEN_WIDTH - 30 -4 * 65) / 3.0f;
        frame = CGRectMake(15 + 65 * buttonModel.xPoint + platformButtonHorizontalMargin * buttonModel.xPoint, 30 + 30 * buttonModel.yPoint + 10 * buttonModel.yPoint, 65, 30);
        
        BDBButtonForSift *button = [BDBButtonForSift buttonWithTitle:buttonModel.title  isSelected:buttonModel.isSelected frame:frame];
        __weak BDBButtonForSift *tmpButton = button;
        __weak typeof(self) thisInstance = self;
        [tmpButton handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
            if(!tmpButton.isSelected){
                
                tmpButton.isSelected = YES;
                [thisInstance.selectedFilterArray addObject:button];
            }
           
            

            for (BDBSujectP2PListModel *model in _platformArray) {
                
                if([model.PlatformName isEqualToString:[tmpButton titleForState:UIControlStateNormal]]){
                    
                    [thisInstance.selectedPlatformArray addObject:model.PlatFormID];
                    
                    [_btnDelegate gainMoreBtnTagAction:[model.PlatFormID integerValue]];
                    
                    
                    _isChangeWhite = YES;
                    break;
                    
                    
                }
            }
        }];
        [aView addSubview:button];
        
        hButtonCount ++;
        
        if(hButtonCount == 4){
            
            vButtonCount += 1;
            
            hButtonCount = 0;
        }
        
    }
    
}




@end
