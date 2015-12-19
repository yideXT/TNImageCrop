//
//  TNLocalImageManager.m
//  WuTong
//
//  Created by 罗义德 on 15/11/30.
//  Copyright © 2015年 MacbookAir_liubo. All rights reserved.
//

#import "TNLocalImageManager.h"
#import "TNCustomImageSelectorVC.h"
#import "TNSystemImageSelectorVC.h"

@interface TNLocalImageManager () {
    TNLocalImageCompletionBlock _completion;
}

@end

@implementation TNLocalImageManager
#pragma mark system method
/** 实例化选择图片对象 */
- (instancetype)initWithCompletionHandle:(void(^)(NSArray *selectedImageArray))completion {
    self = [super init];
    if (self) {
        
        self.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.6 blue:1 alpha:1];
        //回调
        _completion = completion;
        //默认从自定义相册
        _imageSelector = TNLocalImageSeletorCustomAlbum;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //图片选择方式
    if (_imageSelector == TNLocalImageSeletorCustomAlbum) {//自定义相册
        TNCustomImageSelectorVC *customImageSelectorVC = [[TNCustomImageSelectorVC alloc] initWithCompletionHandle:_completion];
        customImageSelectorVC.maximumNumberOfImages = _maximumNumberOfImages;

        [self pushViewController:customImageSelectorVC animated:NO];
        
    }else {//系统相册或者相机
        TNSystemImageSelectorVC *systemImageSelectorVC = [[TNSystemImageSelectorVC alloc] initWithCompletionHandle:_completion];
        systemImageSelectorVC.imageSelector = _imageSelector;
        systemImageSelectorVC.canEditImage = _canEditImage;
        [self pushViewController:systemImageSelectorVC animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

@end
