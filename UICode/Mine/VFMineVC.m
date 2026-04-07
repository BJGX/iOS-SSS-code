

#import "VFMineVC.h"
#import "VFMineCell.h"
#import "VFTipsView.h"
#import "VFHelpVC.h"
#import "VFMainFeedBcakVC.h"
#import "VFBindMoblieVC.h"
#import "VFAccountVC.h"
#import "VFChangedPasswordVC.h"
#import "SSNoticeListVC.h"

@interface VFMineVC ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *IDLabel;
@property (nonatomic, strong) UIView *vipView;
@end

@implementation VFMineVC


- (void)initUI
{
    WeakSelf;
    [self hiddenNavigationBarLeftButton];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navTitle = @"个人中心";
    [self registerCellWithNib:VFMineCell.className];
    NSArray *array = @[@"我的账号",
                       [YQUserModel shared].user.tourist == 1 ? @"绑定手机" : @"修改密码",
                       @"帮助中心",
                       @"线上反馈",
                       @"官方网站",
                       @"版本更新",
                       @"退出登录",
    ];
    [self.dataArray addObjectsFromArray:array];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor subBackgroundColor];
    
    UILabel *footerLabel = [UILabel YQLabelWithString:[NSString stringWithFormat:@"%@: %@",@"版本号".localized, App_Ver] textColor:rgba(133, 138, 157, 1) font:Font(14) superView:self.view];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.mj_h = 40;
    [footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.offset(-20);
    }];
    
    
    CGFloat top = 0;
    if (![DeviceHelper isiPhone]) {
        top = 40;
        self.navigationBar.mj_y = top;
    }
    
    UIImageView *back = [[UIImageView alloc]init];
    back.image = [UIImage imageNamed:@"icon_mine_back"];
    [self.view insertSubview:back atIndex:0];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
    }];
    
    UIView *userView = [UIView viewWithFrame:CGRectMake(20, PUB_NAVBAR_HEIGHT + 10 + top, ScreenWidth -40, 85) backgroundColor:rgba(255, 248, 242, 1) superView:self.view];
    
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(85);
        make.top.offset(PUB_NAVBAR_HEIGHT + 10 + top);
    }];
    
    
    userView.cornerRadius = 12;
    [userView addTapActionWithBlock:^(UIGestureRecognizer * _Nullable sender) {
        VFAccountVC *vc = [VFAccountVC new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    UIImageView *avatar = [[UIImageView alloc] init];
    [userView addSubview:avatar];
    avatar.image = [UIImage imageNamed:@"icon_l_Cap"];
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(userView);
        make.left.offset(10);
        make.width.height.offset(42);
    }];
    avatar.cornerRadius = 21;
    
    self.nameLabel = [UILabel YQLabelWithString:@"123" textColor:rgba(240, 125, 125, 1) font:Font(14) superView:userView];
    self.nameLabel.frame = CGRectMake(62, 15, 250, 22);
    
    self.IDLabel = [UILabel YQLabelWithString:@"123" textColor:rgba(240, 125, 125, 1) font:Font(14) superView:userView];
    self.IDLabel.frame = CGRectMake(62, 32, 200, 22);
    
    UIImageView *vipImage = [[UIImageView alloc] init];
    [userView addSubview:vipImage];
    vipImage.image = [UIImage imageNamed:@"icon_vip"];
    [vipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-15);
        make.left.offset(62);
    }];
    
    
    
    UIImageView *bigVip = [[UIImageView alloc] init];
    [userView addSubview:bigVip];
    bigVip.image = [UIImage imageNamed:@"icon_big_vip"];
    [bigVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.mas_equalTo(userView);
    }];
    
    
    
//    avatar.cornerRadius = 21;
    
    self.vipView = [[UIView alloc] init];
    [userView addSubview:self.vipView];
    self.vipView.backgroundColor = userView.backgroundColor;
    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-12);
        make.left.offset(62);
        make.height.offset(22);
    }];
    
    UILabel *tipsLabel = [UILabel YQLabelWithString:@"未开通会员" textColor:[UIColor subTextColor] font:Font(12) superView:self.vipView];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.height.offset(22);
    }];
//    tipsLabel.frame = CGRectMake(0, 0, 70, 22);
   
    UIButton *buyBtn = [UIButton buttonWithTitle:@"立即订阅" titleColor:[UIColor whiteColor] font:Font(12) backgroundColor:rgba(240, 125, 125, 1) superView:self.vipView btnClick:^(UIButton *btn) {
        weakSelf.tabBarController.selectedIndex = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedTabbarIndex" object:@(1)];
    }];
//    buyBtn.frame = CGRectMake(80, 1, 70, 20);
    buyBtn.cornerRadius = 11;
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.left.mas_equalTo(tipsLabel.mas_right).offset(15);
        make.height.offset(22);
    }];
    buyBtn.yy_contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
 
    
    
    
    self.tableView.cornerRadius = 12;
    
    CGFloat height = (self.dataArray.count+1) * 61;
    self.tableView.frame = CGRectMake(20, CGRectGetMaxY(userView.frame)+15, ScreenWidth-40, height);
    NSLog(@"123");
    
    
//    未开通会员
    
   
    
    
    
}

- (void)reloadUI
{
    self.nameLabel.text = [YQUserModel shared].user.account ?: [YQUserModel shared].user.mail;
    self.IDLabel.text = [NSString stringWithFormat:@"ID:%@",[YQUserModel shared].user.ID];
    self.vipView.hidden = [YQUserModel shared].user.is_vip == 1 ? YES : NO;
    [self.tableView reloadData];
    CGFloat height = (self.dataArray.count) * 60;
    self.tableView.mj_h = height;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    WeakSelf;
    [QYCommonFuncation getUserInfo:^(NSInteger code) {
        [weakSelf reloadUI];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];


    
    
    
    
    //    [YQUserModel shared].user.tourist == 1 ? @"绑定手机" : @"修改密码",
    //    if ([YQUserModel shared].user.tourist == 1) {
    //        [self.dataArray insertObject:@"绑定手机" atIndex:3];
    //        [self.dataArray insertObject:@"绑定邮箱" atIndex:4];
    //    }
    //    else{
    //        [self.dataArray insertObject:@"修改密码" atIndex:3];
    //
    //    }
    //
    
//    self.tableView.tableFooterView = footerLabel;
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self showAnimation];
//    });
    
//    WeakSelf;
//    UIButton *deleteBtn = [UIButton buttonWithTitle:@"注销账号" titleColor:rgba(133, 138, 157, 1) font:Font(14) backgroundColor:[UIColor clearColor] superView:self.view btnClick:^(UIButton *btn) {
//        [YQAlert alertMessageOneAction:@"是否注销账号" sub:@"注销后, 账号信息清空,如果有购买VIP, VIP时间也将清空" leftName:@"取消" rightName:@"注销" vc:self rightBlock:^{
//            [weakSelf hiddenAnimation];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [QYSettingConfig shared].showLoginVC = NO;
//                [YQUserModel loginOutUser];
//            });
//        }];
//    }];
//    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(-20);
//        make.height.offset(30);
//        make.centerX.offset(-35);
//        make.width.offset(200);
//    }];
//    
//    WeakSelf;
//    [self.view addTapActionWithBlock:^(UIGestureRecognizer * _Nullable sender) {
//        [weakSelf hiddenAnimation];
//    }];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self hiddenAnimation];
//}
//
//
//- (void)showAnimation
//{
//    WeakSelf;
//    [UIView animateWithDuration:0.25 animations:^{
//        weakSelf.tableView.mj_x = 0;
//    }];
//}

//- (void)hiddenAnimation
//{
//    WeakSelf;
//    [UIView animateWithDuration:0.25 animations:^{
//        weakSelf.tableView.mj_x = -ScreenWidth;
//    } completion:^(BOOL finished) {
//        [weakSelf dismissViewControllerAnimated:NO completion:nil];
//    }];
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *title = self.dataArray[indexPath.row];
//    if ([title isEqualToString:@"热门推荐"] && [YQUserModel shared].user.hot_switch == 0) {
//        return 0;
//    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VFMineCell *cell = [tableView dequeueReusableCellWithIdentifier:VFMineCell.className forIndexPath:indexPath];
    NSString *title = self.dataArray[indexPath.row];
    cell.nameLabel.text = title.localized;
    cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_mine_%ld",indexPath.row]];
//    
//    if ([YQUserModel shared].user.tourist == 1 && indexPath.row >= 4) {
//        cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_mine_%ld",indexPath.row-1]];
//    }
//    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([title isEqualToString:@"退出登录"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.subLabel.text = @"";
    if ([title isEqualToString:@"我的账号"]) {
        cell.subLabel.text = [YQUserModel shared].user.account;
    }
//    if ([title isEqualToString:@"热门推荐"]) {
//        cell.subLabel.text = [[QYSettingConfig shared] openString];
//    }
//    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *title = self.dataArray[indexPath.row];
    if ([title isEqualToString:@"热门推荐"]) {
        [YQAlert alertSheetViewController:nil sub:nil actionNames:@[@"打开",@"关闭一天", @"关闭一周"] vc:self block:^(int index) {
            [QYSettingConfig shared].openTipsType = index;
            [self.tableView reloadData];

        }];
    }
    
    if ([title isEqualToString:@"在线客服"]) {
        [QYCommonFuncation shouKefu];
    }
    
    if ([title isEqualToString:@"退出登录"]) {
        WeakSelf;
        [VFTipsView showView:@"提示" content:@"是否退出登录" leftBtn:@"取消" rightBtn:@"退出" block:^(NSInteger code) {
            if (code == 1) {
//                [weakSelf hiddenAnimation];
                [YQUserModel loginOutUser];
                [QYSettingConfig shared].showLoginVC = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.tabBarController.selectedIndex = 0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedTabbarIndex" object:@(0)];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutUser" object:nil];
                });
            }
        }];
    }
    
//    if (indexPath.row == 1) {
//        [YQUtils openUrl:[YQUserModel shared].user.web];
//    }
//    if (indexPath.row == 2) {
//        VFHelpVC *vc = [VFHelpVC new];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    if ([title isEqualToString:@"帮助中心"]) {
        VFHelpVC *vc = [VFHelpVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([title isEqualToString:@"线上反馈"]) {
//        [QYCommonFuncation shouKefu];
        VFMainFeedBcakVC *vc = [VFMainFeedBcakVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    if ([title isEqualToString:@"线上反馈"]) {
//        VFMainFeedBcakVC *vc = [VFMainFeedBcakVC new];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    if ([title isEqualToString:@"绑定手机"]) {
        VFBindMoblieVC *vc = (VFBindMoblieVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFBindMoblieVC"];
        vc.isBind = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([title isEqualToString:@"修改密码"]) {
        VFChangedPasswordVC *vc = (VFChangedPasswordVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFChangedPasswordVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([title isEqualToString:@"版本更新"]) {
        [self upldateApp];
    }
    
    if ([title isEqualToString:@"官方网站"]) {
//        SSNoticeListVC *vc = [SSNoticeListVC new];
//        [self.navigationController pushViewController:vc animated:YES];
        [YQUtils openUrl:[YQUserModel shared].user.web];
    }
    
    
    if ([title isEqualToString:@"我的账号"]) {
        
//        if (![YQUserModel shared].user.isLogin) {
//            
//            [self hiddenAnimation];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [QYSettingConfig shared].showLoginVC = NO;
//                [YQUserModel loginOutUser];
//            });
//        }
//        
//        if ([YQUserModel shared].user.tourist == 1) {
//            [YQAlert alertMessageNoAction:@"请先绑定手机或者邮箱" sub:nil action:@"确定" vc:self];
//            return;
//        }
//        
        VFAccountVC *vc = [VFAccountVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



- (void)upldateApp
{
    
    NSString *url = @"api/en/mine/edition";
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            NSDictionary *dic = obj[@"data"];
            if (dic == nil || dic == [NSNull null]) {
                [VFTipsView showView:@"已经是最新版本" content:nil leftBtn:nil rightBtn:@"我知道了" block:^(NSInteger code) {
                }];
                return;
            }
            
            NSInteger code = [dic[@"version_code"] integerValue];
            
            NSInteger force_update = [dic[@"force_update"] integerValue];
            
            NSInteger appcode = [[App_Ver stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];

            
            if (appcode >= code) {
                [VFTipsView showView:@"已经是最新版本" content:nil leftBtn:nil rightBtn:@"我知道了" block:^(NSInteger code) {
                }];
            }
            else{
                NSString *info = dic[@"description"];
                
                NSString *url = dic[@"url"];
                
                [VFTipsView showView:@"新版本更新" content:info leftBtn:force_update == 0 ? @"取消" : nil rightBtn:@"更新" block:^(NSInteger code) {
                    if (code == 1) {
                        [YQUtils openUrl:url ?: WX_EvaluationAddress];
                    }
                }];

            }
            

        }
    }];
}


@end
