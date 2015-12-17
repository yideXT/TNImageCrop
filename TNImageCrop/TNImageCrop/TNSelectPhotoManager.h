//
//  TNSelectPhotoManager.h
//  WuTong
//
//  Created by 罗义德 on 15/9/14.
//  Copyright (c) 2015年 MacbookAir_liubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    TNSelectPhotoCamera = 0,
    TNSelectPhotoAlbum,
}TNSelectPhotoType;

/** 照片选择管理类 */
@interface TNSelectPhotoManager : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

/** 是否开启照片编辑功能 */
@property(nonatomic, assign)BOOL canEditPhoto;
/** 跳转的控制器 可选参数 */
@property(nonatomic, weak)__weak UIViewController *superVC;

/** 照片选取成功回调 */
@property(nonatomic, strong)void (^successHandle)(UIImage *image, NSString *filePath);
/** 照片选取失败回调 */
@property(nonatomic, strong)void (^errorHandle)(NSString *error);

/** 开始选取照片:弹出一个UIActionSheet */
- (void)startSelectPhoto;
/** 根据类型参数直接进入相机或者相册 */
- (void)startSelectPhotoWithType:(TNSelectPhotoType )type;

/** 清理图片缓存 */
+ (void)clearSelectPhoto:(NSString *)filePath;

@end
