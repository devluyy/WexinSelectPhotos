//
//  EMPhotoGroup.h
//  SelectPhoto
//
//  Created by Lyy on 15/10/22.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface EMPhotoGroup : NSObject

/**
 *  组名
 */
@property (nonatomic , copy) NSString *groupName;

/**
 *  组的真实名
 */
@property (nonatomic , copy) NSString *realGroupName;

/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;

/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger assetsCount;

/**
 *  类型 : Saved Photos...
 */
@property (nonatomic , copy) NSString *type;

@property (nonatomic , strong) ALAssetsGroup *group;

- (void)getGroupPhotos:(void(^)(id photos))callBackBlcok;


@end
