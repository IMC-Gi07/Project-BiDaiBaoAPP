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

/**
 *  应用启动时，下载平台数据到数据库缓存中(全局使用)
 */
- (void)downloadP2PPlatforms;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	self.window = [[UIWindow alloc] init];
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	
	//推迟设置window的frame
	self.window.frame = [[UIScreen mainScreen] bounds];

	//获取旧版本号
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *lastVersionCode = [userDefaults stringForKey:kVersionCodeKey];
	
	//新版本号
	NSString *currentVersionCode = MAIN_BUNDLE.infoDictionary[@"CFBundleVersion"];
	
	//根控制器
	UIViewController *rootViewController = nil;
	////如果版本号不匹配，则跳转到引导页
	if (![lastVersionCode isEqualToString:currentVersionCode]) {
		rootViewController = [[UIStoryboard storyboardWithName:@"Feature" bundle:nil] instantiateInitialViewController];
		//传向引导页后，存入当前Version
		[userDefaults setObject:currentVersionCode forKey:kVersionCodeKey];
		[userDefaults synchronize];
	}else {
		rootViewController = [[BDBBaseViewController alloc] init];
	}
	
	AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
	[networkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		switch (status) {
			case AFNetworkReachabilityStatusNotReachable: {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alertView show];
				break;
			}
			default: {
				//开启新线程，加载平台数据
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
					[self downloadP2PPlatforms];
				});
				break;
			}
    			
		}
	}];
	
	[networkReachabilityManager startMonitoring];
	
	//设置根控制器
	self.window.rootViewController = rootViewController;
	
	return YES;
}

#pragma mark - Private Methods
- (void)downloadP2PPlatforms {
	//打开数据库，创建平台数据表
	NSString *dbFilePath = [CACHE_DIRECTORY stringByAppendingPathComponent:BDBGlobal_CacheDatabaseName];
	
	FMDatabaseQueue *databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
	if(databaseQueue){
		//创建平台数据表
		[databaseQueue inDatabase:^(FMDatabase *db) {
			NSString *sql = @"DROP TABLE IF EXISTS t_platform";
			[db executeUpdate:sql];
		
			sql = @"CREATE TABLE IF NOT EXISTS t_platform(rowid INTEGER PRIMARY KEY AUTOINCREMENT,pid TEXT,name TEXT,website TEXT,deal TEXT,popularity TEXT,earnings REAL)";
			[db executeUpdate:sql];
		}];
		
		//从服务器请求平台数据
		AFHTTPRequestOperationManager *httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
		
		NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetP2PList"];
		
		NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
		parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
		parameters[@"Device"] = @"0";
		parameters[@"Type"] = @"0";
		
		[httpRequestOperationManager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
			BDBGetP2PListResponseModel *responseModel = [BDBGetP2PListResponseModel objectWithKeyValues:responseObject];
			
			NSArray *platformModels = responseModel.P2PList;
			
			//遍历每个模型，插入数据表(afnetworking的success块是在主线程中运行)
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[databaseQueue inDatabase:^(FMDatabase *db) {
					[platformModels enumerateObjectsUsingBlock:^(BDBP2PPlatformModel *platformModel, NSUInteger idx, BOOL *stop) {
						NSString *sql = @"INSERT INTO t_platform(pid,name,website,deal,popularity,earnings) VALUES(:pid,:name,:website,:deal,:popularity,:earnings)";
						
						NSMutableDictionary *sqlParameters = [NSMutableDictionary dictionary];
						sqlParameters[@"pid"] = platformModel.PlatFormID;
						sqlParameters[@"name"] = platformModel.PlatformName;
						sqlParameters[@"website"] = platformModel.WebSite;
						sqlParameters[@"deal"] = platformModel.Deal;
						sqlParameters[@"popularity"] = platformModel.Popularity;
						sqlParameters[@"earnings"] = platformModel.Earnings;
						
						[db executeUpdate:sql withParameterDictionary:sqlParameters];
						
					}];
				}];
			});
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
	}
	
	
	
}














@end
