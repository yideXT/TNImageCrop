//
//  EditCropFrameVC.h
//  ImageCropViewDemo
//
//  Created by 罗义德 on 15/12/9.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCropFrameVC : UIViewController

/** 现在的边框size */
@property(nonatomic, assign)CGSize currentSize;
/** 现在是否是圆形边框 */
@property(nonatomic, assign)BOOL isRoundFrame;

/** 修改截图边回调框 */
@property(nonatomic, strong)void (^completion)(CGFloat width,CGFloat height);

/** 修改截图边框形状回调 */
@property(nonatomic, strong)void (^changeShapeCompletion)(BOOL isRound);

@end
