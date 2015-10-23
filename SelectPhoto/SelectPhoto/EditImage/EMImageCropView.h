//
//  EMImageCropView.h
//  PictureSelector
//
//  Created by Lyy on 15/8/21.
//  Copyright (c) 2015年 Lyy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  图片裁剪
 */
@interface EMImageCropView : UIView

/**
 *  蒙版透明度
 */
@property (nonatomic)   CGFloat maskOpacity;
/**
 *  蒙版颜色
 */
@property (nonatomic, strong) UIColor *maskColor;

/**
 *
 *  @param originalImage  原始图片
 *  @param cropSquareSide 裁剪框直径(圆形裁剪框)
 */
- (void) originalImage:(UIImage*)originalImage cropSquareSide:(CGFloat)cropSquareSide;

/**
 *  返回裁剪后的image
 *  @return 裁剪后的图片
 */
- (UIImage *)cropImage;

@end
