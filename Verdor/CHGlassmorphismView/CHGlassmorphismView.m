#import "CHGlassmorphismView.h"

@interface CHGlassmorphismView ()
// MARK: - Properties
@property (nonatomic, strong) UIViewPropertyAnimator *animator;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, assign) CHTheme theme;
@property (nonatomic, assign) CGFloat animatorCompletionValue;
@property (nonatomic, assign) CGFloat cornerRadiusValue;
@property (nonatomic, assign) CGFloat distanceValue;
@property (nonatomic, assign) BOOL isViewBecameInvisible;
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation CHGlassmorphismView

// MARK: - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.animator stopAnimation:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window == nil) {
        [self handleViewInvisible];
    } else if (self.window != nil && self.isViewBecameInvisible) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleViewVisible];
        });
    }
}

// MARK: - Background Handling
- (void)observeAppState {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleViewVisible)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleViewInvisible)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)handleViewVisible {
    if (self.isViewBecameInvisible) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self makeGlassmorphismEffectWithTheme:self.theme
                                          density:self.animatorCompletionValue
                                     cornerRadius:self.cornerRadiusValue
                                         distance:self.distanceValue];
        });
    }
}

- (void)handleViewInvisible {
    self.isViewBecameInvisible = YES;
}

// MARK: - Public Methods
- (void)makeGlassmorphismEffectWithTheme:(CHTheme)theme
                                density:(CGFloat)density
                            cornerRadius:(CGFloat)cornerRadius
                                distance:(CGFloat)distance {
    [self setTheme:theme];
    [self setBlurDensityWithDensity:density];
    [self setCornerRadius:cornerRadius];
    [self setDistance:distance];
}

- (void)setTheme:(CHTheme)theme {
    _theme = theme;
    WeakSelf;
    switch (theme) {
        case CHThemeLight: {
            self.blurView.effect = nil;
            self.blurView.backgroundColor = UIColor.clearColor;
            [self.animator stopAnimation:YES];
            [self.animator addAnimations:^{
                weakSelf.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            }];
            self.animator.fractionComplete = self.animatorCompletionValue;
            self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
            break;
        }
        case CHThemeDark: {
            self.blurView.effect = nil;
            self.blurView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.35];
            [self.animator stopAnimation:YES];
            [self.animator addAnimations:^{
                weakSelf.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            }];
            self.animator.fractionComplete = self.animatorCompletionValue;
            self.layer.borderColor = [UIColor.whiteColor colorWithAlphaComponent:0.3].CGColor;
            break;
        }
    }
}

- (void)setBlurDensityWithDensity:(CGFloat)density {
    self.animatorCompletionValue = density;
    self.animator.fractionComplete = density;
}

- (void)setCornerRadius:(CGFloat)value {
    self.cornerRadiusValue = value;
    self.backgroundView.layer.cornerRadius = value;
    self.blurView.layer.cornerRadius = value;
}

- (void)setDistance:(CGFloat)value {
    self.distanceValue = value;
    CGFloat distance = value;
    if (value < 0) {
        distance = 0;
    } else if (value > 100) {
        distance = 100;
    }
    self.backgroundView.layer.shadowRadius = distance;
}

// MARK: - Private Methods
- (void)initialize {
    // Default values
    _animatorCompletionValue = 0.65;
    _cornerRadiusValue = 20;
    _distanceValue = 20;
    _isViewBecameInvisible = NO;
    
    // Configure background view
    _backgroundView = [[UIView alloc] init];
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _backgroundView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    _backgroundView.layer.borderWidth = 1;
    _backgroundView.layer.cornerRadius = 20;
    _backgroundView.clipsToBounds = YES;
    _backgroundView.layer.masksToBounds = NO;
    _backgroundView.layer.shadowColor = UIColor.appThemeColor.CGColor;
    _backgroundView.layer.shadowOffset = CGSizeMake(0, 0);
    _backgroundView.layer.shadowOpacity = 0.3;
    _backgroundView.layer.shadowRadius = 20.0;
    
    [self insertSubview:_backgroundView atIndex:0];
    
    // Configure blur view
    _blurView = [[UIVisualEffectView alloc] init];
    _blurView.layer.masksToBounds = YES;
    _blurView.layer.cornerRadius = 20;
    _blurView.backgroundColor = UIColor.clearColor;
    _blurView.translatesAutoresizingMaskIntoConstraints = NO;
    [_backgroundView insertSubview:_blurView atIndex:0];
    
    // Layout constraints
    [NSLayoutConstraint activateConstraints:@[
        [_backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_backgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_backgroundView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
        [_backgroundView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
        [_blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_blurView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
        [_blurView.widthAnchor constraintEqualToAnchor:self.widthAnchor]
    ]];
    
    // Configure animator
    _animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 curve:UIViewAnimationCurveLinear animations:nil];
    WeakSelf;
    [_animator addAnimations:^{
        weakSelf.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }];
    _animator.fractionComplete = _animatorCompletionValue;
    
    // Initial setup
    [self setTheme:CHThemeLight];
    [self observeAppState];
}

// MARK: - Property Override
- (UIColor *)backgroundColor {
    return UIColor.clearColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    // Do nothing - always clear
}

@end
