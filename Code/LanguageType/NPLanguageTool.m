//
//  NPLanguageTool.m
//  NewsProject
//
//  Created by  on 2025/3/12.
//

#import "NPLanguageTool.h"

#define UserLanguage @"UserLanguage"
#define AppleLanguages @"AppleLanguages"


@implementation NSString (LanguageType)

- (NSString *)localized {
    NSString *str = [[NPLanguageTool shared] string:self];
    return str;
}

@end


@interface NPLanguageTool()

@property (nonatomic, strong) NSBundle *bundle;

@end


@implementation NPLanguageTool



+ (NPLanguageTool*)shared{
    static dispatch_once_t pred;
    static NPLanguageTool *instance;
    dispatch_once(&pred, ^{
        instance = [[NPLanguageTool alloc] init];
    });
    return instance;
}

- (NSString *)string:(NSString *)key
{
    NSString *str = [self.bundle localizedStringForKey:key value:nil table:nil];
    return str ?: key;
}


- (void)initUserLanguage
{
    NSString *str = [YQCache getDataFromPlist:UserLanguage];
    if (str == nil) {
//        NSArray *languages = [YQCache getDataFromPlist:AppleLanguages];
//        if (languages.count != 0) {
//            NSString *current = languages.firstObject;
//            if (current != nil) {
//                str = current;
//                [YQCache saveDataToPlist:current key:UserLanguage];
//            }
//        }
        self.languageType = LanguageTypeEnglish;
        str = @"en";
    }
    else {
        self.languageType = [str isEqualToString:@"zh-Hans"] ? LanguageTypeChinese : LanguageTypeEnglish;
    }
    
    str = [str stringByReplacingOccurrencesOfString:@"-CN" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-US" withString:@""];
    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"lproj"];
    if (path == nil) {
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
    [MJRefreshConfig defaultConfig].languageCode = self.languageType == LanguageTypeEnglish ? @"en" : @"zh-Hans";
    self.bundle = [NSBundle bundleWithPath:path];
}


- (void)setLanguage:(LanguageType)type
{
    _languageType = type;
    NSString *str = @"en";
    if (type == LanguageTypeChinese) {
        str = @"zh-Hans";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
    [YQCache saveDataToPlist:str key:UserLanguage];
    [MJRefreshConfig defaultConfig].languageCode = str;
    
    
}


- (NSString *)current
{
    return self.languageType == LanguageTypeChinese ? @"cn":@"en";
}

- (BOOL)isEnglishLanguage
{
    return self.languageType == LanguageTypeEnglish;
}

- (NSString *)currencySymbol
{
    return [self isEnglishLanguage] ? @"$" : @"￥";
}




@end
