//
//  EMListGroupTableViewCell.h
//  SelectPhoto
//
//  Created by Lyy on 15/10/23.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMListGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbGroupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetCountLabel;

@end
