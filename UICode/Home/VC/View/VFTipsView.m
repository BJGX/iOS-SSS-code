//
//  VFTipsView.m
//  VFProject
//


//

#import "VFTipsView.h"


@interface VFTipsView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) stateBlock block;
@end

@implementation VFTipsView


+ (void)showView:(NSString *)title
         content:(NSString *)content
         leftBtn:(NSString *)leftBtn
        rightBtn:(NSString *)rightBtn
           block:(stateBlock)block
{
    UIWindow *key = [YQUtils getKeyWindow];
    VFTipsView *view = [[VFTipsView alloc] initWithFrame:key.bounds];
    [key addSubview:view];
    [view initUI:title.localized content:content.localized leftBtn:leftBtn rightBtn:rightBtn block:block];
    
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initUI];
    }
    return self;
}

- (void)initUI:(NSString *)title
       content:(NSString *)content
       leftBtn:(NSString *)leftBtnString
      rightBtn:(NSString *)rightBtnString
         block:(stateBlock)block
{
    
    self.block = block;
    
    self.backgroundColor = rgba(0, 0, 0, 0.5);
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor tableBackgroundColor];
    [self addSubview:self.contentView];
    self.contentView.cornerRadius = 10;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.offset(ScreenWidth - 60);
    }];
    
    UILabel *label = [UILabel YQLabelWithString:title textColor:[UIColor mainTextColor] font:[YQUtils systemSemiboldFontOfSize:17] superView:self.contentView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    label.textAlignment = NSTextAlignmentCenter;

        
    UILabel *contentLabel = [UILabel YQLabelWithString:content textColor:[UIColor mainTextColor] font:[YQUtils systemMediumFontOfSize:16] superView:self.contentView];
    contentLabel.numberOfLines = 0;
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(15);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-80);
    }];
    [self layoutIfNeeded];
    

    CGFloat y = contentLabel.frame.size.height;
    if (y < 24) {
        contentLabel.textAlignment = NSTextAlignmentCenter;
    }
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(y+60);
//    }];
    

        
    
    WeakSelf;
    UIButton *leftBtn = [UIButton buttonWithTitle:leftBtnString titleColor:[UIColor appThemeColor] font:[YQUtils systemMediumFontOfSize:16] backgroundColor:[UIColor clearColor] superView:self.contentView btnClick:^(UIButton *btn) {
        if (block) {
            block(0);
        }
        [weakSelf removeSelf];
    }];
    leftBtn.cornerRadius = 20;
    leftBtn.borderColor = [UIColor appThemeColor];
    leftBtn.borderWidth = 1;
    leftBtn.hidden = YES;
    
    UIButton *rightBtn = [UIButton buttonWithTitle:rightBtnString titleColor:[UIColor whiteColor] font:[YQUtils systemMediumFontOfSize:16] backgroundColor:[UIColor appThemeColor] superView:self.contentView btnClick:^(UIButton *btn) {
        if (block) {
            block(1);
        }
        [weakSelf removeSelf];
    }];
    rightBtn.cornerRadius = 20;
    rightBtn.hidden = YES;
    
    if (rightBtnString.length > 0 && leftBtnString.length > 0) {
        rightBtn.hidden = NO;
        leftBtn.hidden = NO;
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(120);
            make.height.offset(40);
            make.bottom.mas_equalTo(self.contentView).offset(-15);
            make.centerX.mas_equalTo(self.contentView).offset(-65);
        }];
        
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(120);
            make.height.offset(40);
            make.bottom.mas_equalTo(self.contentView).offset(-15);
            make.centerX.mas_equalTo(self.contentView).offset(65);
        }];
        
        
    }
    
    else if (rightBtnString.length > 0) {
        rightBtn.hidden = NO;
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(120);
            make.height.offset(40);
            make.bottom.mas_equalTo(self.contentView).offset(-15);
            make.centerX.mas_equalTo(self.contentView);
        }];
        
    }
    
    
    else if (leftBtnString.length > 0) {
        leftBtn.hidden = NO;
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(120);
            make.height.offset(40);
            make.bottom.mas_equalTo(self.contentView).offset(-15);
            make.centerX.mas_equalTo(self.contentView);
        }];
        
    }
    
    [self showAnimation];
    
    
    
}

- (void)showAnimation
{
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        [self layoutIfNeeded];
    }];
}


- (void)removeSelf
{
    __block VFTipsView *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        weakSelf = nil;
    }];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
