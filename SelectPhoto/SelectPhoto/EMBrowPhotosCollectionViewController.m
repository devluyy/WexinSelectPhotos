
//
//  EMBrowPhotosCollectionViewController.m
//  SelectPhoto
//
//  Created by Lyy on 15/10/23.
//  Copyright © 2015年 lyy. All rights reserved.
//

#import "EMBrowPhotosCollectionViewController.h"
#import "EMPhotoCollectionViewCell.h"

const NSInteger ToolBarHeight = 44;
//UIColor *const ToolBarBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

@interface EMBrowPhotosCollectionViewController ()<UICollectionViewDataSource>

@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)UIToolbar *toolBar;


@end

@implementation EMBrowPhotosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolBar];
}

- (NSArray *)photos {
    if (!_photos) {
        _photos = [NSArray array];
    }
    return _photos;
}

- (void)setClickPhotoLocation:(NSInteger)clickPhotoLocation {
    if (_clickPhotoLocation != clickPhotoLocation) {
        _clickPhotoLocation = clickPhotoLocation;
        [self.collectionView setContentOffset:CGPointMake(_clickPhotoLocation *self.view.frame.size.width, 0)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    EMPhoto *photo = self.photos[indexPath.row];
    [cell update:photo];
    cell.isSelectedButton.hidden = YES;
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark - Setter & Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self collectionViewFlowLayout1]];
        _collectionView.dataSource = self;
//        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"EMPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout1 {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return flowLayout;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-ToolBarHeight, CGRectGetWidth(self.view.frame), ToolBarHeight)];
        _toolBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        UIButton *complateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [complateButton setBackgroundColor:_toolBar.backgroundColor];
        [complateButton setTitle:@"全选" forState:UIControlStateNormal];
        [complateButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        complateButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [complateButton setFrame:CGRectMake(CGRectGetWidth(_toolBar.frame)-60, 0, 60, CGRectGetHeight(_toolBar.frame))];
        [_toolBar addSubview:complateButton];
        
        [self.view addSubview:_toolBar];
    }
    
    return _toolBar;
}

@end
