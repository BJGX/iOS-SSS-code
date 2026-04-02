//
//  VFMainSharedVC.m
//  VFProject
//


//

#import "VFMainSharedVC.h"
#import "VFQrCodeVC.h"

@interface VFMainSharedVC ()
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumLbael;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIStackView *s1;
@property (weak, nonatomic) IBOutlet UIStackView *s2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareSpace;

@property (nonatomic, strong) VFHomeModel *model;
@end

@implementation VFMainSharedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"分享";
    [self getData];
    [self hiddenNavigationBarLeftButton];
    self.view.backgroundColor = [UIColor subBackgroundColor];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    
    CGFloat top = 0;
    if (![DeviceHelper isiPhone]) {
        top = 40;
        self.navigationBar.mj_y = top;
        self.topHeight.constant = PUB_NAVBAR_HEIGHT + top + 20;
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)copyAction:(UIButton *)sender {
    [self shareLog:0];
    [YQUtils copyStringToPasteboard:self.model.share];
    [YQUtils showCenterMessage:@"已复制到剪切板"];
}
- (IBAction)sharedAction:(UIButton *)sender {
//    VFQrCodeVC *vc = [[VFQrCodeVC alloc] initWithNibName:@"VFQrCodeVC" bundle:nil];
//    vc.model = self.model;
//    [self.navigationController pushViewController:vc animated:YES];
//
    if (self.model.share.length == 0) {
        return;
    }
    
    
    
    
    WeakSelf;
    if ([DeviceHelper isiPadOnMac] ) {
        [YQUtils copyStringToPasteboard:self.model.share];
        [YQUtils showCenterMessage:@"已复制到剪切板"];
        return;
    }
    
    
    UIImage *newImage = [UIImage imageNamed:@"icon_logo"];
    NSArray *newArray = @[@"SSS VPN", newImage,[NSURL URLWithString:self.model.share]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:newArray applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList];
    
    
    if ([DeviceHelper isiPad]) {
        activityVC.popoverPresentationController.sourceView = self.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds),
                                                                         CGRectGetMidY(self.view.bounds),
                                                                         0, 0);
        activityVC.popoverPresentationController.permittedArrowDirections = 0;
    }

    [self presentViewController: activityVC animated:YES completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        [weakSelf shareLog:1];
    };
    
}

- (void)getData
{
    NSString *url = @"api/en/mine/share";
    WeakSelf;
    [YQNetwork requestMode:POST  tailUrl:url params:nil showLoadString:@"正在获取数据" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            VFHomeModel *model = [VFHomeModel mj_objectWithKeyValues:obj[@"data"]];
            weakSelf.s1.hidden = model.invite_user_activity == 1 ? NO : YES;
            weakSelf.s2.hidden = model.invite_user_activity == 1 ? NO : YES;
            weakSelf.contentlabel.text = model.content.localized;
            weakSelf.userNumLbael.text = [NSString stringWithFormat:@"%@%@", model.invite,@"人".localized];
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@%@", model.share_time,@"分钟".localized];
            weakSelf.model = model;
            
            if (model.invite_user_activity == 1) {
                CGFloat y = CGRectGetHeight(weakSelf.s2.frame) + CGRectGetHeight(weakSelf.s1.frame) + 40;
                weakSelf.shareSpace.constant = y;
                [UIView animateWithDuration:0.2 animations:^{
                    [weakSelf.view layoutIfNeeded];
                }];
            }
            
            
            
        }
    }];
}


- (void)shareLog:(NSInteger)type
{
    NSString *url = @"api/en/mine/numberLog";
    NSDictionary *dic = @{@"type": @(type)};
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:nil andBlock:^(id obj, NSInteger code) {
            
    }];
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
