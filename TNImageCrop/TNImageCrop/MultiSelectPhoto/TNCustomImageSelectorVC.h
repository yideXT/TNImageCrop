//
//  TNCustomImageSelectorVC.h
//  SingleMentoring
//
//  Created by 罗义德 on 15/12/17.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNLocalImageManager.h"

/** 自定义图片选择方式类 */

@interface TNCustomImageSelectorVC : UIViewController
/** 实例化选择图片对象 */
- (instancetype)initWithCompletionHandle:(TNLocalImageCompletionBlock)completion;

/** 限制选取的照片数量 */
@property(nonatomic, assign)NSInteger maximumNumberOfImages;

@end
