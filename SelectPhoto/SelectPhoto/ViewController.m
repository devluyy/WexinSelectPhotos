//
//  ViewController.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/14.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import "ViewController.h"
#import "EMImageEditViewController.h"

#import "EMShowPhotosCollectionViewController.h"
#import "EMListGroupTableViewController.h"

#import "EMSelectPhotos.h"
#import "EMPhotoGroup.h"
#import "EMPhoto.h"
#import "EMPhotoNavigationController.h"

@interface ViewController ()
<UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aaaa:)]];
    
    
    
}

- (void)aaaa:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:self.view];
    
    if (CGRectContainsPoint(self.view.frame,point)) {
        [self open:nil];
    }
    
    [self.topView convertPoint:point fromView:self.view];
}

- (IBAction)open:(id)sender {
    
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] < 8) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
        actionSheet.tag = 9999;
        actionSheet.delegate = self;
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self openCamera];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self openPics];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                //                                                NSLog(@"Action 3 Handler Called");
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self openCamera];
        }
            break;
        case 1:
        {
            [self openPics];
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }

}

- (void)openCamera {
    // UIImagePickerControllerCameraDeviceRear 后置摄像头
    // UIImagePickerControllerCameraDeviceFront 前置摄像头
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        NSLog(@"没有摄像头");
        return ;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    // 编辑模式
    imagePicker.allowsEditing = NO;
    imagePicker.navigationBar.opaque = NO;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [self  presentViewController:imagePicker animated:YES completion:^{
        
    }];
}


- (void)reloadDataSource {
    
    
    
}

- (void)openPics {
    
    
    EMSelectPhotos *selectPhotos = [[EMSelectPhotos alloc] init];
    [selectPhotos getAllGroupWithPhotos:^(NSArray *obj) {
        NSLog(@"-------obj:%@",[obj description]);
        
        EMListGroupTableViewController *groupController = [[EMListGroupTableViewController alloc] initWithGroups:obj];
        EMPhotoNavigationController *nav = [[EMPhotoNavigationController alloc] initWithRootViewController:groupController];
        [self presentViewController:nav animated:YES completion:^{

        }];

    }];
    
    return;

//    EMShowPhotosCollectionViewController *vc = [[EMShowPhotosCollectionViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];

//    return;
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    //    picker.view.backgrou ndColor = _controller.view.backgroundColor;
//    picker.navigationBar.tintColor = [UIColor blackColor];
//    //    picker.navigationBar.barTintColor = _controller.navigationController.navigationBar.barTintColor;
//    picker.navigationBar.opaque = NO;
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
//    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
    EMImageEditViewController *imageEditVC = [[EMImageEditViewController alloc] initWithImage:image complete:^(UIImage *clippedImage) {
//        clippedImage 就是裁剪后的图片
        [self dismissViewControllerAnimated:YES completion:^{
            //            此处作上传图像操作
            //            [self uploadImage:clippedImage withUrl:nil];
            
        }];
        
    }];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
