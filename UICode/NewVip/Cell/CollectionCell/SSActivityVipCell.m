//
//  SSActivityVipCell.m

//


//

#import "SSActivityVipCell.h"
#import "NPLanguageTool.h"

@interface SSActivityVipCell()
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *orginPriceLabel;
@property (nonatomic, strong) UIView *badgeView;
@property (nonatomic, strong) UILabel *badgeLabel;
@end

@implementation SSActivityVipCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _cardView = [[UIView alloc] init];
    _cardView.backgroundColor = [UIColor whiteColor];
    _cardView.layer.cornerRadius = 8;
    _cardView.layer.borderWidth = 1;
    _cardView.layer.masksToBounds = YES;
    [self.contentView addSubview:_cardView];
    
    _badgeView = [[UIView alloc] init];
    _badgeView.backgroundColor = [UIColor appThemeColor];
    _badgeView.layer.cornerRadius = 8;
    if (@available(iOS 11.0, *)) {
        _badgeView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMinYCorner;
    }
    [_cardView addSubview:_badgeView];
    
    _badgeLabel = [[UILabel alloc] init];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.font = Font(10);
    [_badgeView addSubview:_badgeLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor mainTextColor];
    _moneyLabel.font = [YQUtils systemSemiboldFontOfSize:15];
    _moneyLabel.adjustsFontSizeToFitWidth = YES;
    _moneyLabel.minimumScaleFactor = 0.75;
    [_cardView addSubview:_moneyLabel];
    
    _orginPriceLabel = [[UILabel alloc] init];
    _orginPriceLabel.textColor = [UIColor subTextColor];
    _orginPriceLabel.font = Font(12);
    [_cardView addSubview:_orginPriceLabel];
    
    [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.cardView);
        make.height.mas_equalTo(22);
    }];
    
    [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.badgeView).offset(12);
        make.right.equalTo(self.badgeView).offset(-12);
        make.center.mas_equalTo(self.badgeView);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(15);
        make.centerY.equalTo(self.cardView);
        make.right.lessThanOrEqualTo(self.badgeView.mas_left).offset(-14);
    }];
    
    [_orginPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.mas_right).offset(20);
        make.centerY.equalTo(self.moneyLabel);
        make.right.lessThanOrEqualTo(self.badgeView.mas_left).offset(-14);
    }];
    
    [self updateCardStyle];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.highlightedStyle = NO;
}

- (void)setHighlightedStyle:(BOOL)highlightedStyle
{
    _highlightedStyle = highlightedStyle;
    [self updateCardStyle];
}

- (void)updateCardStyle
{
    UIColor *defaultBorderColor = rgba(227, 227, 227, 1);
    self.cardView.layer.borderColor = (self.highlightedStyle ? [UIColor appThemeColor] : defaultBorderColor).CGColor;
}

- (void)setModel:(VFVipModel *)model
{
    _model = model;
    NSString *symbol = [NPLanguageTool shared].currencySymbol;
    
    
    NSString *price = [[NPLanguageTool shared] isEnglishLanguage] ? model.price_us : model.price;
    NSString *oldPrice = [[NPLanguageTool shared] isEnglishLanguage] ? model.old_price_us : model.old_price;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@%@/%@%@", symbol, price, model.time, @"天".localized];
    
    
    
    BOOL shouldHideOriginPrice = [oldPrice isEqualToString:@"0"] || [oldPrice isEqualToString:@"0.00"] || oldPrice.length == 0;
    self.orginPriceLabel.hidden = shouldHideOriginPrice;
    if (shouldHideOriginPrice) {
        self.orginPriceLabel.attributedText = nil;
    }
    else {
        NSString *originText = [NSString stringWithFormat:@"%@:%@%@", @"原价".localized, symbol, oldPrice];
        self.orginPriceLabel.attributedText = [self attributedOriginText:originText];
    }
    
    NSString *badgeText = [self badgeTextForModel:model];
    self.badgeLabel.text = badgeText;
    self.badgeView.hidden = badgeText.length == 0;
}

- (NSAttributedString *)attributedOriginText:(NSString *)text
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, text.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor subTextColor] range:NSMakeRange(0, text.length)];
    [attr addAttribute:NSFontAttributeName value:[YQUtils systemMediumFontOfSize:14] range:NSMakeRange(0, text.length)];
    return attr;
}

- (NSString *)badgeTextForModel:(VFVipModel *)model
{
    NSInteger totalMinutes = MAX(model.remaining_time / 1000, 0);
    NSInteger totalHours = totalMinutes / 60;
    NSInteger totalDays = totalHours / 24;
    
    if (totalDays > 0) {
        return [NSString stringWithFormat:@"%@: %ld%@", @"倒计时".localized, (long)totalDays, @"天".localized];
    }
    if (totalHours > 0) {
        return [NSString stringWithFormat:@"%@: %ld%@", @"倒计时".localized, (long)totalHours, @"小时".localized];
    }
    if (totalMinutes > 0) {
        return [NSString stringWithFormat:@"%@: %ld%@", @"倒计时".localized, (long)totalMinutes, @"分钟".localized];
    }
    return model.mark ?: @"";
}

@end
