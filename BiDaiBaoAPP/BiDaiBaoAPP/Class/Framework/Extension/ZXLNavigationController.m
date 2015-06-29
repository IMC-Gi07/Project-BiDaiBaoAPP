//
//  ZXLNavigationController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "ZXLNavigationController.h"
#import "ZXLNavigationBar.h"


@interface ZXLNavigationController () <UINavigationControllerDelegate>

- (void)popViewController;

@end

@implementation ZXLNavigationController

- (instancetype)initWithCoder:(NSCoder *)coder{
	if (self = [super initWithCoder:coder]) {
		//KVC
		[self setValue:[[ZXLNavigationBar alloc] init] forKey:@"navigationBar"];
		
		self.delegate = self;
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	//if (self.viewControllers.count > 0) {
//		viewController.hidesBottomBarWhenPushed = YES;
//		
//		__weak typeof(self) thisInstance = self;
//		viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:UIImageWithName(@"navigationbar_back") highlightedImage:UIImageWithName(@"navigationbar_back") clickedHandler:^{
//			[thisInstance popViewControllerAnimated:YES];
//		}];
	//}

	//要在压栈之前设置
	[super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

	if (navigationController.viewControllers.count > 1) {
	
		//返回按钮(默认返回)
		UIImage *backBarButtonItemImage = [UIImageWithName(@"navigationbar_back") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backBarButtonItemImage style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
	}
	
}

#pragma mark - Private Methods
- (void)popViewController {
	[self popViewControllerAnimated:YES];
}


@end
