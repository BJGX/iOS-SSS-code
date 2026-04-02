



#import <UIKit/UIKit.h>

extern NSInteger countDownNumber;
//IB_DESIGNABLE
@interface UIButton (WH_Button)



///开始a倒计时
- (void)startCountDown: (int) startCountDownNum;

///停止倒计时;
- (void)stopCountDown;


@property (nonatomic, strong) void (^btnClick)(UIButton *btn);
@property (nonatomic, assign) UIEdgeInsets yy_contentEdgeInsets;

///上图下文字设置
@property (nonatomic,assign)IBInspectable CGFloat upImageAndDownLableWithSpace;

///右图左文字
@property (nonatomic,assign)IBInspectable CGFloat leftTitleAndRightImageWithSpace;


@property (nonatomic,assign)IBInspectable CGFloat rightTitleAndLeftImageWithSpace;

@property (nonatomic, assign) IBInspectable BOOL needLanguage;




/**
 创建button
 @param title 按钮标题
 @param titleColor 按钮标题颜色
 @param font 文字大小
 @param backgroundColor 按钮背景色
 @param normalImage 正常图片
 @param selectedImage 选中时的图片
 @param superView 父视图
 @param layoutBlock 布局回调
 @param btnClick 按钮点击事件
 @return button
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                backgroundColor:(UIColor *)backgroundColor
                    normalImage:(NSString *)normalImage
                  selectedImage:(NSString *)selectedImage
                      superView:(UIView *)superView
                    layoutBlock:(void (^)(UIButton *btn))layoutBlock
                       btnClick:(void(^)(UIButton *btn))btnClick;

/**
 创建button
 @param title 按钮标题
 @param titleColor 按钮标题颜色
 @param font 文字大小
 @param backgroundColor 按钮背景色
 @param normalImage 正常图片
 @param selectedImage 选中时的图片
 @param superView 父视图
 @param layoutBlock 布局回调
 @return button
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
                          font:(UIFont *)font
               backgroundColor:(UIColor *)backgroundColor
                   normalImage:(NSString *)normalImage
                 selectedImage:(NSString *)selectedImage
                     superView:(UIView *)superView
                   layoutBlock:(void (^)(UIButton *btn))layoutBlock;
/**
 创建button
 @param title 按钮标题
 @param titleColor 按钮标题颜色
 @param font 文字大小
 @param backgroundColor 按钮背景色
 @param normalImage 正常图片
 @param selectedImage 选中时的图片
 @param superView 父视图
 @return button
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
                          font:(UIFont *)font
               backgroundColor:(UIColor *)backgroundColor
                   normalImage:(NSString *)normalImage
                 selectedImage:(NSString *)selectedImage
                     superView:(UIView *)superView;
/**
 创建button
 @param title 按钮标题
 @param titleColor 按钮标题颜色
 @param font 文字大小
 @param backgroundColor 按钮背景色
 @param normalImage 正常图片
 @param selectedImage 选中时的图片
 @return button
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
                          font:(UIFont *)font
               backgroundColor:(UIColor *)backgroundColor
                   normalImage:(NSString *)normalImage
                 selectedImage:(NSString *)selectedImage;
/**
 创建button
 @param title 按钮标题
 @param titleColor 按钮标题颜色
 @param font 文字大小
 @param backgroundColor 按钮背景色
 @param normalImage 正常图片
 @return button
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
                          font:(UIFont *)font
               backgroundColor:(UIColor *)backgroundColor
                   normalImage:(NSString *)normalImage;
/**
 创建button
 @param title 按钮标题
 @param titleColor 按钮标题颜色
 @param font 文字大小
 @return button
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
                          font:(UIFont *)font;
/**
 创建button
 @param title 按钮标题
 @param titleColor 按钮标题颜色
 @return button
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor;
/**
 创建button

 @param title 按钮标题
 @param titleColor 标题颜色
 @param font 文字大小
 @param backgroundColor 背景色
 @param superView 父视图
 @param layoutBlock 布局Block
 @param btnClick 按钮点击事件
 @return button;
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                backgroundColor:(UIColor *)backgroundColor
                      superView:(UIView *)superView
                    layoutBlock:(void (^)(UIButton *btn))layoutBlock
                       btnClick:(void(^)(UIButton *btn))btnClick;
/**
 创建button
 @param title 按钮标题
 @param titleColor 标题颜色
 @param font 文字大小
 @param backgroundColor 背景色
 @param superView 父视图
 @param btnClick 按钮点击事件
 @return button;
 */

+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                           font:(UIFont *)font
                backgroundColor:(UIColor *)backgroundColor
                      superView:(UIView *)superView
                       btnClick:(void(^)(UIButton *btn))btnClick;
/**
 创建button
 @param normalImage 正常图片
 @param selectedImage 选中时的图片
 @param superView 父视图
 @param layoutBlock 布局Block
 @param btnClick 按钮点击事件
 @return button
 */
+ (instancetype)buttonWithNormalImage:(NSString *)normalImage
                        selectedImage:(NSString *)selectedImage
                            superView:(UIView *)superView
                          layoutBlock:(void (^)(UIButton *btn))layoutBlock
                             btnClick:(void(^)(UIButton *btn))btnClick;
/**
 创建button

 @param normalImage 正常图片
 @param selectedImage 选中图片
 @param superView 父视图
 @param btnClick 按钮点击事件
 @return button
 */
+ (instancetype)buttonWithNormalImage:(NSString *)normalImage
                        selectedImage:(NSString *)selectedImage
                            superView:(UIView *)superView
                             btnClick:(void(^)(UIButton *btn))btnClick;




///行距
- (NSMutableAttributedString *)setLineSpace:(id)string
                                      space:(CGFloat)space;

- (void)attributeColorAndFontSizeWithLabel: (NSString *)string font: (CGFloat )font fontRang: (NSRange)fontRang colorRange: (NSRange)colorRange color: (UIColor *)color isBold: (BOOL)isBold;

- (void)attributeColorWithLabel: (NSString *)string fromLocation: (NSInteger)fromLocation length: (NSInteger)length color: (UIColor *)color;
- (void)attributeColorWithLabel2: (NSString *)string range: (NSRange) range color: (UIColor *)color;

- (void)attributeFontSizeWithLabel: (NSString *)string font: (CGFloat )font fromLocation: (NSInteger)fromLocation length: (NSInteger)length isBold: (BOOL)isBold;

//- (void)setUpImageAndDownLableWithSpace:(CGFloat)space;




@end
