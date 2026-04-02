//
//  VFMainVipVC.m
//  VFProject
//


//

#import "VFMainVipVC.h"
#import "VFHeaderBannerCell.h"
#import "VFBuyVipCell.h"
#import "VFVipModel.h"
#import "VFPayVC.h"
#import "VFOrderListVC.h"

@interface VFMainVipVC ()
@property (nonatomic, strong) VFVipModel *model;
@end

@implementation VFMainVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"VIP";
    [self getData];
    self.tableView.backgroundColor = [UIColor backGroundColor];
    [self hiddenNavigationBarLeftButton];
    
    UIButton *order = [self.navigationBar setRightButtonWithTitle:@"订单" font:Font(15) color:[UIColor subTextColor]];
    [order addTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
//    self.showRefreshHeader = YES;
}

- (void)showOrder
{
    VFOrderListVC *vc = [VFOrderListVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)getData
{
    NSString *url = @"api/en/pay/shop";
    NSDictionary *dic = @{@"vip_level":@"1"};
    
    NSDictionary *cache = [self getCacheWithURLString:url];
    
    if (cache) {
        self.model = [VFVipModel mj_objectWithKeyValues:cache];
        [self reloadUI];
    }
    
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在请求" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            
            [self asyncCacheNetworkWithURLString:url response:obj[@"data"]];
            
            self.model = [VFVipModel mj_objectWithKeyValues:obj[@"data"]];
            [self reloadUI];
            
            
        }
    }];
}

- (void)reloadUI
{
    VFVipModel *model = self.model;
    [self.dataArray removeAllObjects];
    if (model.activity.count > 0 && ![QYSettingConfig shared].isReview) {
        [self.dataArray addObject:model.activity];
    }
    else{
        [self.dataArray addObject:@[]];
    }
    
    if (model.vip.count > 0) {
        [self.dataArray addObject:model.vip];
    }
    else{
        [self.dataArray addObject:@[]];
    }
//            [self finishTableView:0];
    [self.tableView reloadData];
    [self setFooterUI:model.wxts];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        VFHeaderBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFHeaderBannerCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"VFHeaderBannerCell" owner:nil options:nil].firstObject;
        }
        NSArray *array = self.dataArray[indexPath.section];
        cell.model = array[indexPath.row];

        return cell;
    }
    
    VFBuyVipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VFBuyVipCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VFBuyVipCell" owner:nil options:nil].firstObject;
    }
    NSArray *array = self.dataArray[indexPath.section];
    cell.model = array[indexPath.row];
    WeakSelf;
    [cell setBuyActionBlock:^(VFVipModel * _Nonnull model) {
        [weakSelf enterVC:model];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.000001;
    }
    return 40;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    }
    
    UIView *view = [UIView viewWithFrame:CGRectMake(0, 0, ScreenWidth, 40) backgroundColor:[UIColor backGroundColor]];
    
    UIButton *btn = [UIButton buttonWithTitle:@" VIP套餐" titleColor:[UIColor mainTextColor] font:[YQUtils systemMediumFontOfSize:16] backgroundColor:[UIColor clearColor] normalImage:@"icon_v_ic1" selectedImage:@"icon_v_ic1" superView:view];
    btn.frame = CGRectMake(15, 0, 200, 40);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.userInteractionEnabled = NO;
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSArray *array = self.dataArray[indexPath.section];
        [self enterVC:array[indexPath.row]];
    }
}


- (void)setFooterUI:(NSString *)tips
{
    UIView *view = [UIView viewWithFrame:CGRectMake(0, 0, ScreenWidth, 100) backgroundColor:[UIColor clearColor]];
    [UIView viewWithFrame:CGRectMake(15, 0, ScreenWidth - 30, 1) backgroundColor:[UIColor subTextColor] superView:view];
    
    UIButton *btn = [UIButton buttonWithTitle:@" 温馨提示" titleColor:[UIColor mainTextColor] font:[YQUtils systemMediumFontOfSize:16] backgroundColor:[UIColor clearColor] normalImage:@"icon_v_ic2" selectedImage:@"icon_v_ic2" superView:view];
    btn.frame = CGRectMake(15, 0, 200, 40);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.userInteractionEnabled = NO;
    
    UILabel *label = [UILabel YQLabelWithString:tips textColor:[UIColor subTextColor] font:Font(14) superView:view];
    label.numberOfLines = 0;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).offset(15);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    [view layoutIfNeeded];
    
    view.mj_h = CGRectGetMaxY(label.frame)+20;
    self.tableView.tableFooterView = view;
    
}



- (void)enterVC:(VFVipModel *)model
{
    VFPayVC *vc = [[VFPayVC alloc] initWithNibName:@"VFPayVC" bundle:nil];
    vc.wxts = self.model.wxts;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
