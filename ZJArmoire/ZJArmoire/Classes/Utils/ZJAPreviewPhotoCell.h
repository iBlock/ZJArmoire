//
//  TZTestCell.h
//  TZImagePickerController
//
//  Created by iBlock on 17/1/3.
//  Copyright © 2017年 iBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJAPreviewPhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;

@end

