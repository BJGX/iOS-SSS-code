//
//  SSNormalVipCell.m

//


//

#import "SSNormalVipCell.h"
#import "NPLanguageTool.h"

@interface SSNormalVipCell()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orginPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bg1View;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@end

@implementation SSNormalVipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bg1View.image = [YQUtils imageOfStretchByName:@"icon_Vip_tg_bg"];
    // Initialization code
}

- (void)setModel:(VFVipModel *)model
{
    _model = model;
    
    
    
    NSString *price = [[NPLanguageTool shared] isEnglishLanguage] ? model.price_us : model.price;
//    NSString *oldPrice = [[NPLanguageTool shared] isEnglishLanguage] ? model.old_price_us : model.old_price;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@%@",model.time,@"天套餐".localized];
    NSString *symbol = [NPLanguageTool shared].currencySymbol;
    NSString *money = [NSString stringWithFormat:@"%@%@",symbol,price];
    [self.orginPriceLabel setFontSizeWithString:money font:[YQUtils systemMediumFontOfSize:12] range:NSMakeRange(0, symbol.length)];
    self.tipsLabel.text = model.mark;
    self.tipsLabel.hidden = model.mark.length > 0 ? NO : YES;
    self.bg1View.hidden = self.tipsLabel.hidden;
    NSInteger time = [model.time integerValue];
    self.countLabel.text = [NSString stringWithFormat:@"%@%ld%@",@"到账".localized,time + model.add_time,@"天".localized];
    
    self.selectedView.backgroundColor = model.isSelectedModel ? [[UIColor appThemeColor] colorWithAlphaComponent:0.1] : [UIColor backGroundColor];
    self.selectedView.borderColor = model.isSelectedModel ? [UIColor appThemeColor] : [UIColor subTextColor];
    
    
}


@end
