//
//  TNLocalImageVC.m
//  WuTong
//
//  Created by 罗义德 on 15/11/30.
//  Copyright © 2015年 MacbookAir_liubo. All rights reserved.
//

#import "TNLocalImageVC.h"
#import "UIViewController+NavigationBarItem.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TNLocalImageCell.h"
#import "TNLocalImageModel.h"

//复用标识
static NSString * const reuseIdentifier = @"TNLocalImageCell";
//cell之间的距离
CGFloat const item_gap = 2;
//一行显示的图片数量
CGFloat const image_line_num = 4;
//图片存储的文件夹路径
#define TNLocalImage_Cache_Directory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/SelectedPhotos"]

@interface TNLocalImageVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate> {
    //相册资源类
    ALAssetsLibrary *_assetsLibrary;
    
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
    
    //所有图片资源数组
    NSMutableArray *_assetArray;
    
    //显示选中图片数量的label
    UILabel *_selectedImageNumLab;
    //显示总的图片数
    UILabel *_allImageNumLab;
    //确定按钮
    UIButton *_confirmBtn;
    
    //选中的图片数组
    NSMutableArray *_selectImageArray;
    //选择完成回调
    TNLocalImageCompletionBlock _completion;
}

@end

@implementation TNLocalImageVC
#pragma mark system method
/** 实例化选择图片对象 */
- (instancetype)initWithCompletionHandle:(TNLocalImageCompletionBlock)completion {
    self = [super init];
    if (self) {
        _completion = completion;
        _maximumNumberOfImages = 10000;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    //初始化UI
    [self setupUI];
    //初始化数据
    [self initailizeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

#pragma mark private method
//初始化UI
- (void)setupUI {
    //导航条
    self.navigationItem.title = @"选择图片";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self createLeftItemWithTitle:@"取消" textColor:[UIColor whiteColor] target:self selector:@selector(buttonClick:) tag:0];
    _confirmBtn = [self createRightItemWithTitle:@"确定" textColor:[UIColor whiteColor] target:self selector:@selector(buttonClick:) tag:1];
    [_confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _confirmBtn.enabled = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //collectionView的滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //cell的size
    flowLayout.itemSize = CGSizeMake((CGRectGetWidth(self.view.frame)-(image_line_num-1)*item_gap)/image_line_num, (CGRectGetWidth(self.view.frame)-(image_line_num-1)*item_gap)/image_line_num);
    //item之间的最小距离
    flowLayout.minimumInteritemSpacing = item_gap;
    flowLayout.minimumLineSpacing = item_gap;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64-44) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[TNLocalImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
    
    //底部显示的视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), CGRectGetWidth(self.view.frame), 44)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    [self.view addSubview:bottomView];
    
    //细线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bottomView.frame), 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [bottomView addSubview:lineView];
    
    //显示已选择图片个数lab
    _selectedImageNumLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.frame)-95, 5, 90, 34)];
    _selectedImageNumLab.layer.masksToBounds = YES;
    _selectedImageNumLab.layer.cornerRadius = 4;
    _selectedImageNumLab.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1 alpha:1];
    _selectedImageNumLab.textAlignment = NSTextAlignmentCenter;
    _selectedImageNumLab.font = [UIFont systemFontOfSize:15];
    _selectedImageNumLab.textColor = [UIColor whiteColor];
    _selectedImageNumLab.text = @"已选择(0)";
    [bottomView addSubview:_selectedImageNumLab];
    
    //总的图片数
    _allImageNumLab = [[UILabel alloc] init];
    _allImageNumLab.layer.masksToBounds = YES;
    _allImageNumLab.layer.cornerRadius = 4;
    _allImageNumLab.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1 alpha:1];
    _allImageNumLab.textAlignment = NSTextAlignmentCenter;
    _allImageNumLab.font = [UIFont systemFontOfSize:15];
    _allImageNumLab.textColor = [UIColor whiteColor];
    _allImageNumLab.text = [NSString stringWithFormat:@"共%ld张照片",_dataArray.count];
    [_selectedImageNumLab.superview addSubview:_allImageNumLab];
}

//初始化数据
- (void)initailizeData {
    
    //判断用户是否已经授权使用相册
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied){//无权限
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您允许梧桐使用您的相册。\n设置->梧桐->照片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    _dataArray = [[NSMutableArray alloc] init];
    _assetArray = [[NSMutableArray alloc] init];
    
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group != NULL) {//
            
            self.navigationItem.title = [group valueForProperty:ALAssetsGroupPropertyName];
            //遍历所有照片资源
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {

                if (result != NULL) {
                    
                    TNLocalImageModel *model = [[TNLocalImageModel alloc] init];
                    model.itemThumbnailImage = [UIImage imageWithCGImage:result.thumbnail];
                    
                    [_dataArray addObject:model];
                    [_assetArray addObject:result];
                    
                    if(index+1 == [group numberOfAssets]) {//遍历完成,最后一张图片
                        [_collectionView reloadData];
                        
                        _allImageNumLab.text = [NSString stringWithFormat:@"共%ld张照片",_dataArray.count];
                        CGSize size = [_allImageNumLab.text boundingRectWithSize:CGSizeMake(200, CGRectGetHeight(_selectedImageNumLab.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_allImageNumLab.font} context:nil].size;
                        _allImageNumLab.frame = CGRectMake(5, 5, size.width+10, CGRectGetHeight(_selectedImageNumLab.frame));
                        *stop = YES;
                    }
                }
                
            }];
        }else {
            *stop = YES;
        }
        
    } failureBlock:^(NSError *error) {
        // error
        NSLog(@"error ==> %@",error.localizedDescription);
    }];
}

#pragma mark 响应事件
- (void)buttonClick:(UIButton *)button {
    if (button.tag == 1) {//确定
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        for (TNLocalImageModel *subModel in _selectImageArray) {
            
            ALAsset *result = [_assetArray objectAtIndex:[_dataArray indexOfObject:subModel]];
            subModel.itemImage = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
            
            NSData *data = UIImageJPEGRepresentation(subModel.itemImage, 1.0);
            long long size = data.length/1024;
//            NSLog(@"size === %lldKB",size);
            if (size>4*1024) {//大于4M
                data = UIImageJPEGRepresentation(subModel.itemImage, 1/20);
                
            }else if (size>3*1024) {//大于3M
                data = UIImageJPEGRepresentation(subModel.itemImage, 1/16);
                
            }else if (size>2*1024) {//大于2M
                data = UIImageJPEGRepresentation(subModel.itemImage, 1/12);
                
            }else if (size>1024) {//大于1M
                data = UIImageJPEGRepresentation(subModel.itemImage, 1/8);
                
            }else if (size>0.5*1024) {//大于0.5M
                data = UIImageJPEGRepresentation(subModel.itemImage, 1/4);
                
            }else if (size>0.2*1024) {//大于0.2M
                data = UIImageJPEGRepresentation(subModel.itemImage, 1/2);
                
            }else {
                data = UIImageJPEGRepresentation(subModel.itemImage, 1.0);
                
            }

            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:TNLocalImage_Cache_Directory]) {
                [fileManager createDirectoryAtPath:TNLocalImage_Cache_Directory withIntermediateDirectories:YES attributes:nil error:nil];
            }

            NSString *filePath = [TNLocalImage_Cache_Directory stringByAppendingFormat:@"/%0.4f_%ld.jpg",[[NSDate date] timeIntervalSince1970],[_selectImageArray indexOfObject:subModel]];
//            NSLog(@"size === %0.2fKB",(float)(data.length/1024));
            //把图片存在本地沙盒路径
            if ([fileManager createFileAtPath:filePath contents:data attributes:nil]) {
                subModel.itemImagePath = filePath;
                subModel.itemImage = [UIImage imageWithData:data];
                subModel.itemSize = [data length];
                
                [resultArray addObject:subModel];
            }else {//存储失败
                NSLog(@"存储图片到本地沙盒失败!");
            }
        }
        
        if (_completion) {
            _completion(resultArray);
        }
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UICollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNLocalImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    TNLocalImageModel *model = [_dataArray objectAtIndex:indexPath.row];
    model.itemIndex = indexPath.row;
    [cell configureLocalImageCell:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TNLocalImageModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (model.itemSelected) {//已选中，取消选中
        [_selectImageArray removeObject:model];
    }else {//未选中，选中
        
        if (_selectImageArray.count >= _maximumNumberOfImages) {//已经达到选取的图片的最大数量
            return;
        }
        
        if (!_selectImageArray) {
            _selectImageArray = [[NSMutableArray alloc] init];
        }
        [_selectImageArray addObject:model];
    }
    model.itemSelected = !model.itemSelected;
    
    //刷新一行cell
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    _confirmBtn.enabled = _selectImageArray.count == 0?NO:YES;
    _selectedImageNumLab.text = [NSString stringWithFormat:@"已选择(%ld)",_selectImageArray.count];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(item_gap, 0, item_gap, 0);
}

#pragma mark alertView协议方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"buttonIndex === %ld",buttonIndex);
    if (buttonIndex == 0) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
