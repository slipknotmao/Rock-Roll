//
//  RRYTabBarController.m
//  RockRollYouth
//
//  Created by jd.huaxiaochun on 16/8/30.
//  Copyright © 2016年 slipknot. All rights reserved.
//

#import "RRYTabBarController.h"
#import "RRYNavigationController.h"
#import "RRYRockRollViewController.h"
#import "RRYDiscoverViewController.h"
#import "RRYRockRollHistoryViewController.h"
#import "RRYMyRockViewController.h"

static const NSInteger kTabCount = 4;

typedef NS_OPTIONS(NSInteger, RRYTabBarControllerTag) {
    RRYTabBarControllerTag_RockRoll,
    RRYTabBarControllerTag_Discover,
    RRYTabBarControllerTag_RockRollHistory,
    RRYTabBarControllerTag_MyRock
};

@interface RRYTabBarController ()

@end

@implementation RRYTabBarController


- (instancetype)init{
    self = [super init];
    if (self) {
        [self configViewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configViewControllers{
    RRYNavigationController *navigationController;
    NSMutableArray <__kindof UIViewController *> *viewControllers = [[NSMutableArray alloc] initWithCapacity:kTabCount];
    for (int i = 0 ; i < kTabCount; i++) {
        switch (i) {
            case RRYTabBarControllerTag_RockRoll:
            {
                RRYRockRollViewController *rockRollViewController = [[RRYRockRollViewController alloc] initWithNibName:nil bundle:nil];
                navigationController = [[RRYNavigationController alloc] initWithRootViewController:rockRollViewController];
                navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"摇滚" image:nil selectedImage:nil];
                [navigationController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:13.f], NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
                [navigationController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:13.f], NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
                
            }
                break;
            case RRYTabBarControllerTag_Discover:
            {
                RRYDiscoverViewController *discoverViewController = [[RRYDiscoverViewController alloc] initWithNibName:nil bundle:nil];
                navigationController = [[RRYNavigationController alloc] initWithRootViewController:discoverViewController];
                navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:nil selectedImage:nil];
                [navigationController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:13.f], NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
                [navigationController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:13.f], NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
            }
                break;
            case RRYTabBarControllerTag_RockRollHistory:
            {
                RRYRockRollHistoryViewController *rockRollHistoryViewController = [[RRYRockRollHistoryViewController alloc] initWithNibName:nil bundle:nil];
                navigationController = [[RRYNavigationController alloc] initWithRootViewController:rockRollHistoryViewController];
                navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"摇滚史" image:nil selectedImage:nil];
                [navigationController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:13.f], NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
                [navigationController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:13.f], NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
            }
                break;
            case RRYTabBarControllerTag_MyRock:
            {
                RRYMyRockViewController *myRockViewController = [[RRYMyRockViewController alloc] initWithNibName:nil bundle:nil];
                navigationController = [[RRYNavigationController alloc] initWithRootViewController:myRockViewController];
                navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:nil selectedImage:nil];
                [navigationController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:13.f], NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
                [navigationController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:13.f], NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
            }
                break;
                
            default:
                break;
        }
        [viewControllers addObject:navigationController];
    }
    [self setViewControllers:viewControllers];
}

@end
