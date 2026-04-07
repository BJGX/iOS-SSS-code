//
//   YQBasePageViewController.m
   

#import "YQBasePageViewController.h"

@interface YQBasePageViewController ()

@end

@implementation YQBasePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (SGPageTitleViewConfigure *)pageConfigure
{
    if (!_pageConfigure) {
        _pageConfigure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        _pageConfigure.needBounces = NO;
        _pageConfigure.showBottomSeparator = NO;
        _pageConfigure.titleFont = Font(15);
        _pageConfigure.titleSelectedFont = [YQUtils systemMediumFontOfSize:16];
        _pageConfigure.titleColor = rgb(153, 153, 153);
        _pageConfigure.titleSelectedColor = [UIColor mainTextColor];
        _pageConfigure.titleAdditionalWidth = 0;
        _pageConfigure.titleGradientEffect = NO;
        
        
        _pageConfigure.showIndicator = YES;
        _pageConfigure.indicatorToBottomDistance = 5;
        _pageConfigure.indicatorColor = [UIColor appThemeColor];
        _pageConfigure.indicatorHeight = 2;
        _pageConfigure.indicatorFixedWidth = 24;
//        _pageConfigure.indicatorToBottomDistance = 10;
        _pageConfigure.indicatorCornerRadius = 1;
        _pageConfigure.indicatorStyle = SGIndicatorStyleFixed;
        
    }
    return _pageConfigure;
}

- (void)setVcArray:(NSArray *)vcArray
{
    _vcArray = vcArray;
    if (self.pageContentCollectionView == nil) {
        CGFloat y = CGRectGetMaxY(self.pageTitleView.frame);
        self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, self.view.frame.size.height - y) parentVC:self childVCs:vcArray];
        _pageContentCollectionView.delegatePageContentCollectionView = self;
        _pageContentCollectionView.isAnimated = YES;
        [self.view addSubview:self.pageContentCollectionView];
    }
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    if (self.pageTitleView == nil) {
        self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(20, PUB_NAVBAR_HEIGHT, ScreenWidth - 40, 40) delegate:self titleNames:titleArray configure:self.pageConfigure];
        self.pageTitleView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_pageTitleView];
    }
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
    
    

//    NSLog(@"progress == %f", progress);
//    if (progress != 0) {
//        
//    }
//
//    if (progress == 1 || progress == 0) {
//        if ([self.dataSource respondsToSelector:@selector(pageControllerChanged:)]) {
//            [self.dataSource pageControllerChanged:targetIndex];
//        }
//
//
//    }
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
