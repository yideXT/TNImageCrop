//
//  TNCapionBar.h
//  文字提示框
//
//  Created by 罗义德 on 15/10/23.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 提示条类型 */
typedef enum {
    /** 网络错误提示 */
    TNCapionBarTypeNetWorkError,
    /** 没有更多数据 */
    TNCapionBarTypeNotMoreData,
    /** 没有数据 */
    TNCapionBarTypeNotData,
    /** 请输入您的登录账号! */
    TNCapionBarTypeInputAccount,
    /** 请输入您的登录密码! */
    TNCapionBarTypeInputPassword
    
}TNCapionBarType;

/** 提示条 */

@interface TNCapionBar : UIView
/** 屏幕顶部弹出的提示条 */
+ (void)showScreenTopCapionBarInView:(UIView *)view CapionTitle:(NSString *)title;
/** 屏幕顶部弹出的提示条，不显示重复的信息 */
+ (void)showScreenTopCapionBarInView:(UIView *)view CapionBarType:(TNCapionBarType)type;

/** 屏幕底部弹出的提示条 */
+ (void)showScreenBottomCapionBarInView:(UIView *)view CapionTitle:(NSString *)title;
/** 屏幕底部弹出的提示条，不显示重复的信息 */
+ (void)showScreenBottomCapionBarInView:(UIView *)view CapionBarType:(TNCapionBarType)type;

@end
