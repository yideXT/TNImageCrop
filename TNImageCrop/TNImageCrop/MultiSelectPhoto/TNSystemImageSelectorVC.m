//
//  TNSystemImageSelectorVC.m
//  SingleMentoring
//
//  Created by 罗义德 on 15/12/17.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import "TNSystemImageSelectorVC.h"

@interface TNSystemImageSelectorVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate> {
    //回调
    TNLocalImageCompletionBlock _completion;
    //选择图片生成的模型
    TNLocalImageModel *_imageModel;
}

@end

@implementation TNSystemImageSelectorVC
#pragma mark system method
/** 实例化选择图片对象 */
- (instancetype)initWithCompletionHandle:(TNLocalImageCompletionBlock)completion {
    self = [super init];
    if (self) {
        _completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //跳转到相机
    UIImagePickerController *ipVC = [[UIImagePickerController alloc] init];
    //设置跳转方式
    ipVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //设置是否可对图片进行编辑
    ipVC.allowsEditing = _canEditImage;
    //代理
    ipVC.delegate = self;
    
    if (_imageSelector == TNLocalImageSeletorCamera) {//相机
        
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
        if (!isCamera) {//设备没有摄像头
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            return ;
            
        }else{
            ipVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
    }else {//相册
        ipVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //跳转系统相册
    [self presentViewController:ipVC animated:NO completion:nil];
}

- (void)dealloc {
    NSLog(@"系统相册😊");
}

#pragma mark private method
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
    long long size = data.length/1024;
    if (size>4*1024) {//大于4M
        data = UIImageJPEGRepresentation(image, 1/20);
        
    }else if (size>3*1024) {//大于3M
        data = UIImageJPEGRepresentation(image, 1/16);
        
    }else if (size>2*1024) {//大于2M
        data = UIImageJPEGRepresentation(image, 1/12);
        
    }else if (size>1024) {//大于1M
        data = UIImageJPEGRepresentation(image, 1/8);
        
    }else if (size>0.5*1024) {//大于0.5M
        data = UIImageJPEGRepresentation(image, 1/4);
        
    }else if (size>0.2*1024) {//大于0.2M
        data = UIImageJPEGRepresentation(image, 1/2);
        
    }else {
        data = UIImageJPEGRepresentation(image, 1.0);
        
    }
    
    return [UIImage imageWithData:data];
}

#pragma mark 响应事件

#pragma mark 网络相关

#pragma mark protocol method
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
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:TNLocalImage_Cache_Directory]) {
        [fileManager createDirectoryAtPath:TNLocalImage_Cache_Directory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    _imageModel = [[TNLocalImageModel alloc] init];
    NSString *fileName = [NSString stringWithFormat:@"photo_%0.2f.jpg",[[NSDate date] timeIntervalSince1970]];
    //图片存储路径
    _imageModel.itemImagePath = [NSString stringWithFormat:@"%@/%@",TNLocalImage_Cache_Directory,fileName];
    _imageModel.itemImage = image;
    
    BOOL success = [fileManager createFileAtPath:_imageModel.itemImagePath contents:imageData attributes:nil];
    if (success) {
        NSLog(@"保存成功:%@",_imageModel.itemImagePath);
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (_completion) {//选择图片完成回调
        _completion(@[_imageModel]);
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark publick method



@end
