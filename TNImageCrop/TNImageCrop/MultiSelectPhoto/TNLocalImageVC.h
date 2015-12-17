//
//  TNLocalImageVC.h
//  WuTong
//
//  Created by 罗义德 on 15/11/30.
//  Copyright © 2015年 MacbookAir_liubo. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 选择完成回调 */
typedef void(^TNLocalImageCompletionBlock)(NSArray *imageModelArray);

/** 本地相册所有图片类 */

@interface TNLocalImageVC : UIViewController
/** 实例化选择图片对象 */
- (instancetype)initWithCompletionHandle:(TNLocalImageCompletionBlock)completion;

/** 限制选取的照片数量 */
@property(nonatomic, assign)NSInteger maximumNumberOfImages;

@end
