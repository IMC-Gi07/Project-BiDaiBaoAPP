//
//  AppDelegate.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/5.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "AppDelegate.h"
#import "BDBBaseViewController.h"
#import "BDBFeatureViewController.h"

static NSString *const kVersionCodeKey = @"VersionCode";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	self.window.backgroundColor = [UIColor whiteColor];
	
	[self.window makeKeyAndVisible];

	//获取旧版本号
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *lastVersionCode = [userDefaults stringForKey:kVersionCodeKey];
	
	//新版本号
	NSString *currentVersionCode = MAIN_BUNDLE.infoDictionary[@"CFBundleVersion"];
	
	//如果版本号不匹配，则跳转到引导页
	UIViewController *rootViewController = nil;
	if (![lastVersionCode isEqualToString:currentVersionCode]) {
		rootViewController = [[UIStoryboard storyboardWithName:@"Feature" bundle:nil] instantiateInitialViewController];
		//传向引导页后，存入当前Version
		[userDefaults setObject:currentVersionCode forKey:kVersionCodeKey];
		[userDefaults synchronize];
	}else {
		rootViewController = [[BDBBaseViewController alloc] init];
	}
	
	self.window.rootViewController = rootViewController;

	return YES;
}


@end
