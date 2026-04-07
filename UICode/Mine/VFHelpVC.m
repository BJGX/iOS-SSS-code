

#import "VFHelpVC.h"
#import "VFHelpCell.h"

@interface VFHelpVC ()

@end

@implementation VFHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"帮助中心";
    [self registerCellWithNib:VFHelpCell.className];
    self.showRefreshHeader = YES;
    [self beginHeaderRefresh];
//    self.pageCount = 10;
    
    self.tableView.estimatedRowHeight = 120;
    
    
    UIView *headerView = [UIView viewWithFrame:CGRectMake(0, 0, ScreenWidth, 40) backgroundColor:[UIColor subBackgroundColor]];
    UILabel *tipsLabel = [UILabel YQLabelWithString:@"需要人工帮助？点击联系在线客服" textColor:[UIColor mainTextColor] font:Font(12) superView:headerView];
    tipsLabel.frame = CGRectMake(15, 0, ScreenWidth - 120, 40);
    tipsLabel.numberOfLines = 0;
    
    UIButton *kfBtn = [UIButton buttonWithTitle:@"联系客服" titleColor:[UIColor whiteColor] font:Font(12) backgroundColor:[UIColor appThemeColor] superView:headerView btnClick:^(UIButton *btn) {
        [QYCommonFuncation shouKefu];
    }];
    [kfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(26);
        make.centerY.mas_equalTo(tipsLabel);
    }];
    kfBtn.yy_contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    kfBtn.cornerRadius = 13;
    
    self.tableView.tableHeaderView = headerView;
    
    
}

- (void)tableViewDidTriggerHeaderRefresh
{
    self.page = 1;
    [self getData];
}

- (void)tableViewDidTriggerFooterRefresh
{
    self.page += 1;
    [self getData];
}





- (void)getData
{
    NSString *url = @"api/en/mine/helpList";
    NSDictionary *dic = @{@"page": @(self.page),
                          @"size":@"15"
    };
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            NSArray *array = [VFHomeModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
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
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VFHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:VFHelpCell.className forIndexPath:indexPath];
    VFHomeModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.question;
    cell.sublabel.text = model.content;
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
