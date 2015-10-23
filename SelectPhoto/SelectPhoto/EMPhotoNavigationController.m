//
//  EMPhotoNavigationController.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/23.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import "EMPhotoNavigationController.h"

@interface EMPhotoNavigationController ()

@end

@implementation EMPhotoNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setBarTintColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
