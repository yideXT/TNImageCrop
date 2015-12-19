//
//  UIImage+SaveToAlbum.m
//  ImageCropViewDemo
//
//  Created by 罗义德 on 15/12/9.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import "UIImage+SaveToAlbum.h"

void (^_completion)(BOOL success);

@implementation UIImage (SaveToAlbum)

/** 保存到相册 */
- (void)saveToAlbumCompletionHandle:(void (^)(BOOL success))completion {
    _completion = completion;
    //保存图片
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//保存成功回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (_completion) {
        _completion(error != nil?NO:YES);
    }
}

@end
