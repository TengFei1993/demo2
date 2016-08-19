//
//  ViewController.m
//  手势解锁
//
//  Created by yangxiaofei on 15/12/30.
//  Copyright (c) 2015年 yangxiaofei. All rights reserved.
//

#import "ViewController.h"
#import "LockView.h"

@interface ViewController () <LockViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置背景（大背景）
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    //自定义view，完成排版
    LockView *lockview = [[LockView alloc] init];
    CGFloat lockviewH = [UIScreen mainScreen].bounds.size.width;
    lockview.bounds = CGRectMake(0, 0, lockviewH, lockviewH);
    lockview.center = self.view.center;
    lockview.backgroundColor = [UIColor clearColor];
    lockview.delegate = self;
    
    //显示
    [self.view addSubview:lockview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) lockview:(LockView *)lockview andStr:(NSString *) string
{
//    NSLog(@"dddd");
    if ([string isEqualToString:@"03678"]) {
        [self  performSegueWithIdentifier:@"next" sender:nil];
    }
   
}
@end
