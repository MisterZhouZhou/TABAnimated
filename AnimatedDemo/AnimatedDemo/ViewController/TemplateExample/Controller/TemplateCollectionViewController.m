//
//  TemplateCollectionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/8.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TemplateCollectionViewController.h"

#import "DailyCollectionViewCell.h"
#import "CourseCollectionViewCell.h"
#import "TABTemplateCollectionViewCell.h"
#import "TemplateSecondCollectionViewCell.h"

#import "TABAnimatedObject.h"

#import "TABAnimated.h"

#import "Game.h"
#import <TABKit/TABKit.h>
#import "MJRefresh.h"

@interface TemplateCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation TemplateCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
    [self.collectionView.mj_header beginRefreshing];
}

- (void)dealloc {
    
}

#pragma mark - Target Methods

/**
 获取到数据后
 */
- (void)afterGetData {
    
    [dataArray removeAllObjects];
    // 模拟数据
    for (int i = 0; i < 5; i ++) {
        [dataArray addObject:[NSObject new]];
    }
    
    // 停止动画,并刷新数据
    [self.collectionView tab_endAnimation];
    // 解决结束刷新闪动问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.1), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)getData {
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:2];
}

- (void)getMoreData {
    
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [CourseCollectionViewCell cellSizeWithWidth:kScreenWidth];
    }
    return [DailyCollectionViewCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return .1;
    }
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CourseCollectionViewCell *cell = [CourseCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
        return cell;
    }
    
    DailyCollectionViewCell *cell = [DailyCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[CourseCollectionViewCell class]]) {
        CourseCollectionViewCell *myCell = (CourseCollectionViewCell *)cell;
        [myCell updateWithModel:nil];
    }
    DailyCollectionViewCell *myCell = (DailyCollectionViewCell *)cell;
    [myCell updateWithModel:nil];
}

#pragma mark - Initize Methods

- (void)initData {
    dataArray = [NSMutableArray array];
}

/**
 initialize view
 初始化视图
 */
- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:[CourseCollectionViewCell cellIdentifier]];
    [self.collectionView registerClass:[DailyCollectionViewCell class] forCellWithReuseIdentifier:[DailyCollectionViewCell cellIdentifier]];
    
    [self.collectionView tab_startAnimation];
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)            collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;

        _collectionView.tabAnimated = [TABAnimatedObject animatedWithTemplateClass:[TABTemplateCollectionViewCell class]];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    }
    return _collectionView;
}

@end
