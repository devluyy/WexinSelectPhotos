//
//  EMSelectPhotos.h
//  SelectPhoto
//
//  Created by Lyy on 15/10/22.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallBackBlock)(NSArray *obj);

@interface EMSelectPhotos : NSObject

- (void) getAllGroupWithPhotos : (CallBackBlock ) callBack;

@end
