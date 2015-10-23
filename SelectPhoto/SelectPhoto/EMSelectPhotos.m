//
//  EMSelectPhotos.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/22.
//  Copyright © 2015年 lyy. All rights reserved.
//


#import "EMSelectPhotos.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "EMPhotoGroup.h"

@interface EMSelectPhotos ()

@property (nonatomic , strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation EMSelectPhotos

#pragma mark -获取所有组
- (void) getAllGroupWithPhotos : (CallBackBlock ) callBack{
    [self getAllGroupPhotos:YES withResource:callBack];
}

- (void) getAllGroupPhotos:(BOOL)allPhotos withResource : (CallBackBlock ) callBack {
    NSMutableArray *groups = [NSMutableArray array];
    //typedef void (^ALAssetsLibraryGroupsEnumerationResultsBlock)(ALAssetsGroup *group, BOOL *stop)
    ALAssetsLibraryGroupsEnumerationResultsBlock assetsReultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            if (allPhotos) {
//                选择照片
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            } else {
//                选择视频
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
            }
            EMPhotoGroup *photoGroup = [[EMPhotoGroup alloc] init];
            photoGroup.group = group;
            photoGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            photoGroup.assetsCount = group.numberOfAssets;
            photoGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            [groups addObject:photoGroup];
        } else {
            callBack(groups);
        }
    };
    
//    ALAssetsGroupLibrary     NS_ENUM_DEPRECATED_IOS(4_0, 9_0) = (1 << 0),         // The Library group that includes all assets.
//    ALAssetsGroupAlbum       NS_ENUM_DEPRECATED_IOS(4_0, 9_0) = (1 << 1),         // All the albums synced from iTunes or created on the device.
//    ALAssetsGroupEvent       NS_ENUM_DEPRECATED_IOS(4_0, 9_0) = (1 << 2),         // All the events synced from iTunes.
//    ALAssetsGroupFaces       NS_ENUM_DEPRECATED_IOS(4_0, 9_0) = (1 << 3),         // All the faces albums synced from iTunes.
//    ALAssetsGroupSavedPhotos NS_ENUM_DEPRECATED_IOS(4_0, 9_0) = (1 << 4),         // The Saved Photos album.
//#if __IPHONE_5_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
//    ALAssetsGroupPhotoStream NS_ENUM_DEPRECATED_IOS(5_0, 9_0) = (1 << 5),         // The PhotoStream album.
//#endif
//    ALAssetsGroupAll         NS_ENUM_DEPRECATED_IOS(4_0, 9_0) = 0xFFFFFFFF,       // The same
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetsReultsBlock failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - Setter & Getter

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (nil == _assetsLibrary)
    {
        _assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    return _assetsLibrary;
}


@end
