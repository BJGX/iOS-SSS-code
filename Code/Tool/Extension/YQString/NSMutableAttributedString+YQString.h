//
//  NSMutableAttributedString+YQString.h

//
//  Created by  on 2019/6/18.
//  Copyright © 2019年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (YQString)

+ (NSMutableAttributedString *)attributeLineSpace:(id)string
                                            space:(CGFloat)space;

+ (NSMutableAttributedString *)attributeColorAndFontSizeWithLabel:(id)string
                                                             font:(UIFont *)font
                                                             rang:(NSRange)rang
                                                            color:(UIColor *)color;

+ (NSMutableAttributedString *)attributeColorLabel:(id)string
                                              rang:(NSRange)rang
                                             color:(UIColor *)color;

+ (NSMutableAttributedString *)attributeFontSizeWithLabel:(id)string
                                                     font:(UIFont *)font
                                                     rang:(NSRange)rang;


+ (NSMutableAttributedString *)attributeStringAppedImageByString: (id)string
                                                           image: (UIImage *)image
                                                      imageFrame: (CGRect)frame;


@end
