//
//  NPLanguageTool.h
//  NewsProject
//
//  Created by  on 2025/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LanguageTypeEnglish,
    LanguageTypeChinese,
} LanguageType;

@interface NPLanguageTool : NSObject

+ (NPLanguageTool*)shared;
- (NSString *)string:(NSString *)key;
- (void)initUserLanguage;
- (void)setLanguage:(LanguageType)type;
- (NSString *)current;
- (BOOL)isEnglishLanguage;
- (NSString *)currencySymbol;


@property (nonatomic, assign) LanguageType languageType;

@end


@interface NSString (LanguageType)



- (NSString *)localized;


@end

NS_ASSUME_NONNULL_END
