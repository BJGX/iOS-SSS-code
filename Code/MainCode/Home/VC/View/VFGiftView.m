//
//  VFGiftView.m
//  VFProject
//

//

#import "VFGiftView.h"

@interface VFGiftView()

@property (nonatomic, copy) stateBlock block;

@end

@implementation VFGiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ///141
        self.backgroundColor = rgba(0, 0, 0, 0.5);
        UIView *contentView = [UIView viewWithFrame:CGRectMake(0, 0, 274, 320) backgroundColor:[UIColor whiteColor] superView:self];
        contentView.cornerRadius = 20;
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 27, 88, 88)];
        imageview.image = [UIImage imageNamed:@"img_gift"];
        [contentView addSubview:imageview];
        imageview.centerX = 274/2.0;
        
        NSString *title = [NSString stringWithFormat:@"%@ %ld%@VIP",@"免费赠您".localized, [YQUserModel shared].user.gift_time,@"分钟".localized];
        UILabel *tipslabe = [UILabel YQLabelWithString:title textColor:[UIColor mainTextColor] font:[YQUtils systemMediumFontOfSize:17] superView:contentView];
        tipslabe.frame = CGRectMake(0, CGRectGetMaxY(imageview.frame)+15, 274, 18);
        tipslabe.textAlignment = NSTextAlignmentCenter;
        [tipslabe setColorWithSting:title range:NSMakeRange(4, title.length - 7) color:rgba(255, 182, 146, 1)];
        
        UILabel *infoLabel = [UILabel YQLabelWithString:@"每日都可领免费VIP时间" textColor:[UIColor subTextColor] font:Font(16) superView:contentView];
        infoLabel.numberOfLines = 0;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.frame = CGRectMake(0, CGRectGetMaxY(tipslabe.frame)+15, 274, 20);
        
        WeakSelf;
        UIButton *btn = [UIButton buttonWithTitle:@"立即领取" titleColor:[UIColor whiteColor] font:[YQUtils systemMediumFontOfSize:16] backgroundColor:[UIColor appThemeColor] superView:contentView btnClick:^(UIButton *btn) {
            [weakSelf reviceGift];
        }];
        
        btn.frame = CGRectMake(0, CGRectGetMaxY(infoLabel.frame)+15, 230, 48);
        btn.centerX = 274/2.0;
        btn.cornerRadius = 18;
        
        contentView.mj_h = CGRectGetMaxY(btn.frame)+20;
        
        contentView.center = self.center;
        
        [self addTapActionWithBlock:^(UIGestureRecognizer * _Nullable sender) {
            [weakSelf hiddenView];
        }];
        
    }
    return self;
}

+ (void)showView:(stateBlock)block
{
    UIWindow *window = [YQUtils getKeyWindow];
    VFGiftView *view = [[VFGiftView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [window addSubview:view];
    view.block = block;
    view.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 1;
    }];
    
}

- (void)hiddenView
{
    __block VFGiftView *view = self;
    [UIView animateWithDuration:0.2 animations:^{
            view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        view = nil;
    }];
}

- (void)reviceGift
{
    [self hiddenView];
    NSString *url = @"api/en/mine/receiveGift";
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:@"正在领取" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            [YQUtils showCenterMessage:@"领取成功"];
        }
        if (self.block) {
            self.block(code);
        }
    }];
}



@end
