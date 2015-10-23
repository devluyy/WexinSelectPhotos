//
//  LyySelectImage.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/14.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import "LyySelectImage.h"
#import <UIKit/UIKit.h>
#import "EMImageEditViewController.h"

@interface LyySelectImage ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    __weak UIViewController *_controller;
}
@end

@implementation LyySelectImage
//选取相册图片
- (void)openPhoto:(UIViewController *)controller {
    
    _controller = controller;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
//    picker.view.backgroundColor = _controller.view.backgroundColor;
    picker.navigationBar.tintColor = [UIColor blackColor];
//    picker.navigationBar.barTintColor = _controller.navigationController.navigationBar.barTintColor;
    picker.navigationBar.opaque = NO;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [_controller presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
    EMImageEditViewController *imageEditVC = [[EMImageEditViewController alloc] initWithImage:image complete:^(UIImage *clippedImage) {
        [_controller dismissViewControllerAnimated:YES completion:^{
//            此处作上传图像操作
//            [self uploadImage:clippedImage withUrl:nil];
            
        }];
        
    }];
    [picker.navigationController setNavigationBarHidden:NO];
    [picker pushViewController:imageEditVC animated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
//此处作用，修改statusbar的style，在其它地方设置无效
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        [UIApplication sharedApplication].statusBarStyle = ([EMUserCustomData sharedData].themeType == EMAPPThemeTypeBlack) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    }
}


@end
