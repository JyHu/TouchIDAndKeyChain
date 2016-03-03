//
//  HomePageViewController.m
//  LoginWithTouchID
//
//  Created by 胡金友 on 16/3/2.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "HomePageViewController.h"
#import "KeyChainHandler.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Home page";
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.center = self.view.center;
    label.text = @"恭喜你登入首页成功";
    [self.view addSubview:label];
    label.numberOfLines = 0;
    
    [[KeyChainHandler shareHandler] saveObject:@"hello world" forService:@"test.keychain"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
