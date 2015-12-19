//
//  UIImage+SaveToAlbum.h
//  ImageCropViewDemo
//
//  Created by 罗义德 on 15/12/9.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 图片保存到相册类别 */

@interface UIImage (SaveToAlbum)

/** 保存到相册 */
- (void)saveToAlbumCompletionHandle:(void (^)(BOOL success))completion;

@end
