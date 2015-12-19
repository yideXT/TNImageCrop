//
//  TNLocalImageCell.m
//  WuTong
//
//  Created by 罗义德 on 15/11/30.
//  Copyright © 2015年 MacbookAir_liubo. All rights reserved.
//

#import "TNLocalImageCell.h"

@implementation TNLocalImageCell {
    UIImageView *_itemContentImg;
    UIImageView *_itemSelectIcon;
    
    NSInteger _itemIndex;
}
#pragma mark system method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

#pragma mark private method
- (void)setupUI {
    _itemContentImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _itemContentImg.contentMode = UIViewContentModeScaleAspectFill;
    _itemContentImg.clipsToBounds = YES;
    [self.contentView addSubview:_itemContentImg];
    
    _itemSelectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-25, 5, 20, 20)];
    _itemSelectIcon.image = [UIImage imageNamed:@"TN_image_selected"];
    [self.contentView addSubview:_itemSelectIcon];
    _itemSelectIcon.hidden = YES;
}

#pragma mark public method
/** 给cell赋值 */
- (void)configureLocalImageCell:(TNLocalImageModel *)model {
    
    _itemIndex = model.itemIndex;
    
    _itemContentImg.image = model.itemThumbnailImage;
    if (model.itemSelected) {
        _itemSelectIcon.hidden = NO;
        _itemContentImg.alpha = 0.7;
    }else {
        _itemSelectIcon.hidden = YES;
        _itemContentImg.alpha = 1.0;
    }
    //动画
}

@end
