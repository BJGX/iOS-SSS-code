//
//  VFMainFeedBcakVC.m
//  VFProject
//


//

#import "VFMainFeedBcakVC.h"
#import "VFSubFeedBackVC.h"
#import "VFAddFeedbackVC.h"
#import "SSNewAddFeedbackVC.h"

@interface VFMainFeedBcakVC ()

@end

@implementation VFMainFeedBcakVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor subBackgroundColor];
    self.navigationBar.backgroundColor = [UIColor subBackgroundColor];
    self.navTitle = @"反馈";
    self.pageConfigure.titleSelectedColor = [UIColor whiteColor];
    self.pageConfigure.titleColor = [UIColor subTextColor];
    self.pageConfigure.titleBackgroundColor = [[UIColor appThemeColor] colorWithAlphaComponent:0.2];
    self.pageConfigure.titleSelectedBackgroundColor = [UIColor appThemeColor];
    self.pageConfigure.showBottomSeparator = NO;
    self.pageConfigure.showIndicator = NO;
    self.pageConfigure.titleAdditionalWidth = 50;
    self.pageConfigure.indicatorStyle = SGIndicatorStyleFixedSpace;
    self.pageConfigure.itemSpace = 10;
    self.pageConfigure.itemCornerRadius = 12;
    
    
//    self.pageConfigure.indicatorColor = [UIColor appThemeColor];
//    self.pageConfigure.indicatorHeight = 4;
//    self.pageConfigure.indicatorCornerRadius = 2;
//    self.pageConfigure.indicatorFixedWidth = 40;
    
    
    self.titleArray = @[@"全部".localized,@"等待回复".localized, @"已回复".localized];
    
    self.pageTitleView.backgroundColor = [UIColor subBackgroundColor];
    
    self.pageTitleView.mj_h = 30;
    if ([DeviceHelper isiPadOnMac]) {
        self.pageTitleView.mj_y += 20;
    }
    NSMutableArray *array = [NSMutableArray new];
    [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VFSubFeedBackVC *vc = [VFSubFeedBackVC new];
        vc.type = idx;
        
        [array addObject:vc];
    }];
    self.vcArray = array;
    self.pageContentCollectionView.backgroundColor = [UIColor tableBackgroundColor];
    self.pageContentCollectionView.collectionView.backgroundColor = [UIColor tableBackgroundColor];
    
    self.pageContentCollectionView.mj_h = ScreenHeight - PUB_NAVBAR_HEIGHT - 200;
//    self.pageContentCollectionView.mj_w = ScreenWidth;
    
    UIRectCorner r = UIRectCornerTopLeft | UIRectCornerTopRight;
    [YQUtils clipTheViewCornerWithCorner:r andView:self.pageContentCollectionView andCornerRadius:10];
    
    
    
    UIView *bottomView = [UIView viewWithFrame:CGRectZero backgroundColor:[UIColor tableBackgroundColor] superView:self.view];
    
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.offset(150);
    }];
    
    
    UIButton *sureBtn = [UIButton buttonWithTitle:@"提交新的反馈" titleColor:[UIColor whiteColor] font:[YQUtils systemMediumFontOfSize:17] backgroundColor:[UIColor appThemeColor] superView:bottomView btnClick:^(UIButton *btn) {
//        VFAddFeedbackVC *vc = [VFAddFeedbackVC new];
//        vc.modalPresentationStyle = UIModalPresentationCustom;
//        [self presentViewController:vc animated:YES completion:nil];
        SSNewAddFeedbackVC *vc = [SSNewAddFeedbackVC new];
//        [vc setCompleteAdd:^{
//                    
//        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
//    [sureBtn setImage:[UIImage imageNamed:@"icon_f_add"] forState:0];
//    [sureBtn setBackgroundImage:[UIImage imageNamed:@"icon_mine_btn1"] forState:0];
    sureBtn.cornerRadius = 12;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.left.offset(15);
        make.height.offset(45);
        make.bottom.offset(-25);
    }];
    
    
    UIButton *btn = [UIButton buttonWithTitle:@" 在线客服" titleColor:[UIColor appThemeColor] font:Font(11) backgroundColor:[UIColor whiteColor] normalImage:@"icon_l_kf" selectedImage:@"icon_l_kf" superView:bottomView layoutBlock:nil btnClick:^(UIButton *btn) {
        [QYCommonFuncation shouKefu];
    }];
    btn.cornerRadius = 13;
    btn.yy_contentEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 6);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(sureBtn);
        make.bottom.mas_equalTo(sureBtn.mas_top).offset(-20);
//        make.width.offset(80);
        make.height.offset(26);
    }];
    
    
    
    
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
