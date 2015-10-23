//
//  EMImageEditViewController.m
//  PictureSelector
//
//  Created by Lyy on 15/8/21.
//  Copyright (c) 2015年 Lyy. All rights reserved.
//

#import "EMImageEditViewController.h"
#import "EMImageCropView.h"

typedef void(^Complete)(UIImage *clippedImage);

@interface EMImageEditViewController ()
{
    EMImageCropView *_imageCropView;
    UIImage *_image;
}
@property (nonatomic ,copy)Complete complete;

@end

@implementation EMImageEditViewController

- (instancetype)initWithImage:(UIImage *)image
                     complete:(void (^)(UIImage *clippedImage))complete {
    if (self = [super init]) {
        self.complete = complete;
        _image = image;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    self.title = @"裁剪图片";
    
    _imageCropView = [[EMImageCropView alloc] initWithFrame:self.view.bounds];
    CGFloat cropSquare = MIN(CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds));
    [_imageCropView originalImage:_image cropSquareSide:cropSquare];
    
    [self.view addSubview:_imageCropView];

    self.view.backgroundColor = [UIColor blackColor];
    self.view.layer.masksToBounds = YES;
    
    [self createRightBarButton];
}

- (void)createRightBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    [button setTitle:@"使用" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 4;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)save {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    self.complete(_imageCropView.cropImage);
}

- (void)dealloc {
    NSLog(@"-------------Image Edit--------------");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
