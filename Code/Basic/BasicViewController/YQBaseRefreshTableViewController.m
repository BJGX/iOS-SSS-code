//
//  YQBaseRefreshTableViewController.m

//
//  Created by  on 2018/7/17.
//  
//

#import "YQBaseRefreshTableViewController.h"

@interface YQBaseRefreshTableViewController ()
@property (nonatomic, readonly) UITableViewStyle style;
@property (nonatomic, assign) BOOL showTableBlankView;

@end

@implementation YQBaseRefreshTableViewController
@synthesize rightItems = _rightItems;


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _style = style;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, PUB_NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - PUB_NAVBAR_HEIGHT) style:self.style];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.accessibilityIdentifier = @"table_view";
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = self.defaultFooterView;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor tableBackgroundColor];
    [self.view addSubview:_tableView];
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    _pageCount = 15;
    _page = 0;
    _showRefreshHeader = NO;
    _showRefreshFooter = NO;
    
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.showEmptyView = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccess) name:@"LoginSuccess" object:nil];
    
//    __weak YQBaseRefreshTableViewController *weakSelf = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf tableViewDidTriggerHeaderRefresh];
//    }];
//    self.tableView.mj_header.accessibilityIdentifier = @"refresh_header";
}

- (void)LoginSuccess
{
    
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:_tableView.separatorInset];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:_tableView.separatorInset];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setter

- (void)setShowRefreshHeader:(BOOL)showRefreshHeader
{
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        __weak YQBaseRefreshTableViewController *weakSelf = self;
        if (_showRefreshHeader) {
            
            weakSelf.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerHeaderRefresh)];
            weakSelf.mj_header.accessibilityIdentifier = @"refresh_header";
            weakSelf.tableView.mj_header = weakSelf.mj_header;
        }
        else{
            [weakSelf.tableView setMj_header:nil];
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter
{
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            __weak YQBaseRefreshTableViewController *weakSelf = self;
            weakSelf.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerFooterRefresh)];
            weakSelf.mj_footer.accessibilityIdentifier = @"refresh_footer";
            
            weakSelf.tableView.mj_footer = weakSelf.mj_footer;
        }
        else{
            [self.tableView setMj_footer:nil];
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

- (NSMutableDictionary *)dataDictionary
{
    if (_dataDictionary == nil) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    
    return _dataDictionary;
}

- (UIView *)defaultFooterView
{
    if (_defaultFooterView == nil) {
        _defaultFooterView = [[UIView alloc] init];
    }
    
    return _defaultFooterView;
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


#pragma mark - public refresh

- (void)autoTriggerHeaderRefresh
{
    if (self.showRefreshHeader) {
        [self tableViewDidTriggerHeaderRefresh];
    }
}

- (void)tableViewDidTriggerHeaderRefresh
{
    
}

- (void)tableViewDidTriggerFooterRefresh
{
    
}


- (void)beginFooterRefresh {
    [self.tableView.mj_footer beginRefreshing];
}

- (void)beginHeaderRefresh {
    [self.tableView.mj_header beginRefreshing];
}



- (void)finishTableView:(NSInteger)count {
    
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (count == -1) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            if (self.dataArray.count == 0) {
                [self showBlankView];
            }
            return;
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        if (count < self.pageCount) {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
        [self showBlankView];
    });
}



- (void)showBlankView
{
    
    if ([YQNetwork isNotReachable]) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        _noMoreDataView.titleLabel.text = @"暂无网络".localized;
        _noMoreDataView.iconImageView.image = [UIImage imageNamed:@"icon_no_wangluo"];
        self.tableView.tableFooterView = self.noMoreDataView;
        self.showRefreshFooter = NO;
        return;
    }
    
    
    if (!self.showEmptyView) {
        return;
    }
    
    if (self.dataArray.count == 0) {
        
        if (_noMoreDataView) {
            self.noMoreDataView.titleLabel.text = @"暂无内容".localized;
            self.noMoreDataView.iconImageView.image = [UIImage imageNamed:@"icon_kongbai"];
            self.tableView.tableFooterView = self.noMoreDataView;
            self.showRefreshFooter = NO;
        }
        
        
    }
    else {
        self.tableView.tableFooterView = self.defaultFooterView;
    }
}

- (void)setShowEmptyView:(BOOL)showEmptyView
{
    if (_showEmptyView != showEmptyView) {
        _showEmptyView = showEmptyView;
        self.noMoreDataView.titleLabel.text = @"暂无内容".localized;
        self.noMoreDataView.iconImageView.image = [UIImage imageNamed:@"icon_kongbai"];
    }
}

- (YQEmptyView *)noMoreDataView{
    if (!_noMoreDataView) {
        _noMoreDataView = [YQEmptyView initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height*0.9)];
    }
    return _noMoreDataView;
}


- (void)registerCellWithNib:(NSString *)className {
    [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
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
