//
//  EMImageEditViewController.h
//  PictureSelector
//
//  Created by Lyy on 15/8/21.
//  Copyright (c) 2015年 Lyy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  编辑图片
 */

@interface EMImageEditViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image
                     complete:(void (^)(UIImage *clippedImage))complete;
@end
