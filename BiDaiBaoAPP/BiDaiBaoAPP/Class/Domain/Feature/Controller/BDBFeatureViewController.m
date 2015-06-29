//
//  BDBFeatureViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/16.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBFeatureViewController.h"
#import "BDBBaseViewController.h"

static const NSUInteger kFeaturePageCount = 4;

@interface BDBFeatureViewController () <UIScrollViewDelegate>

/**
 *  特性页面滚动
 */
@property (weak, nonatomic) IBOutlet UIScrollView *featurePageScrollView;

/**
 *  跳过按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *skipToIndexButton;

/**
 *  页面指示器
 */
@property (weak, nonatomic) IBOutlet UIPageControl *featurePageControl;

/**
 *  初始化pageControl
 */
- (void)initFeaturePageControl;

/**
 *  初始化滚动视图
 */
- (void)initFeaturePageScrollView;

@end

@implementation BDBFeatureViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self initFeaturePageControl];
    
	[self initFeaturePageScrollView];
	
	//点击跳过，转向首页
	[_skipToIndexButton handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
		[UIApplication sharedApplication].keyWindow.rootViewController = [[BDBBaseViewController alloc] init];
	}];
}




#pragma mark - Private Methods
- (void)initFeaturePageControl {
	_featurePageControl.numberOfPages = kFeaturePageCount;
}

- (void)initFeaturePageScrollView {
	/**
     *	页面0
	 */
	UIImageView *featurePageView_0 = [[UIImageView alloc] init];
	featurePageView_0.image = [UIImage imageNamed:@"app_feature_0"];
	[_featurePageScrollView addSubview:featurePageView_0];
	
	//加约束
	featurePageView_0.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSLayoutConstraint *constraint_featurePageView_0_width = [NSLayoutConstraint constraintWithItem:featurePageView_0 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_featurePageScrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
	
	NSLayoutConstraint *constraint_featurePageView_0_height = [NSLayoutConstraint constraintWithItem:featurePageView_0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_featurePageScrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
	
	NSLayoutConstraint *constraint_featurePageView_0_top = [NSLayoutConstraint constraintWithItem:featurePageView_0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_featurePageScrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
	
	NSLayoutConstraint *constraint_featurePageView_0_leading = [NSLayoutConstraint constraintWithItem:featurePageView_0 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_featurePageScrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
	
	[_featurePageScrollView addConstraints:@[constraint_featurePageView_0_width,constraint_featurePageView_0_height,constraint_featurePageView_0_top,constraint_featurePageView_0_leading]];
	
	
	/**
	 *	页面1
	 */
	UIImageView *featurePageView_1 = [[UIImageView alloc] init];
	featurePageView_1.image = [UIImage imageNamed:@"app_feature_1"];
	[_featurePageScrollView addSubview:featurePageView_1];
	
	featurePageView_1.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSLayoutConstraint *constraint_featurePageView_1_width = [NSLayoutConstraint constraintWithItem:featurePageView_1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:featurePageView_0 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
	
	NSLayoutConstraint *constraint_featurePageView_1_height = [NSLayoutConstraint constraintWithItem:featurePageView_1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:featurePageView_0 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
	
	[_featurePageScrollView addConstraints:@[constraint_featurePageView_1_width,constraint_featurePageView_1_height]];
	
	/**
	*	页面2
	*/
	UIImageView *featurePageView_2 = [[UIImageView alloc] init];
	featurePageView_2.image = [UIImage imageNamed:@"app_feature_2"];
	[_featurePageScrollView addSubview:featurePageView_2];
	
	featurePageView_2.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSLayoutConstraint *constraint_featurePageView_2_width = [NSLayoutConstraint constraintWithItem:featurePageView_2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:featurePageView_0 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
	
	NSLayoutConstraint *constraint_featurePageView_2_height = [NSLayoutConstraint constraintWithItem:featurePageView_2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:featurePageView_0 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
	
	[_featurePageScrollView addConstraints:@[constraint_featurePageView_2_width,constraint_featurePageView_2_height]];
		
	/**
	 *	页面3
	 */
	UIImageView *featurePageView_3 = [[UIImageView alloc] init];
	featurePageView_3.image = [UIImage imageNamed:@"app_feature_3"];
	featurePageView_3.userInteractionEnabled = YES;
	
	UIButton *startExperienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[startExperienceBtn setImage:[UIImage imageNamed:@"feature_exp_btn"] forState:UIControlStateNormal];
	//处理点击事件
	[startExperienceBtn handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
		[UIApplication sharedApplication].keyWindow.rootViewController = [[BDBBaseViewController alloc] init];
	}];
	[featurePageView_3 addSubview:startExperienceBtn];
	
	[_featurePageScrollView addSubview:featurePageView_3];
	
	featurePageView_3.translatesAutoresizingMaskIntoConstraints = NO;
	
	//按钮约束
	startExperienceBtn.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSLayoutConstraint *constraint_startExperienceBtn_width = [NSLayoutConstraint constraintWithItem:startExperienceBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:startExperienceBtn.currentImage.size.width];
	
	NSLayoutConstraint *constraint_startExperienceBtn_height = [NSLayoutConstraint constraintWithItem:startExperienceBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:startExperienceBtn.currentImage.size.height];
	
	[startExperienceBtn addConstraints:@[constraint_startExperienceBtn_width,constraint_startExperienceBtn_height]];
	
	NSLayoutConstraint *constraint_startExperienceBtn_centerX = [NSLayoutConstraint constraintWithItem:startExperienceBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem: featurePageView_3 attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
	
	NSLayoutConstraint *constraint_startExperienceBtn_bottom = [NSLayoutConstraint constraintWithItem:startExperienceBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: featurePageView_3 attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-42];
	
	[featurePageView_3 addConstraints:@[constraint_startExperienceBtn_centerX,constraint_startExperienceBtn_bottom]];
	
	
	//页面约束
	NSLayoutConstraint *constraint_featurePageView_3_width = [NSLayoutConstraint constraintWithItem:featurePageView_3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:featurePageView_0 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
	
	NSLayoutConstraint *constraint_featurePageView_3_height = [NSLayoutConstraint constraintWithItem:featurePageView_3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:featurePageView_0 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
	
	[_featurePageScrollView addConstraints:@[constraint_featurePageView_3_width,constraint_featurePageView_3_height]];

	
	//综合约束
	NSString *hVisualFormat = @"H:|[featurePageView_0][featurePageView_1][featurePageView_2][featurePageView_3]|";
	
	NSMutableDictionary *viewsDict = [NSMutableDictionary dictionary];
	viewsDict[@"featurePageView_0"] = featurePageView_0;
	viewsDict[@"featurePageView_1"] = featurePageView_1;
	viewsDict[@"featurePageView_2"] = featurePageView_2;
	viewsDict[@"featurePageView_3"] = featurePageView_3;
	
	NSArray *constraint_featurePageScrollView = [NSLayoutConstraint constraintsWithVisualFormat:hVisualFormat options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDict];
	[_featurePageScrollView addConstraints:constraint_featurePageScrollView];
	
}

#pragma mark - UIScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat scrollOffsetX = scrollView.contentOffset.x;

	NSUInteger currentPageIndex = round(scrollOffsetX/scrollView.width);
	_featurePageControl.currentPage = currentPageIndex;
	
	//隐藏pageControl
	if (currentPageIndex == (kFeaturePageCount - 1)) {
		_featurePageControl.hidden = YES;
		_skipToIndexButton.hidden = YES;
	}else {
		_featurePageControl.hidden = NO;
		_skipToIndexButton.hidden = NO;
	}	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
