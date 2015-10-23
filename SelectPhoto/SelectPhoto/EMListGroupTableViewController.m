//
//  EMListGroupTableViewController.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/23.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import "EMListGroupTableViewController.h"
#import "EMListGroupTableViewCell.h"
#import "EMSelectPhotos.h"
#import "EMPhotoGroup.h"
#import "EMShowPhotosCollectionViewController.h"
#import "EMPhotoNavigationController.h"

@interface EMListGroupTableViewController ()

@property (nonatomic ,strong)NSArray *groups;

@end

@implementation EMListGroupTableViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithGroups:(NSArray *)groups {
    self = [super init];
    if (self) {
        self.groups = [NSArray arrayWithArray:groups];
        self.title = @"照片";
        
    }
    return self;
}

//默认打开相机胶卷相册
- (void)openCameraRollPhoto {
        if (self.groups && self.groups.count) {
        for (EMPhotoGroup *group in self.groups) {
            if ([group.groupName isEqualToString:@"Camera Roll"] || [group.groupName isEqualToString:@"相机胶卷"]) {
                [self pushToPhotosViewController:group animated:NO];
                break;
            }
        }
    }
}

- (void)pushToPhotosViewController:(EMPhotoGroup *)group animated:(BOOL)animated {
    [group getGroupPhotos:^(id photos) {
        EMShowPhotosCollectionViewController *vc = [[EMShowPhotosCollectionViewController alloc] init];
        vc.title = group.groupName;
        vc.photos = [NSArray arrayWithArray:photos];
        [self.navigationController pushViewController:vc animated:animated];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self openCameraRollPhoto];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EMListGroupTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.rowHeight = 50;
    
}

- (void)pop {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMListGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    EMPhotoGroup *photoGroup = self.groups[indexPath.row];
    cell.thumbGroupImageView.image = photoGroup.thumbImage;
    cell.groupNameLabel.text = photoGroup.groupName;
    cell.assetCountLabel.text = [NSString stringWithFormat:@"(%@)",@(photoGroup.assetsCount)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EMPhotoGroup *group = self.groups[indexPath.row];
    [self pushToPhotosViewController:group animated:YES];
}

@end
