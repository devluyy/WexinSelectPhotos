//
//  EMPhotoGroup.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/22.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import "EMPhotoGroup.h"
#import "EMPhoto.h"

@implementation EMPhotoGroup

#pragma mark -传入一个组获取组里面的Asset
- (void)getGroupPhotos:(void(^)(id photos))callBackBlcok{
    
    NSMutableArray *assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset *asset , NSUInteger index , BOOL *stop){
        if (asset) {
            EMPhoto *photo = [[EMPhoto alloc] init];
            photo.isSelected = NO;
            photo.photoImage = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
            [assets addObject:photo];
        }else{
            callBackBlcok(assets);
        }
    };
    [self.group enumerateAssetsUsingBlock:result];
 
}

@end
