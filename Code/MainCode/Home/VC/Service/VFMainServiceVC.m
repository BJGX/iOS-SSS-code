//
//  VFMainServiceVC.m
//  VFProject
//


//

#import "VFMainServiceVC.h"
#import "VFSubServiceVC.h"
#import "VFMainFeedBcakVC.h"

@interface VFMainServiceVC ()

@end

@implementation VFMainServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"选择节点";
    self.pageConfigure.titleSelectedColor = [UIColor mainTextColor];
    self.pageConfigure.titleColor = [UIColor subTextColor];
    self.pageConfigure.indicatorColor = [UIColor appThemeColor];
    
    if ([QYSettingConfig shared].isReview) {
        self.titleArray = @[@"全部",@"推荐"];
    }
    else{
        self.titleArray = @[@"全部",@"VIP", @"免费",@"推荐"];
    }
    self.pageTitleView.mj_h = 50;
    NSMutableArray *array = [NSMutableArray new];
    [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VFSubServiceVC *vc = [VFSubServiceVC new];
        vc.type = idx;
        [array addObject:vc];
    }];
    self.vcArray = array;
    UIButton *rightBtn = [UIButton buttonWithNormalImage:@"icon_kefu" selectedImage:@"icon_kefu" superView:self.navigationBar btnClick:^(UIButton *btn) {
        VFMainFeedBcakVC *vc = [VFMainFeedBcakVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [rightBtn setTitle:@"工单反馈".localized forState:0];
    [rightBtn setTitleColor:[UIColor mainTextColor] forState:0];
    rightBtn.titleLabel.font = Font(14);
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.width.offset(70);
        make.height.offset(35);
        make.centerY.mas_equalTo(self.navigationBar.navTitleLabel);
    }];
    [rightBtn layoutIfNeeded];
    rightBtn.upImageAndDownLableWithSpace = 5;
    [rightBtn sizeToFit];
    // Do any additional setup after loading the view.
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
