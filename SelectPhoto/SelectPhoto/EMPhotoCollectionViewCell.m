//
//  EMPhotoCollectionViewCell.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/23.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import "EMPhotoCollectionViewCell.h"

@interface EMPhotoCollectionViewCell()
{
    NSInteger _index;
    EMPhoto *_photo;
}
@end

@implementation EMPhotoCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.isSelectedButton setImage:[UIImage imageNamed:@"unChecked"] forState:UIControlStateNormal];
    [self.isSelectedButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
}

- (void)update:(EMPhoto *)photo index:(NSInteger)index{
    
    self.photoImageView.image = photo.photoImage;
    self.isSelectedButton.selected = photo.isSelected;

    _index = index;
    _photo = photo;
}
- (IBAction)isSelectedAction:(id)sender {
    
    self.isSelectedButton.selected = !self.isSelectedButton.selected;
    if ([self.delegate respondsToSelector:@selector(didSelectPhoto:index:)]) {
        _photo.isSelected = self.isSelectedButton.selected;
        [self.delegate didSelectPhoto:_photo index:_index];
    }
}

@end
