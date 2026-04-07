//
//   YQBasePageViewController.h
   

#import "YQBaseViewController.h"
#import "SGPagingView.h"



@protocol YQBasePageViewControllerDataSource <NSObject>

@optional


- (void)pageControllerChanged:(NSInteger)selecteIndex;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YQBasePageViewController : YQBaseViewController<SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;
@property (nonatomic, strong) SGPageTitleViewConfigure *pageConfigure;

@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, weak) id<YQBasePageViewControllerDataSource> dataSource;


@property (nonatomic, assign) BOOL showProgressTitileView;

@end

NS_ASSUME_NONNULL_END
