//
//   YQBaseHeaderPageViewController.m
   

#import "YQBaseHeaderPageViewController.h"

@interface YQBaseHeaderPageViewController ()


///滚动相关
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) NSInteger scrollCode;

@end

@implementation YQBaseHeaderPageViewController

- (SGPageTitleViewConfigure *)pageConfigure
{
    if (!_pageConfigure) {
        _pageConfigure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        _pageConfigure.needBounces = NO;
        _pageConfigure.showBottomSeparator = NO;
        _pageConfigure.titleFont = Font(16);
        _pageConfigure.titleSelectedFont = [YQUtils systemMediumFontOfSize:16];
        _pageConfigure.titleColor = kBlackColor;
        _pageConfigure.titleSelectedColor = kBlackColor;
        _pageConfigure.titleAdditionalWidth = 0;
        _pageConfigure.titleGradientEffect = NO;
        
        
        _pageConfigure.showIndicator = YES;
        _pageConfigure.indicatorToBottomDistance = 5;
        _pageConfigure.indicatorColor = [UIColor appThemeColor];
        _pageConfigure.indicatorHeight = 2;
        _pageConfigure.indicatorFixedWidth = 24;
        _pageConfigure.indicatorToBottomDistance = 2;
        _pageConfigure.indicatorCornerRadius = 1;
        _pageConfigure.indicatorStyle = SGIndicatorStyleFixed;
        
    }
    return _pageConfigure;
}


- (void)setVcArray:(NSArray *)vcArray
{
    _vcArray = vcArray;
    if (self.pageContentCollectionView == nil) {
        self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height - PUB_NAVBAR_HEIGHT) parentVC:self childVCs:vcArray];
        _pageContentCollectionView.delegatePageContentCollectionView = self;
        _pageContentCollectionView.isAnimated = YES;
        self.tableView.tableFooterView = self.pageContentCollectionView;
    }
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    if (self.pageTitleView == nil) {
        self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(20, PUB_NAVBAR_HEIGHT, ScreenWidth - 40, 40) delegate:self titleNames:titleArray configure:self.pageConfigure];
        self.pageTitleView.backgroundColor = [UIColor clearColor];
        [self.headerView addSubview:_pageTitleView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}


- (void)initUI
{
    _tableView = [[YQTableView alloc] initWithFrame:CGRectMake(0, PUB_NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - PUB_NAVBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.accessibilityIdentifier = @"table_view";
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = normalBackgroundColor;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor backGroundColor];
    [self.view addSubview:_tableView];
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    _tableView.bounces = NO;
    
    
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    self.headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.headerView;
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(mianScroll)
                                                name:@"leaveTop"
                                              object:nil];
}

- (void)mianScroll {
    self.canScroll = YES;
}







- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView index:(NSInteger)index
{
    self.pageTitleView.selectedIndex = index;
    if ([self.dataSource respondsToSelector:@selector(pageControllerChanged:)]) {
        [self.dataSource pageControllerChanged:index];
    }
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];

}


//MARK: - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }
    
    
    NSLog(@"%f", scrollView.contentOffset.y);
    CGFloat y = scrollView.contentOffset.y;
    CGFloat header = _pageTitleView.frame.origin.y;
    
    if ([self.dataSource respondsToSelector:@selector(scrollHeaderProgress:)]) {
        CGFloat p = y / header;
        p = p > 1 ? 1 : p;
        p = p < 0 ? 0 : p;
        [self.dataSource scrollHeaderProgress:p];
    }
    
    
    if (y == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"subTableScroll" object:@(YES)];
        return;;
        
    }
    if (y>=header) {
        scrollView.contentOffset = CGPointMake(0, header);
        if (self.canScroll) {
            self.canScroll = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"subTableScroll" object:@(YES)];
    }
    else {
        
        
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, header);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"subTableScroll" object:@(YES)];
        }else {
            scrollView.contentOffset = CGPointMake(0, y);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"subTableScroll" object:@(NO)];
        }
    }
    
    
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:_tableView.separatorInset];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:_tableView.separatorInset];
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KCELLDEFAULTHEIGHT;
}




@end
