//
//  VFSubFeedBackVC.m
//  VFProject
//


//

#import "VFSubFeedBackVC.h"
#import "VFFeedbackModel.h"
//#import "VFFeedBackCell.h"
#import "SSFeedbackListCell.h"
#import "SSDetailFeedbackVC.h"

@interface VFSubFeedBackVC ()

@end

@implementation VFSubFeedBackVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavigationBar:YES];
    self.view.backgroundColor = [UIColor tableBackgroundColor];
    if ([DeviceHelper isiPadOnMac]) {
        self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - PUB_NAVBAR_HEIGHT - 200);
        self.tableView.autoresizingMask = UIViewAutoresizingNone;
    }
    else {
        self.tableView.frame = self.view.bounds;
    }
    
    
    self.showEmptyView = YES;
    self.showRefreshHeader = YES;
    [self beginHeaderRefresh];
    [self registerCellWithNib:SSFeedbackListCell.className];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feddbackRefresh) name:@"FeddbackRefresh" object:nil];
    // Do any additional setup after loading the view.
}

- (void)feddbackRefresh
{
    [self beginHeaderRefresh];
}


- (void)tableViewDidTriggerHeaderRefresh
{
    NSString *url = @"api/en/mine/feedbackList";
    NSDictionary *dic = @{@"reply":@(self.type)};
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            NSArray *array = [VFFeedbackModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            
        }
        [self finishTableView:self.dataArray.count];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self finishTableView:self.dataArray.count];
        });
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VFFeedbackModel *model = self.dataArray[indexPath.row];
    SSFeedbackListCell *cell = [tableView dequeueReusableCellWithIdentifier:SSFeedbackListCell.className forIndexPath:indexPath];
    cell.model = model;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    VFFeedbackModel *model = self.dataArray[indexPath.row];
    SSDetailFeedbackVC *vc = [SSDetailFeedbackVC new];
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
