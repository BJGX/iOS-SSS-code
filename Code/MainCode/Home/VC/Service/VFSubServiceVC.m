//
//  VFSubServiceVC.m
//  VFProject
//


//

#import "VFSubServiceVC.h"
#import "VFChoosePointCell.h"
#import "VFAES.h"

@interface VFSubServiceVC ()

@end

@implementation VFSubServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavigationBar:YES];
    self.tableView.frame = self.view.bounds;
    [self registerCellWithNib:VFChoosePointCell.className];
    self.showRefreshHeader = YES;
    self.tableView.backgroundColor = [UIColor backGroundColor];
    [self beginHeaderRefresh];
    // Do any additional setup after loading the view.
}

- (void)tableViewDidTriggerHeaderRefresh
{
    [self getData];
}

- (void)getData
{
    NSString *url = @"api/en/v3/mine/service";
//    NSDictionary *dic;
//    if (self.type == 0) {
//        dic = @{@"type":@"0"};
//    }
//    if (self.type == 1) {
//        dic = @{@"vip":@"1"};
//    }
//    if (self.type == 2) {
//        dic = @{@"vip":@"0"};
//    }
//    if (self.type == 3) {
//        dic = @{@"type":@"1"};
//    }
    
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            LH_AESModel *model = [VFAES aesDecrypt2:obj[@"data"]];
            self.dataArray = [YQBaseModel mj_objectArrayWithKeyValuesArray:model.obj[@"list"]];
            [self finishTableView:0];
        }
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VFChoosePointCell *cell = [tableView dequeueReusableCellWithIdentifier:VFChoosePointCell.className forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQBaseModel *model = self.dataArray[indexPath.row];
    [QYCommonFuncation getServiceData:model.ID mainThird:YES];
    
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
