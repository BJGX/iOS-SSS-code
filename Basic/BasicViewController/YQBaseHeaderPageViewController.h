//
//   YQBaseHeaderPageViewController.h
   

#import "YQBaseRefreshTableViewController.h"
#import "SGPagingView.h"
#import "YQTableView.h"

@protocol YQBaseHeaderPageViewControllerDataSource <NSObject>

@optional


- (void)pageControllerChanged:(NSInteger)selecteIndex;

- (void)scrollHeaderProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YQBaseHeaderPageViewController : YQBaseViewController<SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;
@property (nonatomic, strong) SGPageTitleViewConfigure *pageConfigure;

@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, weak) id<YQBaseHeaderPageViewControllerDataSource> dataSource;
@property (nonatomic, assign) BOOL showProgressTitileView;

@property (nonatomic, strong) UIView *headerView;


@property (strong, nonatomic) YQTableView *tableView;

@end

NS_ASSUME_NONNULL_END
