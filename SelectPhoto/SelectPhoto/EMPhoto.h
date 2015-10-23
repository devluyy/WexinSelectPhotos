//
//  EMPhoto.h
//  SelectPhoto
//
//  Created by Lyy on 15/10/22.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMPhoto : NSObject

/**
 *  相册图片
 */
@property (nonatomic , strong) UIImage *photoImage;

@property (nonatomic ,assign) BOOL isSelected;

@end
