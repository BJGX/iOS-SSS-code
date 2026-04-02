//
//   YQBaseRefreshCollectionController.m
   

#import "YQBaseRefreshCollectionController.h"



@interface YQBaseRefreshCollectionController ()

@end

@implementation YQBaseRefreshCollectionController


//MARK: - collection
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 8;
        _layout.minimumInteritemSpacing = 8;
        _layout.itemSize = CGSizeMake(100, 100);
    }
    return _layout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, PUB_NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - PUB_NAVBAR_HEIGHT) collectionViewLayout:self.layout];
    _collectionView.accessibilityIdentifier = @"collection_view";
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.clipsToBounds = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    self.showTableBlankView = YES;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.view.backgroundColor = [UIColor backGroundColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
}


#pragma mark - setter

- (void)setShowRefreshHeader:(BOOL)showRefreshHeader
{
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            __weak YQBaseRefreshCollectionController *weakSelf = self;
            self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf headerTriggerRefresh];
            }];
            self.collectionView.mj_header.accessibilityIdentifier = @"refresh_header";
        }
        else{
            [self.collectionView setMj_header:nil];
        }
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter
{
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            __weak YQBaseRefreshCollectionController *weakSelf = self;
            self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf footerDidTriggerRefresh];
            }];
            self.collectionView.mj_footer.accessibilityIdentifier = @"refresh_footer";
        }
        else{
            [self.collectionView setMj_footer:nil];
        }
    }
}


- (void)setShowTableBlankView:(BOOL)showTableBlankView
{
    if (_showTableBlankView != showTableBlankView) {
        _showTableBlankView = showTableBlankView;
    }
}

#pragma mark - getter

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}




#pragma mark - public refresh

- (void)autoTriggerHeaderRefresh
{
    if (self.showRefreshHeader) {
        [self headerTriggerRefresh];
    }
}

- (void)headerTriggerRefresh
{
    
}

- (void)footerDidTriggerRefresh
{
    
}


- (void)beginFooterRefresh {
    [self.collectionView.mj_footer beginRefreshing];
}

- (void)beginHeaderRefresh {
    [self.collectionView.mj_header beginRefreshing];
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    
}

- (void)finishTableView:(NSInteger)count {
    
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (count == -1) {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            return;
        }
        
        [weakSelf.collectionView.mj_header endRefreshing];
        if (count < 15) {
            weakSelf.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else {
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
        [weakSelf.collectionView reloadData];
        if (self.showTableBlankView) {
            [self showBlankView];
        }
    });
}



- (void)registerCellWithClass:(NSString *)className {
    [self.collectionView registerClass:[className class] forCellWithReuseIdentifier:className];
}

- (void)registerCellWithNib:(NSString *)className {
    [self.collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:className];
}


- (void)showBlankView
{
    
    
    
    if ([YQNetwork isNotReachable]) {
        [self.dataArray removeAllObjects];
        [self.collectionView reloadData];
        self.noMoreDataView.titleLabel.text = @"暂无网络";
        self.noMoreDataView.iconImageView.image = [UIImage imageNamed:@"icon_no_wangluo"];
        [self.view addSubview: self.noMoreDataView];
        self.showRefreshFooter = NO;
        return;
    }
    
    if (self.dataArray.count == 0) {
        self.noMoreDataView.titleLabel.text = @"暂无内容";
        self.noMoreDataView.iconImageView.image = [UIImage imageNamed:@"icon_kongbai"];
        self.showRefreshFooter = NO;
        [self.view addSubview: self.noMoreDataView];
    }
    else {
        [self.noMoreDataView removeFromSuperview];
    }
}


- (YQEmptyView *)noMoreDataView{
    if (!_noMoreDataView) {
        _noMoreDataView = [YQEmptyView initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.collectionView.frame.size.height * 0.6)];
        _noMoreDataView.userInteractionEnabled = NO;
    }
    return _noMoreDataView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
