//
//  UIViewController+NavigationBarItem.h
//  1001
//
//  Created by 罗义德 on 15/7/14.
//  Copyright (c) 2015年 ChuXiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBarItem)

/** 导航栏左边按钮 */
- (void)createLeftItemWithImage:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag;
- (void)createLeftItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target selector:(SEL)sel tag:(NSInteger)tag;

/** 导航栏右边按钮 */
- (void)createRightItemWithImages:(NSArray *)imageNameArr target:(id)target selector:(SEL)sel tags:(NSArray *)tagArr;
- (UIButton *)createRightItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target selector:(SEL)sel tag:(NSInteger)tag;
- (UIButton *)createRightItemWithImage:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag;

@end
