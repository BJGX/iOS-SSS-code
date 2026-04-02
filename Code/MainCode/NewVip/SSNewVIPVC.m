//
//  SSNewVIPVC.m

//
//  Created by  on 2025/7/17.

//

#import "SSNewVIPVC.h"
#import "SSVIPMainCell.h"
#import "VFVipModel.h"
#import "VFPayVC.h"
#import "VFOrderListVC.h"
#import "NPLanguageTool.h"
@interface SSNewVIPVC ()
@property (nonatomic, strong) VFVipModel *model;
@property (nonatomic, strong) UIView *payView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) VFVipModel *payModel;

@end

@implementation SSNewVIPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"商城";
    [self hiddenNavigationBarLeftButton];
    
    CGFloat top = 0;
    if (![DeviceHelper isiPhone]) {
        top = 40;
        self.navigationBar.mj_y = top;
    }
    
    
    UIButton *order = [self.navigationBar setRightButtonWithTitle:@"订单" font:Font(15) color:[UIColor subTextColor]];
    [order addTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
//    self.showRefreshHeader = YES;
    [self getData];
//    self.navigationBar.backgroundColor = [UIColor subBackgroundColor];
    self.tableView.backgroundColor = [UIColor backGroundColor];
    self.tableView.mj_h -= top;
    self.tableView.mj_y += top;
    [self initPayView];
}

- (void)initPayView
{
    self.payView = [UIView viewWithFrame:CGRectZero backgroundColor:[UIColor whiteColor] superView:self.view];
    self.payView.hidden = YES;
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-2);
        make.height.offset(45);
    }];
    
    UILabel *left = [UILabel YQLabelWithString:@"实付" textColor:[UIColor mainTextColor] font:[YQUtils systemMediumFontOfSize:16] superView:self.payView];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.payView);
        make.left.offset(20);
    }];
    WeakSelf;
    UIButton *payBtn = [UIButton buttonWithTitle:@"立即购买" titleColor:[UIColor whiteColor] font:[YQUtils systemMediumFontOfSize:14] backgroundColor:[UIColor appThemeColor] superView:self.payView btnClick:^(UIButton *btn) {
        [weakSelf enterVC:weakSelf.payModel];
    }];
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(145);
    }];
    
    UILabel *moneyLabel = [UILabel YQLabelWithString:@"" textColor:[UIColor appThemeColor] font:[YQUtils systemMediumFontOfSize:16] superView:self.payView];
    self.priceLabel = moneyLabel;
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.payView);
        make.right.mas_equalTo(payBtn.mas_left).offset(-20);
    }];
    
    
}

- (void)showOrder
{
    VFOrderListVC *vc = [VFOrderListVC new];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)getData
{
    NSString *url = @"api/en/pay/shopIos";
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
    

    
    if (model.activity.count > 0 ) {
        VFVipModel *objModel = [VFVipModel new];
        objModel.name = @"活动套餐";
        objModel.listArray = model.activity;
        objModel.type = 0;
        objModel.ID = @"cell1";
        objModel.wxts = model.wxts;
        [self.dataArray addObject:objModel];
    }

    if (model.vip.count > 0) {
        VFVipModel *objModel = [VFVipModel new];
        objModel.name = @"会员套餐";
        objModel.listArray = model.vip;
        objModel.type = 1;
        objModel.ID = @"cell2";
        objModel.wxts = model.wxts;
        [self.dataArray addObject:objModel];
    }
    
    
    VFVipModel *objModel = [VFVipModel new];
    objModel.name = @"VIP权益";
    objModel.listArray = @[@"1000M专线",@"不限流量",@"全平台通用",@"不限在线设备",@"极速音频图片",@"4K高清视频",@"VIP专线",@"专属客服"];
    objModel.type = 2;
    objModel.ID = @"cell3";
    [self.dataArray addObject:objModel];
    

    [self.tableView reloadData];
    [self setFooterUI:model.wxts];
}







- (void)setFooterUI:(NSString *)tips
{
    
    UIView *view = [UIView viewWithFrame:CGRectMake(0, 0, ScreenWidth, 100) backgroundColor:[UIColor clearColor]];
//    [UIView viewWithFrame:CGRectMake(15, 0, ScreenWidth - 30, 1) backgroundColor:[UIColor subTextColor] superView:view];
    
    UIButton *btn = [UIButton buttonWithTitle:@"温馨提示" titleColor:[UIColor mainTextColor] font:[YQUtils systemMediumFontOfSize:16] backgroundColor:[UIColor clearColor] normalImage:@"icon_v_ic2" selectedImage:@"icon_v_ic2" superView:view];
    btn.frame = CGRectMake(20, 0, 200, 40);
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VFVipModel *model = self.dataArray[indexPath.row];
    NSInteger number = ScreenWidth < 500 ? 3 : 5;
    if (model.type == 0) {
        NSInteger count = model.listArray.count;
        if (count == 0) {
            return 38;
        }
        return 38 + count * 60 + (count - 1) * 15;
    }
    else if (model.type == 1){
        
        NSInteger line = model.listArray.count % number > 0 ? 1 : 0;
        NSInteger count = model.listArray.count / number + line;
        return 38 + count * 130 + (count - 1) * 15;
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VFVipModel *model = self.dataArray[indexPath.row];
    SSVIPMainCell *cell = [tableView dequeueReusableCellWithIdentifier:model.ID];
    if (cell == nil) {
        cell = [[SSVIPMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.ID type:model.type];
    }
    cell.model = model;
    WeakSelf;
    [cell setSelectedModel:^(VFVipModel * _Nonnull model) {
        [weakSelf selectedModel:model];
    }];
    return cell;
}

- (void)selectedModel:(VFVipModel *)model
{
    self.payView.hidden = NO;
    NSString *symbol = [NPLanguageTool shared].currencySymbol;
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@",symbol,model.price];
    self.payModel = model;
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
