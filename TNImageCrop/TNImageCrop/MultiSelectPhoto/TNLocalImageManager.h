//
//  TNLocalImageManager.h
//  WuTong
//
//  Created by 罗义德 on 15/11/30.
//  Copyright © 2015年 MacbookAir_liubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNLocalImageModel.h"

/** 本地图片管理类 */

@interface TNLocalImageManager : UINavigationController
/** 实例化选择图片对象 */
- (instancetype)initWithCompletionHandle:(void(^)(NSArray *selectedImageArray))completion;

/** 限制选取的照片数量 */
@property(nonatomic, assign)NSInteger maximumNumberOfImages;

@end
