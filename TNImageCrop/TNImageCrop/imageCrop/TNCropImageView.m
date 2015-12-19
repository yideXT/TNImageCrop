//
//  TNCropImageView.m
//  ImageCropViewDemo
//
//  Created by 罗义德 on 15/12/8.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import "TNCropImageView.h"

@interface TNCropImageView ()<UIScrollViewDelegate>

@end

@implementation TNCropImageView {

    //背景贝塞尔曲线路径
    UIBezierPath *_bgPath;
    
    CAShapeLayer *_cropFrameLayer;
    CAShapeLayer *_whiteFrameLayer;
    
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    
    //截图边框的size
    CGSize _cropSize;
    
    //图片是否被拉伸
    BOOL _imageViewIsStretch;
    //imageView被拉伸之后的size
    CGSize _imageViewStretchSize;
}

#pragma mark system method
- (instancetype)initWithFrame:(CGRect)frame cropFrameSize:(CGSize)cropSize isRoubdFrame:(BOOL)round {
    self = [super initWithFrame:frame];
    if (self) {
        if (cropSize.width<=0 || cropSize.height<=0 || cropSize.width>CGRectGetWidth(frame) || cropSize.height>CGRectGetHeight(frame)) {
            cropSize = self.frame.size;
        }
        
        if (_isRoundCropFrame) {//圆形边框，保证宽和高相等
            cropSize.width = MIN(cropSize.width, cropSize.height);
            cropSize.height = MIN(cropSize.width, cropSize.height);
        }
        _cropSize = cropSize;
        [self setupUI];
    }
    return self;
}

//设置截图边框
- (void)setIsRoundCropFrame:(BOOL)isRoundCropFrame {
    if (_isRoundCropFrame == isRoundCropFrame) {
        return;
    }
    _isRoundCropFrame = isRoundCropFrame;
    [self setCropFrameSize:_cropSize];
}

#pragma mark private mehtod
- (void)setupUI {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)+0.5, CGRectGetHeight(self.frame)+0.5);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:_scrollView];
    
    _bgPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [_bgPath setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [circleLayer setPath:[_bgPath CGPath]];
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    //设置截图边框
    [self configureCropFrame];
}

//设置截图边框
- (void)configureCropFrame {
    
    UIBezierPath *path;
    if (_isRoundCropFrame) {//圆形边框
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((CGRectGetWidth(self.frame)-_cropSize.width)/2, (CGRectGetHeight(self.frame)-_cropSize.height)/2, _cropSize.width, _cropSize.height)];
    }else {//方形边框
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.frame)-_cropSize.width)/2, (CGRectGetHeight(self.frame)-_cropSize.height)/2, _cropSize.width, _cropSize.height) cornerRadius:0];
    }
    [path appendPath:_bgPath];
    [path setUsesEvenOddFillRule:YES];
    
    _cropFrameLayer = [CAShapeLayer layer];
    _cropFrameLayer.name = @"cropFrameLayer";
    _cropFrameLayer.path = path.CGPath;
    _cropFrameLayer.fillRule = kCAFillRuleEvenOdd;
    _cropFrameLayer.fillColor = [UIColor blackColor].CGColor;
    _cropFrameLayer.opacity = 0.5;
    [self.layer addSublayer:_cropFrameLayer];
    
    //白色边框
    _whiteFrameLayer = [CAShapeLayer layer];
    _whiteFrameLayer.frame = CGRectMake((CGRectGetWidth(self.frame)-_cropSize.width)/2, (CGRectGetHeight(self.frame)-_cropSize.height)/2, _cropSize.width, _cropSize.height);
    _whiteFrameLayer.fillColor = [UIColor clearColor].CGColor;
    _whiteFrameLayer.strokeColor = [UIColor whiteColor].CGColor;
    UIBezierPath *bezierPath;
    if (_isRoundCropFrame) {//圆形边框
        bezierPath = [UIBezierPath bezierPathWithOvalInRect:_whiteFrameLayer.bounds];
    }else {//方形边框
        bezierPath = [UIBezierPath bezierPathWithRect:_whiteFrameLayer.bounds];
    }
    _whiteFrameLayer.lineWidth = 1;
    _whiteFrameLayer.path = bezierPath.CGPath;
    _whiteFrameLayer.strokeStart = 0.0;
    _whiteFrameLayer.strokeEnd = 1.0;
    [self.layer addSublayer:_whiteFrameLayer];
    _whiteFrameLayer.opacity = 1;
}

#pragma mark scrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)-_cropSize.width+CGRectGetWidth(view.frame),CGRectGetHeight(self.frame)-_cropSize.height+CGRectGetHeight(view.frame));
}

#pragma mark public mehtod
/** 设置截图边框size */
- (void)setCropFrameSize:(CGSize)size {
    
    if (size.width<=0 || size.height<=0 || size.width>CGRectGetWidth(self.frame) || size.height>CGRectGetHeight(self.frame)) {
        size = self.frame.size;
    }
    
    if (_isRoundCropFrame) {//圆形边框，保证宽和高相等
        size.width = MIN(size.width, size.height);
        size.height = MIN(size.width, size.height);
    }
    _cropSize = size;
    
    [_cropFrameLayer removeFromSuperlayer];
    [_whiteFrameLayer removeFromSuperlayer];
    
    //设置截图边框
    [self configureCropFrame];
    //重新设置图片
    [self setCropImageContent:_imageView.image];
}

/** 设置要裁切的图片 */
- (void)setCropImageContent:(UIImage *)image {
    
    CGRect rect = CGRectMake((CGRectGetWidth(self.frame)-_cropSize.width)/2, (CGRectGetHeight(self.frame)-_cropSize.height)/2, image.size.width, image.size.height);
    
//    NSLog(@"_cropSize === %@",NSStringFromCGSize(_cropSize));
//    NSLog(@"rect === %@",NSStringFromCGRect(rect));
    //判断图片的某一边长度是否小于截图边框的长度
    if (rect.size.width<_cropSize.width) {//图片宽度小于截图边框的宽度
        rect.size.width = _cropSize.width;
        rect.size.height = image.size.height*((CGFloat)rect.size.width/image.size.width);
        
        _imageViewIsStretch = YES;
    }
//    NSLog(@"rect === %@",NSStringFromCGRect(rect));

    if (rect.size.height<_cropSize.height) {//图片高度小于截图边框的高度
        CGFloat temp_height = rect.size.height;
        
        rect.size.height = _cropSize.height;
        rect.size.width = rect.size.width*((CGFloat)rect.size.height/temp_height);
        
        _imageViewIsStretch = YES;
    }
//    NSLog(@"rect === %@",NSStringFromCGRect(rect));

    //先删除，再添加 ---- 如果一直用一个view,会有bug
    if (_imageView) {
        [_imageView removeFromSuperview];
    }
    _imageView  = [[UIImageView alloc] initWithFrame:rect];
    _imageView.image = image;
    [_scrollView addSubview:_imageView];
    _imageViewStretchSize = _imageView.frame.size;
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)-_cropSize.width+rect.size.width,CGRectGetHeight(self.frame)-_cropSize.height+rect.size.height);
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    //图片最小缩放倍数
    _scrollView.minimumZoomScale = MAX((CGFloat)_cropSize.width/rect.size.width, (CGFloat)_cropSize.height/rect.size.height);
    //图片最大缩放倍数
    _scrollView.maximumZoomScale = 5.0;
}

/** 裁剪图片 */
- (void)cropImage {
    if (!_imageView.image) {
        return;
    }
    UIImage *image = _imageView.image;
    CGRect rect = CGRectMake((CGRectGetWidth(self.frame)-_cropSize.width)/2, (CGRectGetHeight(self.frame)-_cropSize.height)/2, _cropSize.width, _cropSize.height);
    
    //坐标转换
    rect = [self convertRect:rect toView:_imageView];
    
    //imageView的宽度是否被拉伸过
    if (_imageViewIsStretch) {
        rect.origin.x = image.size.width*((CGFloat)rect.origin.x/_imageViewStretchSize.width);
        rect.origin.x = ((NSInteger)rect.origin.x) + (((NSInteger)(rect.origin.x*10)%10)>=5?1:0);

        rect.origin.y = image.size.height*((CGFloat)rect.origin.y/_imageViewStretchSize.height);
        rect.origin.y = ((NSInteger)rect.origin.y) + (((NSInteger)(rect.origin.y*10)%10)>=5?1:0);

        rect.size.width = image.size.width*((CGFloat)rect.size.width/_imageViewStretchSize.width);
        rect.size.width = ((NSInteger)rect.size.width) + (((NSInteger)(rect.size.width*10)%10)>=5?1:0);
        
        rect.size.height = image.size.height*((CGFloat)rect.size.height/_imageViewStretchSize.height);
        rect.size.height = ((NSInteger)rect.size.height) + (((NSInteger)(rect.size.height*10)%10)>=5?1:0);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    if (_isRoundCropFrame) {//切圆角图片
        cropImage = [self cropRoundImage:cropImage];
    }
    
    //回调
    if (_cropImageCompletionHandle) {
        _cropImageCompletionHandle(cropImage);
    }
}

/** 图片切圆 */
- (UIImage *)cropRoundImage:(UIImage *)image {
    
    UIGraphicsBeginImageContext(image.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return roundImage;
    
}

@end
