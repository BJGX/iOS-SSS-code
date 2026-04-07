//
//  SSMainLineListVC.m

//
//  Created by  on 2025/7/4.

//

#import "SSMainLineListVC.h"
#import "SSMainLineListCell.h"
#import "VFAES.h"
#import "VFMainFeedBcakVC.h"

@interface SSMainLineListVC ()
@property (nonatomic, strong) NSMutableArray *collectArray;
@property (nonatomic, strong) YQBaseModel *collectionModel;
@end

@implementation SSMainLineListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"选择节点";
    [self registerCellWithNib:SSMainLineListCell.className];
    self.showRefreshHeader = YES;
    [self beginHeaderRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadArray) name:@"CollectServiceList" object:nil];
    self.collectionModel = [YQBaseModel new];
    self.collectionModel.name = @"收藏";
    
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

- (void)tableViewDidTriggerHeaderRefresh{
    
    NSString *url = @"api/en/v3/user/serviceLstGroup";
    id chache = [self getCacheWithURLString:url];
    if (chache) {
        LH_AESModel *model = [VFAES aesDecrypt2:chache[@"data"]];
        self.dataArray = [YQBaseModel mj_objectArrayWithKeyValuesArray:model.obj[@"list"]];
        [self reloadArray];
//        [self finishTableView:0];
//        return;
    }
    
    
    
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            LH_AESModel *model = [VFAES aesDecrypt2:obj[@"data"]];
            [self asyncCacheNetworkWithURLString:url response:obj];
            self.dataArray = [YQBaseModel mj_objectArrayWithKeyValuesArray:model.obj[@"list"]];
            [self reloadArray];
        }
        [self finishTableView:0];
    }];
}


- (void)reloadArray
{
    self.collectArray = [NSMutableArray array];
    NSString *CollectString = [YQCache getDataFromPlist:@"CollectServiceList"] ?: @"";
    self.collectionModel.service = @[];
    if (CollectString.length == 0 ) {
        return;
    }
    
    for (YQBaseModel *model in self.dataArray) {
        for (YQBaseModel *obj in model.service) {
            NSString *idS = [NSString stringWithFormat:@"ID:%@",obj.ID];
            if ([CollectString containsString:idS]) {
                obj.isCollect = YES;
                [self.collectArray addObject:obj];
            }
        }
    }
    self.collectionModel.service = self.collectArray;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        YQBaseModel *model = self.collectionModel;
        if (model.unFold) {
            return model.cellHeight;
        }
        return 66;
    }
    
    
    YQBaseModel *model = self.dataArray[indexPath.row];
    if (model.unFold) {
        return model.cellHeight;
    }
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSMainLineListCell *cell = [tableView dequeueReusableCellWithIdentifier:SSMainLineListCell.className forIndexPath:indexPath];
    
    YQBaseModel *model;
    if (indexPath.section == 0) {
        model = self.collectionModel;
    }
    else {
        model = self.dataArray[indexPath.row];
    }
    
    cell.model = model;
    WeakSelf;
    [cell setUnfoldBlock:^{
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView viewWithFrame:CGRectMake(0, 0, ScreenWidth, 34) backgroundColor:[UIColor subBackgroundColor]];
    UIButton *btn = [UIButton buttonWithTitle:section == 0 ? @"收藏" : @"所有国家和地区" titleColor:[UIColor mainTextColor] font:[YQUtils systemMediumFontOfSize:16] backgroundColor:[UIColor clearColor] superView:view btnClick:nil];
    btn.frame = CGRectMake(10, 0, 200, 34);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.userInteractionEnabled = NO;
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
