//
//  EMShowPhotosCollectionViewController.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/22.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import "EMShowPhotosCollectionViewController.h"
#import "EMSelectPhotos.h"
#import "EMPhotoGroup.h"
#import "EMPhoto.h"
#import "EMPhotoCollectionViewCell.h"
#import "EMBrowPhotosCollectionViewController.h"

@interface EMShowPhotosCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,EMPhotoCollectionViewCellDelegate>

//@property (nonatomic ,strong)NSArray *items;
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)NSMutableArray *doneArray;

@end

@implementation EMShowPhotosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    [self collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.photos) {
        [self.collectionView reloadData];
    }
}

- (void)pop {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPhotos:(NSArray *)photos {
    if (_photos != photos) {
        _photos = photos;
        [self.doneArray removeAllObjects];
        [self.doneArray addObjectsFromArray:_photos];
        [self.collectionView reloadData];
    }
    
}

- (NSMutableArray *)doneArray {
    if (!_doneArray) {
        _doneArray = [NSMutableArray array];
    }
    return _doneArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.doneArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.backgroundColor = [UIColor redColor];
    EMPhoto *photo = self.doneArray[indexPath.row];
    
    [cell update:photo index:indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EMBrowPhotosCollectionViewController *browPhotoVC = [[EMBrowPhotosCollectionViewController alloc] init];
    browPhotoVC.photos = [NSArray arrayWithArray:self.doneArray];
    browPhotoVC.clickPhotoLocation = indexPath.row;
    [self.navigationController pushViewController:browPhotoVC animated:YES];
    
}

- (void)didSelectPhoto:(EMPhoto *)photo index:(NSInteger)index {
    [self.doneArray replaceObjectAtIndex:index withObject:photo];
}

#pragma mark - Setter & Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self collectionViewFlowLayout1]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_collectionView];
        [_collectionView registerNib:[UINib nibWithNibName:@"EMPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout1 {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width/4.0 - 5, self.view.frame.size.width/4.0 - 5);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5;
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return flowLayout;
}

@end
