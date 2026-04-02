//
//  YQBaseRefreshTableViewController.h

//
//  Created by  on 2018/7/17.
//  
//

#import <UIKit/UIKit.h>
#import "YQBaseViewController.h"
#import "YQEmptyView.h"
#import <MJRefreshNormalHeader.h>


/** @brief tabeleView的cell高度 */
#define KCELLDEFAULTHEIGHT 50
@interface YQBaseRefreshTableViewController : YQBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_rightItems;
}


/** @brief 导航栏右侧BarItem */
@property (strong, nonatomic) NSArray *rightItems;
/** @brief 默认的tableFooterView */
@property (strong, nonatomic) UIView *defaultFooterView;

@property (strong, nonatomic) UITableView *tableView;

/** @brief tableView的数据源，用户UI显示 */
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *dataDictionary;


@property (nonatomic, strong) MJRefreshNormalHeader *mj_header;

@property (nonatomic, strong) MJRefreshBackNormalFooter *mj_footer;

/** @brief 当前加载的页数 */
@property (nonatomic) int page;

/** @brief 是否启用下拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshHeader;
/** @brief 是否启用上拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshFooter;

///每页数量 默认15
@property (nonatomic, assign) NSInteger pageCount;

///默认yes 显示空白页面
@property (nonatomic, assign) BOOL showEmptyView;

///空白显示
@property (nonatomic, strong) YQEmptyView *noMoreDataView;


- (instancetype)initWithStyle:(UITableViewStyle)style;


- (void)beginHeaderRefresh;

- (void)beginFooterRefresh;


- (void)tableViewDidTriggerHeaderRefresh;


- (void)tableViewDidTriggerFooterRefresh;

- (void)finishTableView: (NSInteger)count;


- (void)registerCellWithNib: (NSString *)className;


- (void)LoginSuccess;

@end
