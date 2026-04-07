//
//   YQBaseRefreshCollectionController.h
   

#import <UIKit/UIKit.h>
#import "YQBaseViewController.h"
#import "YQEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YQBaseRefreshCollectionController : YQBaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) UICollectionView *collectionView;

/** @brief tableView的数据源，用户UI显示 */
@property (strong, nonatomic) NSMutableArray *dataArray;


/** @brief 当前加载的页数 */
@property (nonatomic) int page;


/** @brief 是否启用下拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshHeader;
/** @brief 是否启用上拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshFooter;


@property (nonatomic, strong) YQEmptyView *noMoreDataView;

/** @brief 是否显示无数据时的空白提示，默认为NO(未实现提示页面) */
@property (nonatomic) BOOL showTableBlankView;


- (void)beginHeaderRefresh;

- (void)beginFooterRefresh;

/*!
 下拉加载更多(下拉刷新)
 */
- (void)headerTriggerRefresh;

/*!
上拉加载更多
 */
- (void)footerDidTriggerRefresh;


- (void)finishTableView: (NSInteger)count;


- (void)registerCellWithNib: (NSString *)className;

- (void)registerCellWithClass:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
