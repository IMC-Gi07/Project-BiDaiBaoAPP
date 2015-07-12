//
//  BDBMessageTableViewCell.m
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/17.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBMessageTableViewCell.h"
#import "BBCyclingLabel.h"

@interface BDBMessageTableViewCell ()

@property(nonatomic,weak) BBCyclingLabel *cyclingLabel;

@property(nonatomic,assign) NSUInteger displayingTextIndex;

/**
 *	初始化滚动标签
 */
- (void)initCyclingLabel;

/**
 *	切换文字
 */
- (void)changeDisplayingText;

@end

@implementation BDBMessageTableViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self initCyclingLabel];
	}
	return self;
}

- (void)initCyclingLabel {
	BBCyclingLabel *cyclingLabel = [[BBCyclingLabel alloc] init];
	cyclingLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30.0f);
	
	cyclingLabel.backgroundColor = [UIColor clearColor];
	
	cyclingLabel.textColor = [UIColor whiteColor];
	cyclingLabel.font = UIFontWithSize(12);
	cyclingLabel.textAlignment = NSTextAlignmentCenter;
	
	cyclingLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
	cyclingLabel.transitionDuration = 0.3f;
	
	[self.contentView addSubview:cyclingLabel];
	self.cyclingLabel = cyclingLabel;
}

#pragma mark - Getters And Setters Methods
- (void)setTexts:(NSArray *)texts {
	if (_texts != texts) {
		_texts = texts;

		self.displayingTextIndex = 0;
		[_cyclingLabel setText:_texts[_displayingTextIndex] animated:NO];
		

		//切换显示文字
		[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeDisplayingText) userInfo:nil repeats:YES];
	}
}

#pragma mark - Public Methods
- (NSString *)displayingText {
	return _texts[_displayingTextIndex];
}

#pragma mark - Private Methods
- (void)changeDisplayingText {
	self.displayingTextIndex ++;
	if (_displayingTextIndex >= _texts.count) {
		self.displayingTextIndex = 0;
	}
	
	_cyclingLabel.text = _texts[_displayingTextIndex];
}


@end
