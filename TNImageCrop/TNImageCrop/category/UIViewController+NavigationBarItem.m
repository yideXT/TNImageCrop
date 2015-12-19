//
//  UIViewController+NavigationBarItem.m
//  1001
//
//  Created by 罗义德 on 15/7/14.
//  Copyright (c) 2015年 ChuXiong. All rights reserved.
//

#import "UIViewController+NavigationBarItem.h"

//字体大小
CGFloat const TEXT_FONT = 15;

@implementation UIViewController (NavigationBarItem)

/** 左边按钮 */
- (void)createLeftItemWithImage:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 2, 40, 40);
    [leftItem setImage:image forState:UIControlStateNormal];
    [leftItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    leftItem.imageEdgeInsets = UIEdgeInsetsMake(0, -(40-image.size.width)/2, 0, (40-image.size.width)/2);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
}

- (void)createLeftItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftItem setTitle:title forState:UIControlStateNormal];
    [leftItem setTitleColor:color forState:UIControlStateNormal];
    leftItem.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT];
    [leftItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    CGSize size = [title sizeWithFont:leftItem.titleLabel.font constrainedToSize:CGSizeMake(100, 40)];
    leftItem.frame = CGRectMake(0, 2, size.width, 40);
}

/** 导航栏右边按钮 */
- (void)createRightItemWithImages:(NSArray *)imageNameArr target:(id)target selector:(SEL)sel tags:(NSArray *)tagArr {
    
    NSMutableArray *buttonArr = [[NSMutableArray alloc] init];
    for (int i=0; i<imageNameArr.count; i++) {
        UIImage *image = [UIImage imageNamed:[imageNameArr objectAtIndex:i]];
        UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
        rightItem.frame = CGRectMake(0, 7, 30, 30);
        [rightItem setImage:image forState:UIControlStateNormal];
        [rightItem addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        rightItem.tag = [[tagArr objectAtIndex:i] integerValue];
        rightItem.imageEdgeInsets = UIEdgeInsetsMake(0, (30-image.size.width)/2, 0, -(30-image.size.width)/2);
        [buttonArr addObject:[[UIBarButtonItem alloc] initWithCustomView:rightItem]];
    }
    
    self.navigationItem.rightBarButtonItems = buttonArr;
}

- (UIButton *)createRightItemWithTitle:(NSString *)title textColor:(UIColor *)color target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *rightItem = [self buttonWithImage:nil title:title target:target selector:sel tag:tag];
    [rightItem setTitleColor:color forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    CGSize size = [title sizeWithFont:rightItem.titleLabel.font constrainedToSize:CGSizeMake(100, 40)];
    rightItem.frame = CGRectMake(0, 2, size.width, 40);
    
    return rightItem;
}

- (UIButton *)createRightItemWithImage:(NSString *)imageName target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *rightItem = [self buttonWithImage:imageName title:nil target:target selector:sel tag:tag];
    rightItem.frame = CGRectMake(0, 2, 40, 40);
    rightItem.imageEdgeInsets = UIEdgeInsetsMake(0, (40-rightItem.imageView.frame.size.width)/2, 0, -(40-rightItem.imageView.frame.size.width)/2);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    return rightItem;
}

#pragma mark private method
- (UIButton *)buttonWithImage:(NSString *)image title:(NSString *)title target:(id)target selector:(SEL)sel tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    return button;
}

@end






