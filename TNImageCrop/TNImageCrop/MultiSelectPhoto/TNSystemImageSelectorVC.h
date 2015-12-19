//
//  TNSystemImageSelectorVC.h
//  SingleMentoring
//
//  Created by 罗义德 on 15/12/17.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNLocalImageManager.h"

/** 系统图片选择方式类 */

@interface TNSystemImageSelectorVC : UIViewController
/** 实例化选择图片对象 */
- (instancetype)initWithCompletionHandle:(TNLocalImageCompletionBlock)completion;
/** 选择图片的方式:相册或者相机 */
@property(nonatomic, assign)TNLocalImageSeletor imageSelector;
/** 是否允许图片编辑 */
@property(nonatomic, assign)BOOL canEditImage;


@end
