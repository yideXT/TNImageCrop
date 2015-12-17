//
//  TNLocalImageModel.h
//  WuTong
//
//  Created by 罗义德 on 15/11/30.
//  Copyright © 2015年 MacbookAir_liubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 本地图片模型 */

@interface TNLocalImageModel : NSObject
/** 图片缩略图对象 */
@property(nonatomic, strong)UIImage *itemThumbnailImage;
/** 图片对象 */
@property(nonatomic, strong)UIImage *itemImage;
/** 图片字节数 */
@property(nonatomic, assign)long long itemSize;
/** 图片的本地存储路径 */
@property(nonatomic, strong)NSString *itemImagePath;

#pragma mark cell的控制属性
/** 图片是否被选中 */
@property(nonatomic, assign)BOOL itemSelected;
/** 图片cell的位置 */
@property(nonatomic, assign)NSInteger itemIndex;

@end
