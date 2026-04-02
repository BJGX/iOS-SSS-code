//
//  VFOrderListVC.m
//  VFProject
//


//

#import "VFOrderListVC.h"
#import "VFOrderListCell.h"
#import "VFVipModel.h"
@interface VFOrderListVC ()

@end

@implementation VFOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"订单";
    self.showRefreshHeader = YES;
    [self beginHeaderRefresh];
    [self registerCellWithNib:VFOrderListCell.className];
    self.navigationBar.backgroundColor = [UIColor subBackgroundColor];
}

- (void)tableViewDidTriggerHeaderRefresh
{
    self.page = 1;
    [self getData];
}

- (void)getData
{
    NSString *url = @"api/en/mine/rechargeList";
    NSDictionary *dic = @{@"page": @(self.page),
                          @"size":@"15"
    };
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            NSArray *array = [VFVipModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            [self finishTableView:array.count];
            self.showRefreshFooter = YES;
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VFOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:VFOrderListCell.className forIndexPath:indexPath];
    VFVipModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.timelabel.text = model.created_at;
    cell.orderLabel.text = model.orderno;
    cell.stateLabel.text = model.status == 1 ? @"已支付".localized : @"待支付".localized;
//    cell.moneyLabel.text = [NSString stringWithFormat:@"%@: %@",@"支付金额".localized,model.amount];
    
    NSString *symbol = [NPLanguageTool shared].currencySymbol;
    [cell.moneyLabel setFontSizeWithString:[NSString stringWithFormat:@"%@%@",symbol,model.amount] font:Font(15) range:NSMakeRange(0, 1)];
    return cell;
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
