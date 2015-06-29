//
//  ZXLNavigationBar.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "ZXLNavigationBar.h"

@interface ZXLNavigationBar ()

@property (nonatomic,strong) CALayer *colorLayer;

@end

@implementation ZXLNavigationBar

static CGFloat const kDefaultColorLayerOpacity = 0.4f;
static CGFloat const kSpaceToCoverStatusBars = 20.0f;

+ (void)initialize {
	//设置导航栏的样式
	ZXLNavigationBar *navigationBar = [ZXLNavigationBar appearance];
	
	//设置导航栏的颜色
	[navigationBar setBarTintColor:UIColorWithRGB(74,168,232)];
	
	//设置导航栏的标题样式
	NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
	//颜色
	titleTextAttributes[NSForegroundColorAttributeName] = UIColorWithName(white);
	//字体
	titleTextAttributes[NSFontAttributeName] = UIFontWithSize(18.0f);
	
	[navigationBar setTitleTextAttributes:titleTextAttributes];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
	[super setBarTintColor:barTintColor];
	
	if (self.colorLayer == nil) {
		self.colorLayer = [CALayer layer];
		self.colorLayer.opacity = kDefaultColorLayerOpacity;
		[self.layer addSublayer:self.colorLayer];
	}
	
	CGFloat red, green, blue, alpha;
	[barTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
	
	CGFloat opacity = kDefaultColorLayerOpacity;
	
	CGFloat minVal = MIN(MIN(red, green), blue);
	
	if ([self convertValue:minVal withOpacity:opacity] < 0) {
		opacity = [self minOpacityForValue:minVal];
	}
	
	self.colorLayer.opacity = opacity;
	
	red = [self convertValue:red withOpacity:opacity];
	green = [self convertValue:green withOpacity:opacity];
	blue = [self convertValue:blue withOpacity:opacity];
	
	red = MAX(MIN(1.0, red), 0);
	green = MAX(MIN(1.0, green), 0);
	blue = MAX(MIN(1.0, blue), 0);
	
	self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
}

- (CGFloat)minOpacityForValue:(CGFloat)value{
	return (0.4 - 0.4 * value) / (0.6 * value + 0.4);
}

- (CGFloat)convertValue:(CGFloat)value withOpacity:(CGFloat)opacity{
	return 0.4 * value / opacity + 0.6 * value - 0.4 / opacity + 0.4;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	if (self.colorLayer != nil) {
		self.colorLayer.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);
		
		[self.layer insertSublayer:self.colorLayer atIndex:1];
	}
}

- (void)displayColorLayer:(BOOL)display {
	self.colorLayer.hidden = !display;
}

@end
