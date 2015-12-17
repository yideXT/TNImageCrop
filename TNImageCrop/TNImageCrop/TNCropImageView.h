//
//  TNCropImageView.h
//  ImageCropViewDemo
//
//  Created by 罗义德 on 15/12/8.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 图片动态裁切类 */

@interface TNCropImageView : UIView
/** 获取实例对象:cropFrameSize 裁切的范围，round 是否是圆形边框 */
- (instancetype)initWithFrame:(CGRect)frame cropFrameSize:(CGSize)cropSize isRoubdFrame:(BOOL)round;
/** 设置截图边框size */
- (void)setCropFrameSize:(CGSize)size;
/** 设置要裁切的图片 */
- (void)setCropImageContent:(UIImage *)image;
/** 裁剪图片 */
- (void)cropImage;

/** 是否是圆形截图边框 */
@property(nonatomic, assign)BOOL isRoundCropFrame;

/** 裁切图片完成回调 */
@property(nonatomic, strong)void (^cropImageCompletionHandle)(UIImage *newImage);

@end
