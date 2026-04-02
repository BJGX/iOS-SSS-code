//
//   YQCustomAlert.m
   

#import "YQCustomAlert.h"

@interface YQCustomAlert()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) NSArray *actionArray;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) stateBlock block;

@end


@implementation YQCustomAlert


+ (void)showAlert:(NSString *)title
         subTitle:(NSString *)subTitle
             type:(NSInteger)type
             icon:(NSString *)icon
      actionArray:(NSArray *)actionArray
         complete:(stateBlock)complete

{
    YQCustomAlert *alert = [[YQCustomAlert alloc] init];
    alert.titleLabel.text = title;
    alert.subTitleLabel.text = subTitle;
    alert.actionArray = actionArray;
    alert.block = complete;
    alert.type = type;
    if (icon.length > 0) {
        alert.iconView.image = [UIImage imageNamed:icon];
    }
    [alert normalView];
}


- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
    }
    return _iconView;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel YQLabelWithString:@"" textColor:rgba(108, 108, 108, 1) font:Font(17) superView:self.contentView];
        _subTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

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
    
    UIWindow *key = [[UIApplication sharedApplication] keyWindow];
    self.backgroundColor = rgba(0, 0, 0, 0.5);
    self.frame = key.bounds;
    self.alpha = 0;
    [key addSubview:self];
    
    self.contentView = [UIView viewWithFrame:CGRectMake(30, 0, ScreenWidth - 60, 100) backgroundColor:[UIColor whiteColor] superView:self];
    self.contentView.center = self.center;
    self.contentView.cornerRadius = 10;
    
    self.titleLabel = [UILabel YQLabelWithString:@"" textColor:rgba(53, 53, 53, 1) font:[YQUtils systemMediumFontOfSize:17] superView:self.contentView];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(24, 30, ScreenWidth - 108, 20);
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = rgba(0, 0, 0, 0.1);
    lineView.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).bottomSpaceToView(self.contentView, 55).heightIs(0.7);
    
}


- (void)showView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.mj_h = self.height;
        self.contentView.center = self.center;
        self.alpha = 1;
    }];
}

- (void)normalView
{
    self.height = CGRectGetMaxY(self.titleLabel.frame) + 75;
    CGFloat subH = 0;
    if (self.subTitleLabel.text.length > 0) {
        
        NSAttributedString *attr = [self.subTitleLabel setLineSpace:self.subTitleLabel.text space:5];
        subH = [self returnContentHeight:attr];
        self.subTitleLabel.sd_layout.leftSpaceToView(self.contentView, 24).rightSpaceToView(self.contentView, 24).topSpaceToView(self.titleLabel, 16).heightIs(subH);
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.height += subH + 20;
    }
    
    if (_iconView) {
        [_iconView sizeToFit];
        CGFloat iconH = _iconView.mj_w;
        if (self.type == 1) {
            _iconView.sd_layout.centerXEqualToView(self.titleLabel).topSpaceToView(self.subTitleLabel, 18).heightIs(iconH).heightIs(iconH);
        }
        
        else{
            _iconView.sd_layout.centerXEqualToView(self.titleLabel).topSpaceToView(self.titleLabel, 10).heightIs(iconH).heightIs(iconH);
            self.subTitleLabel.sd_resetLayout.leftSpaceToView(self.contentView, 24).rightSpaceToView(self.contentView, 24).bottomSpaceToView(self.contentView, 80).heightIs(subH);
        }
        self.height += iconH + 16;
    }
    
    
    
    
    
    [self showView];
    
    
    
    
}








- (CGFloat)returnContentHeight:(NSAttributedString *)attr
{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGFloat height = [attr boundingRectWithSize:CGSizeMake(self.contentView.mj_w - 48, 1000) options:options context:nil].size.height;
    return height;
}



- (void)setActionArray:(NSArray *)actionArray
{
    _actionArray = actionArray;
    CGFloat width = self.contentView.mj_w / 1.0 / actionArray.count / 1.0;
    [actionArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:obj titleColor:rgba(59, 190, 95, 1) font:[YQUtils systemMediumFontOfSize:17]];
        [self.contentView addSubview:btn];
        btn.sd_layout.leftSpaceToView(self.contentView, idx * width).bottomEqualToView(self.contentView).widthIs(width).heightIs(55);
        if (idx == 0 && actionArray.count > 1) {
            [btn setTitleColor:[UIColor blackColor] forState:0];
        }
        else{
            UIView *lineView = [[UIView alloc] init];
            [self.contentView addSubview:lineView];
            lineView.backgroundColor = rgba(0, 0, 0, 0.1);
            lineView.sd_layout.leftSpaceToView(self.contentView, idx * width - 0.35).bottomEqualToView(self.contentView).widthIs(0.7).heightIs(55);
        }
        
        btn.tag = idx + 100;
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }];
}


- (void)btnClickAction:(UIButton *)sender
{
    if (self.block) {
        self.block(sender.tag - 100);
    }
    [self removeSelf];
}

- (void)removeSelf
{
    __block YQCustomAlert *weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.mj_h = 100;
        self.contentView.center = self.center;
        weakself.alpha = 0;
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
        weakself = nil;
    }];
}


@end
