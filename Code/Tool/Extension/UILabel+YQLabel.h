//
//   NSObject+YQLabel.h
   

#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//IB_DESIGNABLE
@interface UILabel (YQLabel)

///行距
- (NSMutableAttributedString *)setLineSpace:(id)string
                                      space:(CGFloat)space;

///设置颜色和大小
- (NSMutableAttributedString *)setColorAndFontSizeWithString: (id)string
                                                        font: (UIFont *__nullable)font
                                                       color: (UIColor *__nullable)color
                                                        rang: (NSRange)rang ;

///只设置颜色
- (NSMutableAttributedString *)setColorWithSting: (id)string
                                           range: (NSRange)range
                                           color: (UIColor *__nullable)color;

/// 设置大小
- (NSMutableAttributedString *)setFontSizeWithString: (id)string
                                                font: (UIFont *__nullable)font
                                               range: (NSRange)range;


/**
 创建Label
 @param labelText Label的文字
 @param textColor 文字颜色
 @param font 文字大小
 @param textLines 文字行数
 @param backgroundColor 背景色
 @param superView 父视图
 @return Label
 */
+ (instancetype)YQLabelWithString:(NSString *__nullable)labelText
                         textColor:(UIColor *__nullable)textColor
                              font:(UIFont *__nullable)font
                         textLines:(NSUInteger)textLines
                   backgroundColor:(UIColor *__nullable)backgroundColor
                         superView:(UIView *__nullable)superView;
/**
 创建Label
 @param labelText Label的文字
 @param textColor 文字颜色
 @param font 文字大小
 @param textLines 文字行数
 @param backgroundColor 背景色
 @return Label
 */
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                         textLines:(NSUInteger)textLines
                   backgroundColor:(UIColor *)backgroundColor;
/**
 创建Label
 
 @param labelText Label的文字
 @param textColor 文字颜色
 @param font 文字大小
 @param textLines 文字行数
 @return Label
 */
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                         textLines:(NSUInteger)textLines;
/**
 创建Label
 
 @param labelText Label的文字
 @param textColor 文字颜色
 @param font 文字大小
 @return Label
 */
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font;
/**
 创建Label
 
 @param labelText Label的文字
 @param textColor 文字颜色
 @return Label
 */
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor;
/**
 创建Label
 
 @param labelText Label的文字
 @return Label
 */
+ (instancetype)YQLabelWithString:(NSString *)labelText;

/**
 创建Label
 
 @param labelText Label的文字
 @param textColor 文字颜色
 @param font 文字大小
 @param backgroundColor 背景色
 @param superView 父视图
 @return Label
 */
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                   backgroundColor:(UIColor *)backgroundColor
                         superView:(UIView *)superView;
/**
 创建Label
 
 @param labelText Label的文字
 @param textColor 文字颜色
 @param font 文字大小
 @param backgroundColor 背景色
 @return Label
 */
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                   backgroundColor:(UIColor *)backgroundColor;


+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                         superView:(UIView *)superView;

@property (nonatomic, assign) IBInspectable BOOL needLanguage;

@end

NS_ASSUME_NONNULL_END
