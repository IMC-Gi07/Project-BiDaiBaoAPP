//
//  BDBSettingViewController.m
//  
//
//  Created by Imcore.olddog.cn on 15/6/19.
//
//

#import "BDBUserSettingViewController.h"

@interface BDBUserSettingViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginOutButton;

@end

@implementation BDBUserSettingViewController

- (instancetype)init{

    if (self = [super init]) {
        self.title = @"设置";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0f green:240 / 255.0f blue:240 / 255.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutButtonClickedAction:(UIButton *)button {
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"你确定退出当前账号？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"关闭",nil];
    alertView.backgroundColor = [UIColor blackColor];
    alertView.tintColor = [UIColor blueColor];
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            //拍照
        case 0:{
            [self logOut];
            
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            //从相册选择
        case 1:{
            [alertView removeFromSuperview];
            break;
        }
        default:
            break;
    }

    


}
-(void)removedengruchenggong:(UILabel *)laber{
    
    [laber removeFromSuperview];
}


- (void)logOut{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultsUID = [defaults objectForKey:@"UID"];
    NSString *defaultsPSW = [defaults objectForKey:@"PSW"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetLogout"];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    
    parameterDict[@"UID"] = defaultsUID;
    parameterDict[@"UserType"] = @"0";
    parameterDict[@"PSW"] = defaultsPSW;
    parameterDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameterDict[@"Device"] = @"0";
    
    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [defaults dictionaryRepresentation];
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
    }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
    
}


@end
