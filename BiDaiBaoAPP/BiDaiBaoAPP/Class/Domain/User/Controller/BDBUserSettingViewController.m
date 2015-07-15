//
//  BDBSettingViewController.m
//  
//
//  Created by Imcore.olddog.cn on 15/6/19.
//
//

#import "BDBUserSettingViewController.h"
#import "BDBUserConnectUsViewController.h"

@interface BDBUserSettingViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginOutButton;
@property (weak, nonatomic) IBOutlet UILabel *APPcache;

//获取缓存的数据

@end

@implementation BDBUserSettingViewController

- (instancetype)init{

    if (self = [super init]) {
        self.title = @"设置";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
//异步线程进行清理缓存
- (IBAction)BDBClearn:(UITapGestureRecognizer *)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"是否清除缓存？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消",nil];
    alertView.tag = 1;
    alertView.backgroundColor = [UIColor blackColor];
    alertView.tintColor = [UIColor blueColor];
    [alertView show];
    
    
    
}

-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
    
}
- (IBAction)connectUS:(UITapGestureRecognizer *)sender {
    BDBUserConnectUsViewController *UserConnectUsViewController = [[BDBUserConnectUsViewController alloc]init];
    [self.navigationController pushViewController:UserConnectUsViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0f green:240 / 255.0f blue:240 / 255.0f alpha:1.0f];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    //调用返回缓存大小的方法
    [self returnfilePathM];

    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutButtonClickedAction:(UIButton *)button {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"你确定退出当前账号？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"关闭",nil];
    alertView.tag = 2;
    alertView.backgroundColor = [UIColor blackColor];
    alertView.tintColor = [UIColor blueColor];
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        switch (buttonIndex) {
                
            case 0:{
                //读书偏好设置中的账户和密码值
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *defaultsUID = [defaults objectForKey:@"UID"];
                NSString *defaultsPSW = [defaults objectForKey:@"PSW"];
                //判断账户如果已经为nil，则提示还没有登录
                if ([defaults objectForKey:@"UID"] == nil){
                    UILabel * dengruLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
                    dengruLabel.text = @"亲你还没有登录呢！";
                    dengruLabel.textColor = [UIColor whiteColor];
                    dengruLabel.backgroundColor = [UIColor grayColor];
                    dengruLabel.font = [UIFont fontWithName:@"Arial" size:15];
                    dengruLabel.textAlignment = NSTextAlignmentCenter;
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:dengruLabel];
                    [self performSelector:@selector(removedengruchenggong:) withObject:dengruLabel afterDelay:1];
                }
                //如果账户不为空执行退出登录语句
                else if ([defaults objectForKey:@"UID"] != nil){
                    
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    
                    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetLogout"];
                    
                    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
                    
                    parameterDict[@"UID"] = defaultsUID;
                    parameterDict[@"UserType"] = @"0";
                    parameterDict[@"PSW"] = defaultsPSW;
                    parameterDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
                    parameterDict[@"Device"] = @"0";
                    
                    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        if ([responseObject[@"Result"] isEqualToString:@"0"]) {
                            
                            //删除本地数据
                            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                            NSDictionary * dict = [defaults dictionaryRepresentation];
                            for (id key in dict) {
                                [defaults removeObjectForKey:key];
                            }
                            [defaults synchronize];
                            
                            
                            UILabel * dengruLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 70, self.view.center.y, 150, 21)];
                            dengruLabel.text = @"退出登入";
                            dengruLabel.textColor = [UIColor whiteColor];
                            dengruLabel.backgroundColor = [UIColor grayColor];
                            dengruLabel.font = [UIFont fontWithName:@"Arial" size:15];
                            dengruLabel.textAlignment = NSTextAlignmentCenter;
                            
                            [[UIApplication sharedApplication].keyWindow addSubview:dengruLabel];
                            [self performSelector:@selector(removedengruchenggong:) withObject:dengruLabel afterDelay:1];
                            if ([defaults objectForKey:@"UID"] == nil) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        }
                        
                    }
                     
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"%@",error);
                              
                          }];
                    
                }
                
                break;
            }
                
            case 1:{
                [alertView removeFromSuperview];
                break;
            }
            default:
                break;
        }

        
    }
    else if (alertView.tag == 1 ){
    
        switch (buttonIndex) {
            case 0:{
                //异步线程清理缓存
                dispatch_async(
                               dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                               , ^{
                                   NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                   
                                   NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                                   NSLog(@"files :%lu",(unsigned long)[files count]);
                                   for (NSString *p in files) {
                                       NSError *error;
                                       NSString *path = [cachPath stringByAppendingPathComponent:p];
                                       if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                           [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                                       }
                                   }
                                });
                _APPcache.text = @"0.00M";
                break;
            
            }
            case 1:{
                [alertView removeFromSuperview];
                break;
                
            }
                
            default:
                break;
        }
    
    
    }
    
}

-(void)removedengruchenggong:(UILabel *)laber{
    
    [laber removeFromSuperview];
    
   
}


////遍历缓存返回缓存的大小
//- (float ) folderSizeAtPath:(NSString*) folderPath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if (![manager fileExistsAtPath:folderPath]) return 0;
//    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
//    NSString* fileName;
//    long long folderSize = 0;
//    while ((fileName = [childFilesEnumerator nextObject]) != nil){
//        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//        folderSize += [self fileSizeAtPath:fileAbsolutePath];
//        NSLog(@"flodersize%f",folderSize/(1024.0*1024.0));
//    }
//    return folderSize/(1024.0*1024.0);
//}
//
//
//- (long long) fileSizeAtPath:(NSString*) filePath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:filePath]){
//        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
//    }
//    return 0;
//}
-(void)returnfilePathM{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSLog(@"%@", cachesDir);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsAtPath:cachesDir];
    int theFileSize = 0;
    for (NSString *file in files) {
        //清除caches下所有缓存。需要拼接出完整路径//
        //        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", cachesDir, file] error:nil];
        //拼接出完整路径，通过路径取出每个文件的属性字典
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@", cachesDir, file] error:nil];
        //从属性字典里取出文件大小
        theFileSize += [[attributes objectForKey:NSFileSize] intValue];
        //NSLog(@"%d", theFileSize);
    }
    //NSLog(@"%fKB", theFileSize / 1024.0);
    NSString *strFloat = [NSString stringWithFormat:@"%.2f",theFileSize/1024.0f/1024.0f];
    
    _APPcache.text = [strFloat stringByAppendingString:@"M"];

}

@end
