//
//  TNLocalImageCell.h
//  WuTong
//
//  Created by 罗义德 on 15/11/30.
//  Copyright © 2015年 MacbookAir_liubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNLocalImageModel.h"

/** 本地图片展示cell */

@interface TNLocalImageCell : UICollectionViewCell
/** 给cell赋值 */
- (void)configureLocalImageCell:(TNLocalImageModel *)model;

@end
