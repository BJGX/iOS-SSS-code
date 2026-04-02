#import "UIButton+WH_Button.h"
#import <objc/runtime.h>

NSInteger countDownNumber;
//MSWeakTimer *timer;

//typedef void(^ButtonClickedBlock)();
//typedef void(^CountDownStartBlock)();
//typedef void(^CountDownUnderwayBlock)(NSInteger restCountDownNum);
//typedef void(^CountDownCompletionBlock)();

static const char *btnKey = "btnBlockKey";

NSInteger countDownNumber;
NSTimer *timer;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-property-implementation"

@interface UIButton()

/////** 控制倒计时的timer */
//@property (nonatomic, strong) MSWeakTimer *timer;
//@property (nonatomic, assign) NSInteger startCountDownNum;

///** 按钮点击事件的回调 */
//@property (nonatomic, copy) ButtonClickedBlock buttonClickedBlock;
///** 倒计时开始时的回调 */
//@property (nonatomic, copy) CountDownStartBlock countDownStartBlock;
///** 倒计时进行中的回调（每秒一次） */
//@property (nonatomic, copy) CountDownUnderwayBlock countDownUnderwayBlock;
///** 倒计时完成时的回调 */
//@property (nonatomic, copy) CountDownCompletionBlock countDownCompletionBlock;

@end

@implementation UIButton (WH_Button)


- (void)setNeedLanguage:(BOOL)needLanguage
{
    if (needLanguage) {
        [self setTitle:self.currentTitle.localized forState:UIControlStateNormal];
    }
}


- (void)setYy_contentEdgeInsets:(UIEdgeInsets)yy_contentEdgeInsets
{
    
    self.contentEdgeInsets = yy_contentEdgeInsets;
//    UIButtonConfiguration *config = self.configuration;
    
    
//   
//    UIFont *font = self.titleLabel.font;
//    UIButtonConfiguration * config = [[UIButtonConfiguration alloc]updatedConfigurationForButton:self];
//    config.contentInsets = NSDirectionalEdgeInsetsMake(yy_contentEdgeInsets.top, yy_contentEdgeInsets.left, yy_contentEdgeInsets.bottom, yy_contentEdgeInsets.right);
////    config setti
//    
//    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.currentTitle];
//    [attributedString addAttribute:NSFontAttributeName
//                             value:font
//                             range:NSMakeRange(0, attributedString.length)];
//    config.attributedTitle = attributedString;
//    self.configuration = config;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.titleLabel.font = font;
//    });
    
}




/** 开始倒计时 */
- (void)startCountDown: (int) startCountDownNum  {
    countDownNumber = startCountDownNum;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    self.selected = YES;
    self.userInteractionEnabled = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshButton) userInfo:nil repeats:YES];
}

- (void)stopCountDown {
    [timer invalidate];
    timer = nil;
    [self setTitle:@"重新获取" forState: UIControlStateNormal];
    self.userInteractionEnabled = YES;
    self.selected = NO;
}

/** 刷新按钮内容 */
- (void)refreshButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = [NSString stringWithFormat:@"%lds", (long)countDownNumber];
        [self setTitle:title forState: UIControlStateNormal];
        countDownNumber --;
        
        if (countDownNumber <= 0) {
            [timer invalidate];
            timer = nil;
            [self setTitle:@"重新获取" forState: UIControlStateNormal];
            self.userInteractionEnabled = YES;
            self.selected = NO;
        }
    });
    
}


- (void)setBtnClick:(void (^)(UIButton *))btnClick {
    objc_setAssociatedObject(self, &btnKey, btnClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//- (void (^)(UIButton *))btnClick
- (void (^)(UIButton *))btnClick {
    return objc_getAssociatedObject(self, &btnKey);
}
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage superView:(UIView *)superView layoutBlock:(void (^)(UIButton *btn))layoutBlock btnClick:(void(^)(UIButton *btn))btnClick {
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    
    [btn setTitle:title.localized forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if (normalImage) {
        [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    }
    
    btn.backgroundColor = backgroundColor;
    [superView addSubview:btn];
    if (layoutBlock) {
        layoutBlock(btn);
        
    }
    btn.btnClick = btnClick;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;

}
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                backgroundColor:(UIColor *)backgroundColor
                    normalImage:(NSString *)normalImage
                  selectedImage:(NSString *)selectedImage
                      superView:(UIView *)superView
                    layoutBlock:(void (^)(UIButton *btn))layoutBlock{
    return [self buttonWithTitle:title titleColor:titleColor font:font backgroundColor:backgroundColor normalImage:normalImage selectedImage:selectedImage superView:superView layoutBlock:layoutBlock btnClick:nil];
}
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                backgroundColor:(UIColor *)backgroundColor
                    normalImage:(NSString *)normalImage
                  selectedImage:(NSString *)selectedImage
                      superView:(UIView *)superView{
    return [self buttonWithTitle:title titleColor:titleColor font:font backgroundColor:backgroundColor normalImage:normalImage selectedImage:selectedImage superView:superView layoutBlock:nil btnClick:nil];
}
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                backgroundColor:(UIColor *)backgroundColor
                    normalImage:(NSString *)normalImage
                  selectedImage:(NSString *)selectedImage{
    return [self buttonWithTitle:title titleColor:titleColor font:font backgroundColor:backgroundColor normalImage:normalImage selectedImage:selectedImage superView:nil layoutBlock:nil btnClick:nil];
}
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                backgroundColor:(UIColor *)backgroundColor
                    normalImage:(NSString *)normalImage{
    return [self buttonWithTitle:title titleColor:titleColor font:font backgroundColor:backgroundColor normalImage:normalImage selectedImage:nil superView:nil layoutBlock:nil btnClick:nil];
}
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font{
    return [self buttonWithTitle:title titleColor:titleColor font:font backgroundColor:nil normalImage:nil selectedImage:nil superView:nil layoutBlock:nil btnClick:nil];
}
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor{
    return [self buttonWithTitle:title titleColor:titleColor font:nil backgroundColor:nil normalImage:nil selectedImage:nil superView:nil layoutBlock:nil btnClick:nil];
}
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                backgroundColor:(UIColor *)backgroundColor
                      superView:(UIView *)superView
                    layoutBlock:(void (^)(UIButton *btn))layoutBlock
                       btnClick:(void(^)(UIButton *btn))btnClick{
    return [self buttonWithTitle:title titleColor:titleColor font:font backgroundColor:backgroundColor normalImage:nil selectedImage:nil superView:superView layoutBlock:layoutBlock btnClick:btnClick];;
}
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                backgroundColor:(UIColor *)backgroundColor
                      superView:(UIView *)superView
                       btnClick:(void(^)(UIButton *btn))btnClick{
    return [self buttonWithTitle:title titleColor:titleColor font:font backgroundColor:backgroundColor normalImage:nil selectedImage:nil superView:superView layoutBlock:nil btnClick:btnClick];
}
+ (instancetype)buttonWithNormalImage:(NSString *)normalImage
                        selectedImage:(NSString *)selectedImage
                            superView:(UIView *)superView
                          layoutBlock:(void (^)(UIButton *btn))layoutBlock
                             btnClick:(void(^)(UIButton *btn))btnClick{
    return [self buttonWithTitle:nil titleColor:nil font:nil backgroundColor:nil normalImage:normalImage selectedImage:selectedImage superView:superView layoutBlock:layoutBlock btnClick:btnClick];
}
+ (instancetype)buttonWithNormalImage:(NSString *)normalImage
                        selectedImage:(NSString *)selectedImage
                            superView:(UIView *)superView
                             btnClick:(void(^)(UIButton *btn))btnClick{
    return [self buttonWithTitle:nil titleColor:nil font:nil backgroundColor:nil normalImage:normalImage selectedImage:selectedImage superView:superView layoutBlock:nil btnClick:btnClick];;
}

+ (void)btnClick:(UIButton *)btn {
    if (btn.btnClick) {
        btn.btnClick(btn);
    }
}

- (void)attributeColorAndFontSizeWithLabel:(NSString *)string font:(CGFloat)font fontRang:(NSRange)fontRang colorRange:(NSRange)colorRange color:(UIColor *)color isBold:(BOOL)isBold {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:string];
    if (isBold) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:fontRang];
    }
    else {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:fontRang];
    }
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    [self setAttributedTitle:attrStr forState:0];
    
}


- (void)attributeColorWithLabel:(NSString *)string fromLocation:(NSInteger)fromLocation length:(NSInteger)length color:(UIColor *)color{
    
    if (string == nil ) {
        return;
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:string];
    [attrStr addAttribute:NSForegroundColorAttributeName value:self.currentTitleColor range:NSMakeRange(0, string.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(fromLocation, length)];
    [self setAttributedTitle:attrStr forState:0];
}

- (void)attributeColorWithLabel2:(NSString *)string range:(NSRange)range color:(UIColor *)color {
    
    if (string == nil) {
        return;
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:string];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [self setAttributedTitle:attrStr forState:0];
}

- (void)attributeFontSizeWithLabel:(NSString *)string font:(CGFloat)font fromLocation:(NSInteger)fromLocation length:(NSInteger)length isBold:(BOOL)isBold {
    
    if (string == nil) {
        return;
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:string];
    if (isBold) {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:NSMakeRange(fromLocation, length)];
    }
    else {
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(fromLocation, length)];
    }
    
    [self setAttributedTitle:attrStr forState:0];
    [self sizeToFit];
}

///行距
- (NSMutableAttributedString *)setLineSpace:(id)string
                                      space:(CGFloat)space
{
    if (string == nil) {
        return nil;
    }
    NSMutableAttributedString *attrStr;
    if ([string isKindOfClass:[NSString class]]) {
        attrStr = [[NSMutableAttributedString alloc]initWithString:string];
    }
    else {
        attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:string];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];//调整行间距
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[self currentTitleColor] range:NSMakeRange(0, [string length])];
    [self setAttributedTitle:attrStr forState:0];
//    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return attrStr;
}


- (void)setUpImageAndDownLableWithSpace:(CGFloat)upImageAndDownLableWithSpace {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGSize imageSize = self.imageView.frame.size;
        CGSize titleSize = self.titleLabel.frame.size;
        
        // 测试的时候发现titleLabel的宽度不正确，这里进行判断处理
        CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
        if (titleSize.width < labelWidth) {
            titleSize.width = labelWidth;
        }
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        // 文字距上边框的距离增加imageView的高度+间距，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        UIEdgeInsets title = UIEdgeInsetsMake((imageSize.height / 2.0)+upImageAndDownLableWithSpace, -imageSize.width, -upImageAndDownLableWithSpace, 0.0);
        [self setTitleEdgeInsets:title];
        
        // 图片距右边框的距离减少图片的宽度，距离上面的间隔，其它不变
        [self setImageEdgeInsets:UIEdgeInsetsMake(-upImageAndDownLableWithSpace - (imageSize.height / 2.0), 0.0,0.0,-titleSize.width)];
    });
}


- (void)setLeftTitleAndRightImageWithSpace:(CGFloat)leftTitleAndRightImageWithSpace {

    
    if (ScreenWidth == 320) {
        leftTitleAndRightImageWithSpace += 6;
    }
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // 测试的时候发现titleLabel的宽度不正确，这里进行判断处理
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    if (titleSize.width < labelWidth) {
        titleSize.width = labelWidth;
    }
    // 文字距左边框的距离减少imageView的宽度-间距，右侧增加距离imageView的宽度
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -imageSize.width/2.0 - leftTitleAndRightImageWithSpace, 0.0, imageSize.width)];
    // 图片距左边框的距离增加titleLable的宽度,距右边框的距离减少titleLable的宽度
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, titleSize.width+leftTitleAndRightImageWithSpace,self.imageEdgeInsets.bottom,-titleSize.width)];
}

- (void)setRightTitleAndLeftImageWithSpace:(CGFloat)rightTitleAndLeftImageWithSpace {
    
    CGSize titleSize = self.titleLabel.frame.size;
       
   // 测试的时候发现titleLabel的宽度不正确，这里进行判断处理
   CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
   if (titleSize.width < labelWidth) {
       titleSize.width = labelWidth;
   }
   // 文字距左边框的距离减少imageView的宽度-间距，右侧增加距离imageView的宽度
   [self setTitleEdgeInsets:UIEdgeInsetsMake(0, rightTitleAndLeftImageWithSpace, 0.0, -rightTitleAndLeftImageWithSpace)];
   // 图片距左边框的距离增加titleLable的宽度,距右边框的距离减少titleLable的宽度
   [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0,0.0,rightTitleAndLeftImageWithSpace)];
}


@end



#pragma clang diagnostic pop
