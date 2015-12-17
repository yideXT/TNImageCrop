//
//  TNSelectPhotoManager.m
//  WuTong
//
//  Created by 罗义德 on 15/9/14.
//  Copyright (c) 2015年 MacbookAir_liubo. All rights reserved.
//

#import "TNSelectPhotoManager.h"

#define ImageDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/SelectPhotos"]

@implementation TNSelectPhotoManager {
    //图片路径
    NSString *_imageName;
}

#pragma mark system method
- (instancetype)init {
    self = [super init];
    if (self) {
        _canEditPhoto = YES;
    }
    return self;
}

#pragma mark public method
/** 开始选取照片:弹出一个UIActionSheet */
- (void)startSelectPhoto {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机拍照",@"从相册获取", nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window) {
        [actionSheet showInView:window];
        
    }else{
        [actionSheet showInView:[[self getCurrentVC] view]];
    }
}

/** 根据类型参数直接进入相机或者相册 */
- (void)startSelectPhotoWithType:(TNSelectPhotoType )type {

    UIImagePickerController *ipVC = [[UIImagePickerController alloc] init];
    //设置跳转方式
    ipVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    if (_canEditPhoto) {
        //设置是否可对图片进行编辑
        ipVC.allowsEditing = YES;
    }
    
    ipVC.delegate = self;
    if (type == TNSelectPhotoCamera) {
        NSLog(@"相机");
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
        if (!isCamera) {
            NSLog(@"没有摄像头");
            if (_errorHandle) {
                _errorHandle(@"没有摄像头");
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }else{
            ipVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
    }else {
        NSLog(@"相册");
        ipVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [[self getCurrentVC] presentViewController:ipVC animated:YES completion:nil];
}

//清理图片缓存
+ (void)clearSelectPhoto:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:filePath error:nil]) {
        NSLog(@"清除图片缓存成功!");
    }
}

#pragma mrak private method
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    
    if (_superVC) {
        return _superVC;
    }
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
        
    }else{
        result = window.rootViewController;
        
    }
    return result;
}

#pragma mark protocol method
#pragma mark UIActionSheet的协议方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        NSLog(@"取消");
        
    }else if (buttonIndex == 0) {//相机
        [self startSelectPhotoWithType:TNSelectPhotoCamera];
        
    }else if (buttonIndex == 1) {
        [self startSelectPhotoWithType:TNSelectPhotoAlbum];
        
    }
}

#pragma mark imagePickerController协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    NSLog(@"info = %@",info);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (image == nil) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    //图片旋转
    if (image.imageOrientation != UIImageOrientationUp) {
        //图片旋转
        image = [self fixOrientation:image];
    }
    
    //图片压缩
    image = [self compressImage:image];
    
    //把照片存成文件，以便于上传
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:ImageDirectory]) {
        [fileManager createDirectoryAtPath:ImageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    _imageName = [NSString stringWithFormat:@"photo_%0.2f.jpg",[[NSDate date] timeIntervalSince1970]];
    
    //图片存储路径
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",ImageDirectory,_imageName];
    
    BOOL success = [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
    if (success) {
        NSLog(@"保存成功:%@",imagePath);
    }
    
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    
    if (_successHandle) {//选择图片完成回调
        _successHandle(image,imagePath);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    if (_errorHandle) {
        _errorHandle(@"撤销");
    }
}

#pragma mark 图片处理方法
//图片旋转处理
- (UIImage *)fixOrientation:(UIImage *)aImage {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}

//图片压缩
- (UIImage *)compressImage:(UIImage *)image {
    
    NSData * data = UIImageJPEGRepresentation(image, 1);
    float m = [data length]/1024.0;
    if (m>15*1024) {
        data = UIImageJPEGRepresentation(image, 0.1);
        
    }else if (m>4*1024) {
        data = UIImageJPEGRepresentation(image, 1/(4*m/1024.0));
        
    }else if (m>3*1024) {
        data = UIImageJPEGRepresentation(image, 1/16);
        
    }else if (m>2*1024) {
        data = UIImageJPEGRepresentation(image, 1/12);
        
    }else if (m>1024) {
        data = UIImageJPEGRepresentation(image, 1/8);
        
    }else if (m>0.5*1024) {
        data = UIImageJPEGRepresentation(image, 1/4);
        
    } else if (m>0.2*1024) {
        data = UIImageJPEGRepresentation(image, 1/2);
        
    }
    return [UIImage imageWithData:data];
}

- (void)dealloc {
    NSLog(@"😊");
}

@end
