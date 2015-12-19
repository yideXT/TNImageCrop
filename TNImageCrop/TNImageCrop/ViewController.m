//
//  ViewController.m
//  ImageCropViewDemo
//
//  Created by 罗义德 on 15/12/2.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import "ViewController.h"
#import "TNCropImageView.h"
#import "TNLocalImageManager.h"
#import "EditCropFrameVC.h"
#import "UIImage+SaveToAlbum.h"
#import "TNCapionBar.h"

@interface ViewController () {
    //剪裁类
    TNCropImageView *_cropImageView;
    //显示剪裁之后的图片
    UIImageView *_imageView;
    
    //截图边框size
    CGSize _cropSize;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _cropSize = CGSizeMake(150, 150);
    //图片裁切类
    _cropImageView = [[TNCropImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)) cropFrameSize:_cropSize isRoubdFrame:YES];
    [_cropImageView setCropImageContent:[UIImage imageNamed:@"students1"]];
    [self.view addSubview:_cropImageView];
    
    CGRect rect = CGRectMake(CGRectGetWidth(self.view.frame)/2-125, CGRectGetMaxY(_cropImageView.frame)+10, 250, 150);
    _imageView = [[UIImageView alloc] initWithFrame:rect];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imageView];
    //显示剪裁的图片
    
    rect.origin.x = 0;
    rect.origin.y = CGRectGetMaxY(_imageView.frame)+10;
    rect.size = CGSizeMake(CGRectGetWidth(self.view.frame)/4, 50);
    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"编辑截图框",@"选择图片",@"剪裁图片",@"保存相册", nil];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = rect;
        button.tag = i;
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        rect.origin.x += rect.size.width;
    }
    
    //切完图片回调
    __weak typeof(_imageView)imageView = _imageView;
    _cropImageView.cropImageCompletionHandle = ^(UIImage *newImage) {
        //显示裁剪之后的图片
        imageView.image = newImage;
        NSLog(@"cropImage === %@",imageView);
    };
}

//点击事件
- (void)buttonClick:(UIButton *)btn {
    
    if (btn.tag == 0) {//编辑截图框
        EditCropFrameVC *vc = [[EditCropFrameVC alloc] initWithNibName:@"EditCropFrameVC" bundle:[NSBundle mainBundle]];
        [self presentViewController:vc animated:YES completion:nil];
        
        vc.currentSize = _cropSize;
        vc.isRoundFrame = _cropImageView.isRoundCropFrame;
        vc.completion = ^(CGFloat width,CGFloat height) {
            _cropSize = CGSizeMake(width, height);
            [_cropImageView setCropFrameSize:_cropSize];
        };
        
        //修改边框
        vc.changeShapeCompletion = ^(BOOL isRound){
            _cropImageView.isRoundCropFrame = isRound;
        };
        
    }else if (btn.tag == 1) {//选择图片
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //照片选择类
        TNLocalImageManager *localImageManager = [[TNLocalImageManager alloc] initWithCompletionHandle:^(NSArray *selectedImageArray) {
            TNLocalImageModel *model = [selectedImageArray firstObject];
            [self selectedImageFinish:model.itemImage filePath:model.itemImagePath];
        }];

        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            localImageManager.imageSelector = TNLocalImageSeletorCamera;
            [self presentViewController:localImageManager animated:YES completion:nil];

        }];
        
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"默认相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            localImageManager.imageSelector = TNLocalImageSeletorSystemAlbum;
            [self presentViewController:localImageManager animated:YES completion:nil];
            
        }];
        
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"自定义相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            localImageManager.imageSelector = TNLocalImageSeletorCustomAlbum;
            localImageManager.maximumNumberOfImages = 1;
            [self presentViewController:localImageManager animated:YES completion:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cameraAction];
        [alertController addAction:albumAction];
        [alertController addAction:libraryAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if (btn.tag == 2) {//剪裁
        [_cropImageView cropImage];
        
    }else {//保存相册
        [_imageView.image saveToAlbumCompletionHandle:^(BOOL success) {
            NSString *title = success?@"图片保存到相册成功!":@"图片保存的相册失败!";
            [TNCapionBar showScreenBottomCapionBarInView:self.view CapionTitle:title isShowSame:NO];
        }];
    }
}

//选择完照片回调
- (void)selectedImageFinish:(UIImage *)image filePath:(NSString *)filePath {
    [_cropImageView setCropImageContent:image];
    //删除本地文件缓存
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
