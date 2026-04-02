//
//  SSNoticeListVC.m

//
//  Created by  on 2025/7/21.

//

#import "SSNoticeListVC.h"
#import "SSNoticeListCell.h"

@interface SSNoticeListVC ()

@end

@implementation SSNoticeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"官方公告";
    
    [self registerCellWithNib:SSNoticeListCell.className];
    self.showRefreshHeader = YES;
    [self beginHeaderRefresh];
    self.showEmptyView = YES;
    self.navigationBar.backgroundColor = [UIColor subBackgroundColor];
//    self.pageCount = 10;
    
    self.tableView.estimatedRowHeight = 120;
    // Do any additional setup after loading the view.
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
    NSString *url = @"api/en/mine/guide";
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
    SSNoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:SSNoticeListCell.className forIndexPath:indexPath];
    VFHomeModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.content;
    cell.timeLabel.text = model.create_at;
//    cell.titleLabel.text = model.question;
//    cell.sublabel.text = model.content;
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
