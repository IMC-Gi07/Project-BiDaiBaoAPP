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
#import "BDBNoticeResponseModel.h"
#import "BDBNoticeModel.h"

static NSString *const kVersionCodeKey = @"VersionCode";

@interface AppDelegate () <UIAlertViewDelegate>

/**
 *  应用启动时，下载平台数据到数据库缓存中(全局使用)
 */
- (void)downloadP2PPlatforms;

/**
 *  界面显示时，请求公告数据
 */
- (void)requestNotices;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	self.window = [[UIWindow alloc] init];
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	//推迟设置window的frame，解决底部20个px空白
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
				UIAlertView *alertView = nil;
				if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
					alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法连接网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"网络设置",nil];
				}else {
					alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法连接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
				}
				
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
	
	/**
	 *	设置状态栏颜色
	 *  1、在info.plist中，将View controller-based status bar appearance设NO.
	 *  2、在app delegate中：
	 */ 
	if(SYSTEM_VERSION_GREATER_THAN(@"7.0")){
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	}
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[self requestNotices];
}

#pragma mark - Private Methods
- (void)requestNotices {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
	//GetNotice主机地址
	NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNotice"];
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	
	NSUserDefaults *userDfaults = [NSUserDefaults standardUserDefaults];
	
	NSString *UID = [userDfaults objectForKey:@"UID"];
	if (UID && ![UID isEqualToString:@""]) {
		requestParameters[@"UID"] = UID;
	}
	
	NSString *PSW = [userDfaults objectForKey:@"PSW"];
	if (PSW && ![PSW isEqualToString:@""]) {
		requestParameters[@"PSW"] = PSW;
	}
	
	requestParameters[@"UserType"] = @"0";
	requestParameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
	requestParameters[@"Device"] = @"0";
	requestParameters[@"PageIndex"] = @1;
	requestParameters[@"PageSize"] = @5;
	
	[manager POST:requestURL parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		BDBNoticeResponseModel *noticeResponseModel = [BDBNoticeResponseModel objectWithKeyValues:responseObject];
		
		NSArray *noticeModels = noticeResponseModel.NoticeList;
		if (noticeModels.count > 0) {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				NSString *dbFilePath = [CACHE_DIRECTORY stringByAppendingPathComponent:BDBGlobal_CacheDatabaseName];
				FMDatabase *database = [FMDatabase databaseWithPath:dbFilePath];
				if ([database open]) {
					NSString *sql = @"DROP TABLE IF EXISTS t_notice";
					[database executeUpdate:sql];
					
					sql = @"CREATE TABLE IF NOT EXISTS t_notice(rowid INTEGER PRIMARY KEY AUTOINCREMENT,newsid text,publisher text,dt text,title text,firstsection text,detailurl text,isread text)";
					[database executeUpdate:sql];
					
					[noticeModels enumerateObjectsUsingBlock:^(BDBNoticeModel *noticeModel, NSUInteger idx, BOOL *stop) {
						NSString *sql = @"INSERT INTO t_notice(newsid,publisher,dt,title,firstsection,detailurl,isread) VALUES(:newsid,:publisher,:dt,:title,:firstsection,:detailurl,:isread)";
						
						NSMutableDictionary *sqlParameters = [NSMutableDictionary dictionary];
						sqlParameters[@"newsid"] = noticeModel.NewsID;
						sqlParameters[@"publisher"] = noticeModel.Publisher;
						sqlParameters[@"dt"] = noticeModel.DT;
						sqlParameters[@"title"] = noticeModel.Title;
						sqlParameters[@"firstsection"] = noticeModel.FirstSection;
						sqlParameters[@"detailurl"] = noticeModel.DetailURL;
						sqlParameters[@"isread"] = noticeModel.IsRead;
						
						[database executeUpdate:sql withParameterDictionary:sqlParameters];
					}];
					
					[database close];
				}	
					
			});	
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}

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
		parameters[@"Type"] = @"1";
		
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

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		/**
		 *  网络设置
		 */
		case 1:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]; 
			break;
			
  		default:
			break;
	}
}










@end
