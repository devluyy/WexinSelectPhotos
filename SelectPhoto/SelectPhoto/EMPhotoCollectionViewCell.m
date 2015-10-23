//
//  EMPhotoCollectionViewCell.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/23.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import "EMPhotoCollectionViewCell.h"

@implementation EMPhotoCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.isSelectedButton setImage:[UIImage imageNamed:@"unChecked"] forState:UIControlStateNormal];
    [self.isSelectedButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
}

- (void)update:(EMPhoto *)photo {
    
    self.photoImageView.image = photo.photoImage;
    self.isSelectedButton.selected = photo.isSelected;

}
- (IBAction)isSelectedAction:(id)sender {
    
    self.isSelectedButton.selected = !self.isSelectedButton.selected;
}

@end
