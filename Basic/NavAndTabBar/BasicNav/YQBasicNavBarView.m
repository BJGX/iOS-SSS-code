//
//  YQBasicNavBarView.m
//  WXDating
//
//  Created by Andrew on 2017/8/13.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "YQBasicNavBarView.h"

@interface YQBasicNavBarView ()

// 默认返回按钮
@property (nonatomic, strong) UIButton *defaultLeftButton;

// 导航栏边线
@property (nonatomic, strong) UIImageView *navBottomLine;

@property (nonatomic, strong) UIImageView *normalBackImageview;

@end

@implementation YQBasicNavBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    
    [self addSubview:self.normalBackImageview];
    
    [self addSubview:self.navTitleLabel];
    
    [self addSubview:self.defaultLeftButton];

    [self addSubview:self.navBottomLine];
    self.backgroundColor = [UIColor backGroundColor];
    
}

#pragma mark - public
/**
 隐藏返回按钮
 */
- (void)hiddenLeftBarButton
{
    self.defaultLeftButton.hidden = YES;
//    self.navTitleLabel.mj_x = 2 * kHalfMargin;
//    self.navTitleLabel.mj_x = 15;
    
    
}

- (void)showLeftBarButton {
    self.defaultLeftButton.hidden = NO;
}

/**
 白色返回按钮
 */
- (void)setLightLeftButton
{
    [self.defaultLeftButton setTintColor:kWhiteColor];
}

/**
 设置返回按钮颜色
 */
- (void)setLeftButtonTintColor:(UIColor *)tintColor
{
    [self.defaultLeftButton setTintColor:tintColor];
}

/**
 设置导航栏左侧按钮
 */
- (void)setLeftBarButton:(UIButton *)leftButton
{
    if (self.defaultLeftButton) {
        [self.defaultLeftButton removeFromSuperview];
    }
    
    [self addSubview:leftButton];
}

/**
 设置导航栏右侧按钮
 */
- (void)setRightBarButton:(UIButton *)rightButton
{
    [rightButton sizeToFit];
    rightButton.center = CGPointMake(ScreenWidth - rightButton.frame.size.width * 0.5 - 10, self.navTitleLabel.center.y);
    [self addSubview:rightButton];
}

/**
 分割线(细)
 */
- (void)setSmallSeparator
{
    
    self.navBottomLine.frame = CGRectMake(0, PUB_NAVBAR_HEIGHT, ScreenWidth, 1);
    self.navBottomLine.hidden = NO;
}

/**
 分割线(粗)
 */
- (void)setLargeSeparator
{
    self.navBottomLine.frame = CGRectMake(0, PUB_NAVBAR_HEIGHT, ScreenWidth, 5);
    self.navBottomLine.hidden = NO;
}

/**
 分割线(无)
 */
- (void)hiddenSeparator
{
    self.navBottomLine.frame = CGRectMake(0, PUB_NAVBAR_HEIGHT, ScreenWidth, 0);
    self.navBottomLine.hidden = YES;
}

/**
 设置导航栏标题
 */
- (void)setNavigationBarTitle:(NSString *)title
{
    [self.navTitleLabel setText:title];
//    self.navTitleLabel.frame = CGRectMake(2 * kMargin, PUB_NAVBAR_OFFSET + 20, ScreenWidth - 4 * kMargin, 44);
}


/**
 设置导航栏标题颜色
 */
- (void)setNavigationBarTintColor:(UIColor *)tintColor
{
    [self.navTitleLabel setTextColor:tintColor];
}


/**
 设置导航栏标题字号
 */
- (void)setNavigationBarTintFont:(UIFont *)font
{
    [self.navTitleLabel setFont:font];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
//    self.navTitleLabel.backgroundColor = backgroundColor;
}


- (void)hiddenBackgroundView:(BOOL)hidden
{
    self.normalBackImageview.hidden = hidden;
}


#pragma mark - lazy

- (UILabel *)navTitleLabel
{
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, PUB_NAVBAR_OFFSET + 32, ScreenWidth - 150, 20)];
        _navTitleLabel.backgroundColor = [UIColor clearColor];
        _navTitleLabel.textColor = [UIColor mainTextColor];
        _navTitleLabel.numberOfLines = 1;
        _navTitleLabel.font = [YQUtils systemSemiboldFontOfSize:20];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.numberOfLines = 0;
//        _navTitleLabel.text = @" M.Link";
        [_navTitleLabel setMinimumScaleFactor:0.1];
        _navTitleLabel.adjustsFontSizeToFitWidth = YES;
        WeakSelf;
        [_navTitleLabel addTapActionWithBlock:^(UIGestureRecognizer * _Nullable sender) {
            [weakSelf popViewController];
        }];
//        _navTitleLabel.lineBreakMode = kCTLineBreakByClipping;
    }
    return _navTitleLabel;
}

- (UIButton *)defaultLeftButton
{
    if (!_defaultLeftButton) {
        _defaultLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _defaultLeftButton.backgroundColor = [UIColor clearColor];
        _defaultLeftButton.frame = CGRectMake(kHalfMargin, PUB_NAVBAR_OFFSET + 20, 44, 44);
        _defaultLeftButton.adjustsImageWhenHighlighted = NO;
        [_defaultLeftButton.titleLabel setFont:kMainFont];
        [_defaultLeftButton setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
        [_defaultLeftButton setImageEdgeInsets:UIEdgeInsetsMake(12, 6, 12, 18)];
        [_defaultLeftButton setImage:[[UIImage imageNamed:@"icon_back_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_defaultLeftButton setTintColor:[UIColor mainTextColor]];
        [_defaultLeftButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultLeftButton;
}

- (UIImageView *)navBottomLine
{
    if (!_navBottomLine) {
        _navBottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, PUB_NAVBAR_HEIGHT, ScreenWidth, 5)];
        _navBottomLine.userInteractionEnabled = YES;
//        _navBottomLine.image = [UIImage imageNamed:@"navbar_bottom_line"];
        _navBottomLine.backgroundColor = rgb(235, 235, 235);
    }
    return _navBottomLine;
}


- (UIImageView *)normalBackImageview
{
    if (!_normalBackImageview) {
        _normalBackImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PUB_NAVBAR_HEIGHT)];
        _normalBackImageview.backgroundColor = [UIColor whiteColor];
        _normalBackImageview.image = [UIImage imageNamed:@"icon_normal_nav_back"];
        _normalBackImageview.contentMode = UIViewContentModeScaleAspectFill;
        _normalBackImageview.clipsToBounds = YES;
        
    }
    return _normalBackImageview;
}



#pragma mark -  pop

- (void)popViewController
{
    BOOL pop = NO;
    
    if (self.backBlock) {
        self.backBlock();
        return;
    }
    
    
    NSArray *viewcontrollers = self.navCurrentController.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
            pop = YES;
            [self.navCurrentController.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navCurrentController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (!pop) {
        [self.navCurrentController.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    if (_navCurrentController) {
        [_navCurrentController willMoveToParentViewController:nil];
        [_navCurrentController.view removeFromSuperview];
        [_navCurrentController removeFromParentViewController];
    }
}


- (UIButton *)setRightButtonWithImage:(NSString *)imageName
{
    UIButton *rightBtn = [UIButton buttonWithTitle:@"" titleColor:rgba(51, 51, 51, 1) font:[YQUtils systemMediumFontOfSize:17]];
    [self addSubview:rightBtn];
    [rightBtn setImage:[UIImage imageNamed:imageName] forState:0];
    [rightBtn sizeToFit];
    rightBtn.frame = CGRectMake(ScreenWidth - 30 -  rightBtn.mj_w, 0, rightBtn.mj_w + 30, 30);
    rightBtn.centerY = self.navTitleLabel.center.y;
    return  rightBtn;
}

- (UIButton *)setRightButtonWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color
{
    UIButton *rightBtn = [UIButton buttonWithTitle:title.localized titleColor:color font:font];
    [self addSubview:rightBtn];
    [rightBtn sizeToFit];
    rightBtn.frame = CGRectMake(ScreenWidth - 30 - rightBtn.mj_w, 0, rightBtn.mj_w + 30, 30);
    rightBtn.centerY = self.navTitleLabel.center.y;
    return  rightBtn;
}

@end
