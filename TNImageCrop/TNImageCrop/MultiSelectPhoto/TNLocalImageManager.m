//
//  TNLocalImageManager.m
//  WuTong
//
//  Created by 罗义德 on 15/11/30.
//  Copyright © 2015年 MacbookAir_liubo. All rights reserved.
//

#import "TNLocalImageManager.h"
#import "TNLocalImageVC.h"

@interface TNLocalImageManager () {
    TNLocalImageCompletionBlock _completion;
    TNLocalImageVC *_localImageVC;
}

@end

@implementation TNLocalImageManager
#pragma mark system method
/** 实例化选择图片对象 */
- (instancetype)initWithCompletionHandle:(void(^)(NSArray *selectedImageArray))completion {
    self = [super init];
    if (self) {
        _completion = completion;
        _localImageVC = [[TNLocalImageVC alloc] initWithCompletionHandle:_completion];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pushViewController:_localImageVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

#pragma mark public method
- (void)setMaximumNumberOfImages:(NSInteger)maximumNumberOfImages {
    _maximumNumberOfImages = maximumNumberOfImages;
    _localImageVC.maximumNumberOfImages = maximumNumberOfImages;
}

@end
