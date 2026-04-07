//
//   NSObject+YQLabel.m
   

#import "UILabel+YQLabel.h"
#import <objc/runtime.h>



@implementation UILabel (YQLabel)


- (BOOL)needLanguage {
    return objc_getAssociatedObject(self, @selector(needLanguage));
}
- (void)setNeedLanguage:(BOOL)needLanguage
{
    if (needLanguage) {
        self.text = self.text.localized;
    }
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
    self.attributedText = attrStr;
    return attrStr;
}

///设置颜色和大小
- (NSMutableAttributedString *)setColorAndFontSizeWithString: (id)string
                                                        font: (UIFont *__nullable)font
                                                       color: (UIColor *__nullable)color
                                                        rang: (NSRange)rang
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
    if (rang.location > attrStr.string.length) {
        return attrStr;
    }
    
    if (rang.length > attrStr.string.length) {
        return attrStr;
    }
    
    if (rang.location + rang.length > attrStr.string.length) {
        return attrStr;
    }
    
    if (font) {
        [attrStr addAttribute:NSFontAttributeName value:font range:rang];
    }
    
    if (color) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:rang];
    }
    
    self.attributedText = attrStr;
    return attrStr;
}

///只设置颜色
- (NSMutableAttributedString *)setColorWithSting: (id)string
                                           range: (NSRange)range
                                           color: (UIColor *__nullable)color {
    
    return  [self setColorAndFontSizeWithString:string font:nil color:color rang:range];
}

/// 设置大小
- (NSMutableAttributedString *)setFontSizeWithString: (id)string
                                                font: (UIFont *__nullable)font
                                               range: (NSRange)range {
    return  [self setColorAndFontSizeWithString:string font:font color:nil rang:range];
}







+ (instancetype)YQLabelWithString:(NSString *__nullable)labelText
                           textColor:(UIColor *__nullable)textColor
                                font:(UIFont *__nullable)font
                           textLines:(NSUInteger)textLines
                     backgroundColor:(UIColor *__nullable)backgroundColor
                           superView:(UIView *__nullable)superView{
    UILabel *label = [[self alloc]init];
    label.text = labelText.localized;
    label.textColor = textColor;
    label.font = font;
    label.numberOfLines = textLines;
    label.backgroundColor = backgroundColor;
    if (superView) {
        [superView addSubview:label];
    }
    return label;

}

+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                         textLines:(NSUInteger)textLines
                   backgroundColor:(UIColor *)backgroundColor {
    return [self YQLabelWithString:labelText textColor:textColor font:font textLines:1 backgroundColor:backgroundColor superView:nil];
}
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                         textLines:(NSUInteger)textLines{
    return [self YQLabelWithString:labelText textColor:textColor font:font textLines:1 backgroundColor:[UIColor whiteColor] superView:nil];
}
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font{
   return [self YQLabelWithString:labelText textColor:textColor font:font textLines:1 backgroundColor:[UIColor clearColor] superView:nil];
}
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor{
    return [self YQLabelWithString:labelText textColor:textColor font:nil textLines:1 backgroundColor:[UIColor clearColor] superView:nil];
}
+ (instancetype)YQLabelWithString:(NSString *)labelText {
    return [self YQLabelWithString:labelText textColor:nil font:nil textLines:1 backgroundColor:[UIColor clearColor] superView:nil];
}

+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                   backgroundColor:(UIColor *)backgroundColor
                         superView:(UIView *)superView{
    return [self YQLabelWithString:labelText textColor:textColor font:font textLines:1 backgroundColor:backgroundColor superView:superView];
}
+ (instancetype)YQLabelWithString:(NSString *)labelText
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
                   backgroundColor:(UIColor *)backgroundColor{
    return [self YQLabelWithString:labelText textColor:textColor font:font textLines:1 backgroundColor:backgroundColor superView:nil];
}

+(instancetype)YQLabelWithString:(NSString *)labelText
                        textColor:(UIColor *)textColor
                             font:(UIFont *)font
                        superView:(UIView *)superView{
    return [self YQLabelWithString:labelText textColor:textColor font:font textLines:1 backgroundColor:[UIColor clearColor] superView:superView];
}

@end
