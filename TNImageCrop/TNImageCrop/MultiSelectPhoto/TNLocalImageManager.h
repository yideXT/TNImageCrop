//
//  TNLocalImageManager.h
//  WuTong
//
//  Created by 罗义德 on 15/11/30.
//  Copyright © 2015年 MacbookAir_liubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNLocalImageModel.h"

/** 图片存储的文件夹路径 */
#define TNLocalImage_Cache_Directory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/SelectedPhotos"]

/** 选择完成回调 */
typedef void(^TNLocalImageCompletionBlock)(NSArray *imageModelArray);

/** 选取图片的方式 */
typedef NS_OPTIONS(NSInteger, TNLocalImageSeletor) {
    TNLocalImageSeletorCamera,       //相机
    TNLocalImageSeletorSystemAlbum,  //系统相册
    TNLocalImageSeletorCustomAlbum   //自定义相册
};

/** 本地图片管理类 */

@interface TNLocalImageManager : UINavigationController
/** 实例化选择图片对象 */
- (instancetype)initWithCompletionHandle:(void(^)(NSArray *selectedImageArray))completion;
/** 选择选取图片的方式:默认是进入自定义相册 */
@property(nonatomic, assign)TNLocalImageSeletor imageSelector;
/** 限制选取的照片数量 */
@property(nonatomic, assign)NSInteger maximumNumberOfImages;

/** 系统相册选取图片，是否允许编辑 */
@property(nonatomic, assign)BOOL canEditImage;

@end
