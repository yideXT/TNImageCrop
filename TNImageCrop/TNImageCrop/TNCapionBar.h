//
//  TNCapionBar.h
//  文字提示框
//
//  Created by 罗义德 on 15/10/23.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 提示条 */

@interface TNCapionBar : UIView
/** 屏幕顶部弹出的提示条 showSame:是否连续显示文字相同的提示条 */
+ (void)showScreenTopCapionBarInView:(UIView *)view CapionTitle:(NSString *)title isShowSame:(BOOL)showSame;

/** 屏幕底部弹出的提示条 showSame:是否连续显示文字相同的提示条 */
+ (void)showScreenBottomCapionBarInView:(UIView *)view CapionTitle:(NSString *)title isShowSame:(BOOL)showSame;

@end
