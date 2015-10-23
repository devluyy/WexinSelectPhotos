//
//  EMPhotoCollectionViewCell.h
//  SelectPhoto
//
//  Created by Lyy on 15/10/23.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMPhoto.h"

@interface EMPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *isSelectedButton;

- (void)update:(EMPhoto *)photo;

@end
