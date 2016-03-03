//
//  NavigationViewController.m
//  LoginWithTouchID
//
//  Created by 胡金友 on 16/3/2.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "NavigationViewController.h"
#import "HomePageViewController.h"
#import <LocalAuthentication/LAContext.h>

@interface NavigationViewController ()

@property (retain, nonatomic) UITextField *passwordTextView;

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"password_key"] != nil)
    {
        [self loginWithTouchID];
    }
    else
    {
        [self initUI];
    }
}

- (void)loginWithTouchID
{
    if ([self canEvaluatePolicy])
    {
        [self evaluatePolicy];
    }
    else
    {
        [self initUI];
    }
}

- (void)initUI
{
    self.passwordTextView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    self.passwordTextView.center = CGPointMake(self.view.center.x, 120);
    self.passwordTextView.textAlignment = NSTextAlignmentCenter;
    self.passwordTextView.layer.masksToBounds = YES;
    self.passwordTextView.layer.borderWidth = 1;
    self.passwordTextView.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.4].CGColor;
    [self.view addSubview:self.passwordTextView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.passwordTextView.bounds;
    button.center = CGPointMake(self.view.center.x, 180);
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"Login in" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *reTIDButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reTIDButton.frame = button.bounds;
    reTIDButton.center = CGPointMake(self.view.center.x, 240);
    reTIDButton.backgroundColor = [UIColor redColor];
    [reTIDButton setTitle:@"Reuse touchID" forState:UIControlStateNormal];
    [reTIDButton addTarget:self action:@selector(reloginWithTouchID) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reTIDButton];
}

- (void)reloginWithTouchID
{
    [self loginWithTouchID];
}

- (void)login
{
    NSString *pwdkey = @"password_key";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *pwd = [userDefaults objectForKey:pwdkey];
    
    if (self.passwordTextView.text.length > 4)
    {
        if (pwd == nil)
        {
            [userDefaults setObject:self.passwordTextView.text forKey:pwdkey];
            
            [self pageturn];
            
            return;
        }
        
        if ([pwd isEqualToString:self.passwordTextView.text])
        {
            [self pageturn];
        }
        else
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[[UIAlertView alloc] initWithTitle:@"密码登陆结果" message:@"输入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
#pragma clang diagnostic pop
        }
    }
    
    [userDefaults synchronize];
}

- (void)pageturn
{
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[HomePageViewController alloc] init]] animated:YES completion:nil];
}

#pragma mark - help methods

- (BOOL)canEvaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
}

- (void)evaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    __block NSString *message;
    
//    context.localizedFallbackTitle = @"Enter PIN";
    
    
    // reply的block中实在异步线程中，需要抛到主线程中去做事。
    
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"使用TouchID进入APP首页" reply:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"%@  %d", [NSThread currentThread], [NSThread isMainThread]);
        
        if (success)
        {
            message = @"验证成功";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self pageturn];
            });
        }
        else
        {
            message = [NSString stringWithFormat:@"验证失败 : %@", error.localizedDescription];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initUI];
            });
        }
        
        NSLog(@"%@", message);
    }];
    
    
    /*
     
     登陆的时候有 3 2 的规律
     
     如果连续失败3次就会取消touchID登陆，如果选择继续的话，连续失败两次会退出touchID登陆，再次选择使用touchID的话，会提示输入手机密码。
     
     */
}

@end
