//
//  RRYNavigationController.m
//  RockRollYouth
//
//  Created by jd.huaxiaochun on 16/8/30.
//  Copyright © 2016年 slipknot. All rights reserved.
//

#import "RRYNavigationController.h"

@interface RRYNavigationController ()

@end

@implementation RRYNavigationController

/*!
 *  @brief 初始化导航样式
 */
- (void)initStyle{
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:16.f],
                                                 NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationBar setBarTintColor:[UIColor redColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
