//
//  EditCropFrameVC.m
//  ImageCropViewDemo
//
//  Created by 罗义德 on 15/12/9.
//  Copyright © 2015年 lyd. All rights reserved.
//

#import "EditCropFrameVC.h"

@interface EditCropFrameVC () {
    
    __weak IBOutlet UITextField *_widthTF;
    
    __weak IBOutlet UITextField *_heightTF;
    
    __weak IBOutlet UILabel *_shapeLab;
    
    __weak IBOutlet UISwitch *_frameShapeSwitch;
}

@end

@implementation EditCropFrameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCurrentSize:(CGSize)currentSize {
    _widthTF.text = [NSString stringWithFormat:@"%ld",(NSInteger)currentSize.width];
    _heightTF.text = [NSString stringWithFormat:@"%ld",(NSInteger)currentSize.height];
}

- (void)setIsRoundFrame:(BOOL)isRoundFrame {
    _isRoundFrame = isRoundFrame;
    _frameShapeSwitch.on = !_isRoundFrame;
    if (_frameShapeSwitch.on) {
        _shapeLab.text = @"方形边框";
    }else {
        _shapeLab.text = @"圆形边框";
    }
}

//返回和确定按钮点击事件
- (IBAction)buttonClick:(id)sender {
    
    [self.view endEditing:YES];
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {//确定
        if (_completion) {
            _completion([_widthTF.text floatValue],[_heightTF.text floatValue]);
        }
        
        //回调
        if (_changeShapeCompletion) {
            _changeShapeCompletion(!_frameShapeSwitch.on);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//修改截图边框
- (IBAction)changeCropFrameShape:(id)sender {
    if (_frameShapeSwitch.on) {
        _shapeLab.text = @"方形边框";
    }else {
        _shapeLab.text = @"圆形边框";
    }
}

@end
