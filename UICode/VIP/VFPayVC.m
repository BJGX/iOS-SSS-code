//
//  VFPayVC.m
//  VFProject
//


//

#import "VFPayVC.h"
#import "IAPManager.h"
#import "VFOrderListVC.h"
#import "NPLanguageTool.h"

@interface VFPayVC ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewheight;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation VFPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"支付";
    self.tipsLabel.text = self.wxts.localized;
    
    
    NSString *symbol = [NPLanguageTool shared].currencySymbol;
    
    NSString *priceSTring = [[NPLanguageTool shared] isEnglishLanguage] ? self.model.price_us : self.model.price;
    
    NSString *price = [NSString stringWithFormat:@"%@%@",symbol,priceSTring];
    [self.priceLabel setFontSizeWithString:price font:Font(15) range:NSMakeRange(0, symbol.length)];
    [self createAppPayUI];
//    if (![QYSettingConfig shared].isReview) {
//        [self getPayType];
//    }
//    [self getPayType];
    UIButton *order = [self.navigationBar setRightButtonWithTitle:@"订单" font:Font(15) color:[UIColor subTextColor]];
    [order addTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showOrder
{
    VFOrderListVC *vc = [VFOrderListVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)createAppPayUI
{
    UIButton *btn = [UIButton buttonWithTitle:@" 支付" titleColor:[UIColor mainTextColor] font:Font(20) backgroundColor:[UIColor subBackgroundColor] superView:self.payView btnClick:^(UIButton *btn) {
        [self applePay];
    }];
    [btn setImage:[UIImage systemImageNamed:@"applelogo"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIButtonConfiguration * config = [UIButtonConfiguration plainButtonConfiguration];
    config.contentInsets = NSDirectionalEdgeInsetsMake(0, 10, 0, 0);
    btn.configuration = config;
    btn.frame = CGRectMake(0, 0, ScreenWidth - 50, 50);
    btn.cornerRadius = 8;
    self.viewheight.constant = 65;
    btn.tintColor = [UIColor blackColor];
    [self.view layoutIfNeeded];
    
}


- (void)applePay
{
    [[IAPManager shared] requestProductWithId:self.model.apple_id];
    
}



- (void)getPayType
{
    NSString *url = @"api/en/pay/type";
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:@"正在加载" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            NSArray *array = [VFVipModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            [self setBtnArray:array];
        }
    }];
}


- (void)setBtnArray:(NSArray *)array
{
    WeakSelf;
    [array enumerateObjectsUsingBlock:^(VFVipModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = [NSString stringWithFormat:@"  %@", obj.name];
        NSString *image = [NSString stringWithFormat:@"icon_pay%ld", obj.type];
        UIButton *btn = [UIButton buttonWithTitle:name titleColor:rgb(30, 30, 30) font:Font(20) backgroundColor:[UIColor subBackgroundColor] normalImage:image selectedImage:image superView:self.payView layoutBlock:nil btnClick:^(UIButton *btn) {
            [weakSelf payAction:obj];
        }];
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"icon_v_back_btn"] forState:0];
        
        UIButtonConfiguration * config = [UIButtonConfiguration plainButtonConfiguration];
        config.contentInsets = NSDirectionalEdgeInsetsMake(0, 10, 0, 0);
        btn.frame = CGRectMake(0, idx * (65) + 65, ScreenWidth - 50, 50);
        btn.configuration = config;
        btn.cornerRadius = 8;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }];
    
    self.viewheight.constant = (array.count + 1) * 65;
    [self.view layoutIfNeeded];
    
    
}
- (void)payAction:(VFVipModel *)obj
{
    NSString *url = @"api/en/pay/goPay";
    NSDictionary *dic = @{@"amount":self.model.price,
                          @"type":@(obj.type),
                          @"shopid":self.model.ID
    };
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在获取订单" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            VFVipModel *model = [VFVipModel mj_objectWithKeyValues:obj[@"data"]];
            [YQUtils openUrl:model.url];
        }
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
