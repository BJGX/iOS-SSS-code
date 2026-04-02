//
//  NSMutableAttributedString+YQString.m

//
//  Created by  on 2019/6/18.
//  Copyright © 2019年 . All rights reserved.
//

#import "NSMutableAttributedString+YQString.h"

@implementation NSMutableAttributedString (YQString)



+ (NSMutableAttributedString *)attributeLineSpace:(id)string space:(CGFloat)space {
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
    return attrStr;
}

+ (NSMutableAttributedString *)attributeColorAndFontSizeWithLabel:(id)string
                                                             font:(UIFont *)font
                                                             rang:(NSRange)rang
                                                            color:(UIColor *)color
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
    
    
    return attrStr;
}

+ (NSMutableAttributedString *)attributeColorLabel:(id)string
                                              rang:(NSRange)rang
                                             color:(UIColor *)color
{
    
    return  [self attributeColorAndFontSizeWithLabel:string font:nil rang:rang color:color];
    
}

+ (NSMutableAttributedString *)attributeFontSizeWithLabel:(id)string
                                                     font:(UIFont *)font
                                                     rang:(NSRange)rang
{
    
    return  [self attributeColorAndFontSizeWithLabel:string font:font rang:rang color:nil];
    
}

+ (NSMutableAttributedString *)attributeStringAppedImageByString:(id)string
                                                           image:(UIImage *)image
                                                      imageFrame:(CGRect)frame
{
    
    if (string == nil) {
        string = @"";
    }
    NSMutableAttributedString *attrStr;
    if ([string isKindOfClass:[NSString class]]) {
        attrStr = [[NSMutableAttributedString alloc]initWithString:string];
    }
    else {
        attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:string];
    }
    if (image) {
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = image;
        attch.bounds = frame;
        NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attch];
        [attrStr appendAttributedString:imageString];
    }
    return attrStr;
}


@end
