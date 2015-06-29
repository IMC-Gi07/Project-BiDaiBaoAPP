//
//  BDBBaseViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/6.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBBaseViewController.h"

@interface BDBBaseViewController ()

/**
 *  应用所包含的模块
 */
@property(nonatomic,copy) NSArray *modules;

@end

@implementation BDBBaseViewController

+ (void)initialize {
	
}

/*
- (instancetype)initWithCoder:(NSCoder *)coder{
	if (self = [super initWithCoder:coder]) {
		self.modules = [NSArray arrayWithContentsOfFile:FilePathInBundleWithNameAndType(@"Modules", @"plist")];
	}
	return self;
}
*/

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.modules = [NSArray arrayWithContentsOfFile:FilePathInBundleWithNameAndType(@"Modules", @"plist")];

	NSMutableArray *moduleViewControllers = [NSMutableArray arrayWithCapacity:_modules.count];
	
	for (NSDictionary *module in _modules) {
		@autoreleasepool {
			UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:module[@"name"] bundle:nil];
			
			//普通icon
			UIImage *iconImage = [UIImageWithName(module[@"icon"]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
			//高亮icon
			UIImage *iconHighlightedImage = [UIImageWithName(module[@"icon_highlighted"]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
			
			UIViewController *moduleInitViewController = [storyBoard instantiateInitialViewController];
			moduleInitViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:module[@"title"] image:iconImage selectedImage:iconHighlightedImage];
			
			[moduleViewControllers addObject:moduleInitViewController];
		}
	}
	
	self.viewControllers = moduleViewControllers;
}

@end
