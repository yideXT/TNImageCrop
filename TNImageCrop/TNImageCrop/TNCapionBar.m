//
//  TNCapionBar.m
//  文字提示框
//
//  Created by 罗义德 on 15/10/23.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import "TNCapionBar.h"

/** 提示条的位置 */
typedef enum {
    TNCapionBarPlaceTop,
    TNCapionBarPlaceMiddle,
    TNCapionBarPlaceBottom
}TNCapionBarPlace;

/** 提示条停留的时间 */
CGFloat const CapionBarStayTime = 2.0;
/** 提示条出来的动画时长 */
CGFloat const CapionBarAnimationDuration = 0.3;
/** 显示顶部提示条数组 */
NSMutableArray *_topCapionBarArray;
/** 显示底部提示条数组 */
NSMutableArray *_bottomCapionBarArray;
/** 提示文字的数组 */
NSMutableArray *_titleArray;

@implementation TNCapionBar {
    //label
    UILabel *_titleLabel;
    //TNCapionBarType
    TNCapionBarType _capionBarType;
}
#pragma mark system method
- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        self.alpha = 0;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.cornerRadius = 6;
        _titleLabel.layer.masksToBounds = YES;
        
        CGSize size = [_titleLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleLabel.font} context:nil].size;
        _titleLabel.frame = CGRectMake(0, 0, size.width+10, 28);
        _titleLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        [self addSubview:_titleLabel];

    }
    return self;
}

- (void)dealloc {
    NSLog(@"提示栏😊");
}

#pragma mark private method
//马上显示提示条
- (void)immediatelyShowAndAnimation {
    //动画
    [UIView animateWithDuration:CapionBarAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:CapionBarAnimationDuration delay:CapionBarStayTime options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            
            //删除提示字符
            for (NSString *subTitle in _titleArray) {
                if ([_titleLabel.text isEqualToString:subTitle]) {
                    [_titleArray removeObject:subTitle];
                    break;
                }
            }
            [self removeFromSuperview];

            if ([_topCapionBarArray containsObject:self]) {//顶部提示条
                
                [_topCapionBarArray removeObject:self];
                if (_topCapionBarArray.count>0) {
                    TNCapionBar *capionBar = [_topCapionBarArray firstObject];
                    //延期显示下一个
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [capionBar immediatelyShowAndAnimation];
                    });
                }
            }else if ([_bottomCapionBarArray containsObject:self]) {//底部提示条
                
                [_bottomCapionBarArray removeObject:self];
                if (_bottomCapionBarArray>0) {
                    TNCapionBar *capionBar = [_bottomCapionBarArray firstObject];
                    //延期显示下一个
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [capionBar immediatelyShowAndAnimation];
                    });
                }
            }
            
        }];
    }];
}

/** 通过type获取提示字符串 */
+ (NSString *)capionTitleWithCapionBarType:(TNCapionBarType)type {
    switch (type) {
        case TNCapionBarTypeNetWorkError: {
            return @"网络连接失败，请检查您的网络连接状态";
        }
        case TNCapionBarTypeNotMoreData: {
            return @"已经是最后一条数据";
        }
        case TNCapionBarTypeNotData: {
            return @"没有数据";
        }
        case TNCapionBarTypeInputAccount: {
            return @"请输入您的登录账号!";
        }
        case TNCapionBarTypeInputPassword: {
            return @"请输入您的登录密码!";
        }
        default:
            return @"请输入提示文字";
    }
}

#pragma mark public method
/** 屏幕顶部弹出的提示条 */
+ (void)showScreenTopCapionBarInView:(UIView *)view CapionTitle:(NSString *)title {
    
    TNCapionBar *capionBar = [[TNCapionBar alloc] initWithTitle:title];
    capionBar.frame = CGRectOffset(capionBar.frame, 0, 80);
    
    if (view) {//view存在
        CGRect rect = [view convertRect:capionBar.frame fromView:[UIApplication sharedApplication].keyWindow];
        capionBar.frame = rect;
        [view addSubview:capionBar];
        
    }else {//view不存在
        [[UIApplication sharedApplication].keyWindow addSubview:capionBar];
    }

    if (!_topCapionBarArray) {
        _topCapionBarArray = [[NSMutableArray alloc] init];
    }
    
    if (_topCapionBarArray.count == 0) {//没有正在执行的动画，立即执行
        [_topCapionBarArray addObject:capionBar];
        //立即执行动画
        [capionBar immediatelyShowAndAnimation];
        
    }else {
        //稍后执行动画
        [_topCapionBarArray addObject:capionBar];
    }
}

/** 屏幕顶部弹出的提示条，不显示重复的信息 */
+ (void)showScreenTopCapionBarInView:(UIView *)view CapionBarType:(TNCapionBarType)type {
    
    TNCapionBar *capionBar = [[TNCapionBar alloc] initWithTitle:[TNCapionBar capionTitleWithCapionBarType:type]];
    capionBar.frame = CGRectOffset(capionBar.frame, 0, 80);
    capionBar->_capionBarType = type;
    
    if (view) {//view存在
        CGRect rect = [view convertRect:capionBar.frame fromView:[UIApplication sharedApplication].keyWindow];
        capionBar.frame = rect;
        [view addSubview:capionBar];
        
    }else {//view不存在
        [[UIApplication sharedApplication].keyWindow addSubview:capionBar];
    }
    if (!_topCapionBarArray) {
        _topCapionBarArray = [[NSMutableArray alloc] init];
    }
    
    if (_topCapionBarArray.count == 0) {//没有正在执行的动画，立即执行
        [_topCapionBarArray addObject:capionBar];
        //立即执行动画
        [capionBar immediatelyShowAndAnimation];
        
    }else {//有正在执行的动画
        
        //判断是否已经有相同类型的动画
        for (TNCapionBar *capionBar in _topCapionBarArray) {
            //有相同的类型
            if (capionBar->_capionBarType == type) {
                return;
            }
        }
        //稍后执行动画
        [_topCapionBarArray addObject:capionBar];
    }
}

/** 屏幕底部弹出的提示条 */
+ (void)showScreenBottomCapionBarInView:(UIView *)view CapionTitle:(NSString *)title {
    
    //判断是否是相同的提示符
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
    }else {
        for (NSString *subTitle in _titleArray) {
            if ([title isEqualToString:subTitle]) {
                return;
            }
        }
    }
    [_titleArray addObject:title];
    
    TNCapionBar *capionBar = [[TNCapionBar alloc] initWithTitle:title];
    capionBar.frame = CGRectOffset(capionBar.frame, 0, [UIScreen mainScreen].bounds.size.height-64);

    if (view) {//view存在
        CGRect rect = [view convertRect:capionBar.frame fromView:[UIApplication sharedApplication].keyWindow];
        capionBar.frame = rect;
        [view addSubview:capionBar];
        
    }else {//view不存在
        [[UIApplication sharedApplication].keyWindow addSubview:capionBar];
    }
    
    if (!_bottomCapionBarArray) {
        _bottomCapionBarArray = [[NSMutableArray alloc] init];
    }
    
    if (_bottomCapionBarArray.count == 0) {//没有正在执行的动画，立即执行
        [_bottomCapionBarArray addObject:capionBar];
        //立即执行动画
        [capionBar immediatelyShowAndAnimation];
    }else {
        //稍后执行动画
        [_bottomCapionBarArray addObject:capionBar];
    }
}

/** 屏幕底部弹出的提示条，不显示重复的信息 */
+ (void)showScreenBottomCapionBarInView:(UIView *)view CapionBarType:(TNCapionBarType)type {
    
    TNCapionBar *capionBar = [[TNCapionBar alloc] initWithTitle:[TNCapionBar capionTitleWithCapionBarType:type]];
    capionBar.frame = CGRectOffset(capionBar.frame, 0, [UIScreen mainScreen].bounds.size.height-64);
    capionBar->_capionBarType = type;
    
    if (view) {//view存在
        CGRect rect = [view convertRect:capionBar.frame fromView:[UIApplication sharedApplication].keyWindow];
        capionBar.frame = rect;
        [view addSubview:capionBar];
        
    }else {//view不存在
        [[UIApplication sharedApplication].keyWindow addSubview:capionBar];
    }
    
    if (!_bottomCapionBarArray) {
        _bottomCapionBarArray = [[NSMutableArray alloc] init];
    }
    
    if (_bottomCapionBarArray.count == 0) {//没有正在执行的动画，立即执行
        [_bottomCapionBarArray addObject:capionBar];
        //立即执行动画
        [capionBar immediatelyShowAndAnimation];
        
    }else {//有正在执行的动画
        
        //判断是否已经有相同类型的动画
        for (TNCapionBar *capionBar in _bottomCapionBarArray) {
            //有相同的类型
            if (capionBar->_capionBarType == type) {
                return;
            }
        }
        //稍后执行动画
        [_bottomCapionBarArray addObject:capionBar];
    }
}

@end
