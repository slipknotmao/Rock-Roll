//
//  RRYBaseViewController.h
//  RockRollYouth
//
//  Created by jd.huaxiaochun on 16/8/30.
//  Copyright © 2016年 slipknot. All rights reserved.
//  视图控制器基类

#import <UIKit/UIKit.h>

@interface RRYBaseViewController : UIViewController

#pragma mark - Navigation

- (void)addNavigationItemBackButton;

- (void)addNavigationItemLeftButtonWithTitle:(NSString *)title;

- (void)addNavigationItemLeftButtonWithImageName:(NSString *)imageName
                            HighlightedImageName:(NSString *)highlightedImageName;

- (void)addNavigationItemRightButtonWithTitle:(NSString *)title
                                       target:(id)target selector:(SEL)selector;

- (void)addNavigationItemRightButtonWithImageName:(NSString *)imageName
                             HighlightedImageName:(NSString *)highlightedImageName
                                           target:(id)target
                                         selector:(SEL)selector;

- (void)addNavigationTitleView:(UIView *)titleView;

@end
