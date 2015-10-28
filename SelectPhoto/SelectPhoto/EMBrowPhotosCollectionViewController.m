
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

@interface EMBrowPhotosCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    UIButton *_selectImageButton;
    NSInteger _currentPage;
}
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)UIToolbar *toolBar;

@property (nonatomic ,strong)NSMutableArray *doneArray; //修改后的数据源，（此处说的修改，是修改图片的状态）

@end

@implementation EMBrowPhotosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolBar];
    [self.collectionView setContentOffset:CGPointMake(self.clickPhotoLocation *self.view.frame.size.width, 0)];
    
    _selectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectImageButton setImage:[UIImage imageNamed:@"unChecked"] forState:UIControlStateNormal];
    [_selectImageButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [_selectImageButton setSelected:NO];
    _selectImageButton.bounds = CGRectMake(0, 0, 40, 40);
    _selectImageButton.backgroundColor = self.navigationController.navigationBar.barTintColor;
    [_selectImageButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:_selectImageButton];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)selectImage:(UIButton *)sender {
    
    if (_currentPage < self.doneArray.count) {
        EMPhoto *photo = self.doneArray[_currentPage];
        photo.isSelected = !photo.isSelected;
        sender.selected = photo.isSelected;
        [self.doneArray replaceObjectAtIndex:_currentPage withObject:photo];
    }
}

- (void)setPhotos:(NSArray *)photos {
    if (_photos != photos) {
        _photos = photos;
        [self.doneArray removeAllObjects];
        [self.doneArray addObjectsFromArray:_photos];
    }
    
}

- (NSMutableArray *)doneArray {
    if (!_doneArray) {
        _doneArray = [NSMutableArray array];
    }
    return _doneArray;
}

- (void)setClickPhotoLocation:(NSInteger)clickPhotoLocation {
    if (_clickPhotoLocation != clickPhotoLocation) {
        _clickPhotoLocation = clickPhotoLocation;

        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_clickPhotoLocation inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        _currentPage = _clickPhotoLocation;
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
    return self.doneArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    EMPhoto *photo = self.doneArray[indexPath.row];
    [cell update:photo index:indexPath.row];
    cell.isSelectedButton.hidden = YES;
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

#pragma amrk - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    计算当前的页码
    int page = (scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame) * 0.5)/CGRectGetWidth(scrollView.frame);
//    根据不同页码，的photo来改变rightbarButton的状态（图片是否选中状态）
    EMPhoto *photo = self.doneArray[page];
    _selectImageButton.selected = photo.isSelected;
    
    _currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        _currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    }
}

#pragma mark <UICollectionViewDelegate>

#pragma mark - Setter & Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self collectionViewFlowLayout1]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.directionalLockEnabled = YES;
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
        _toolBar.barTintColor = [UIColor colorWithWhite:0 alpha:0.7];
        UIButton *complateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [complateButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [complateButton setTitle:@"全选" forState:UIControlStateNormal];
        [complateButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        complateButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [complateButton.titleLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [complateButton setFrame:CGRectMake(CGRectGetWidth(_toolBar.frame)-60, 0, 60, CGRectGetHeight(_toolBar.frame))];
        [_toolBar addSubview:complateButton];
        
        [self.view addSubview:_toolBar];
    }
    
    return _toolBar;
}

@end
