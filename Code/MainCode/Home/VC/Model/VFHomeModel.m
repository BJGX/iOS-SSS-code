//
//  VFHomeModel.m
//  VFProject
//


//

#import "VFHomeModel.h"

static NSString *VFNormalizedFlagKey(NSString *value) {
    if (![value isKindOfClass:[NSString class]] || value.length == 0) {
        return @"";
    }

    NSString *normalized = [[value stringByFoldingWithOptions:NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch
                                                       locale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]] lowercaseString];
    normalized = [normalized stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (normalized.length == 0) {
        return @"";
    }

    NSMutableCharacterSet *discardSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [discardSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [discardSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];

    NSMutableString *result = [NSMutableString stringWithCapacity:normalized.length];
    for (NSUInteger index = 0; index < normalized.length; index++) {
        unichar character = [normalized characterAtIndex:index];
        if ([discardSet characterIsMember:character]) {
            continue;
        }
        [result appendFormat:@"%C", character];
    }
    return result.copy;
}

static BOOL VFFlagAliasContainsChinese(NSString *value) {
    for (NSUInteger index = 0; index < value.length; index++) {
        unichar character = [value characterAtIndex:index];
        if (character >= 0x4E00 && character <= 0x9FFF) {
            return YES;
        }
    }
    return NO;
}

static BOOL VFShouldUseContainsMatch(NSString *alias) {
    if (alias.length == 0) {
        return NO;
    }
    if (VFFlagAliasContainsChinese(alias)) {
        return alias.length >= 2;
    }
    return alias.length >= 4;
}

static NSArray<NSString *> *VFExtractFlagTokens(NSString *value) {
    if (![value isKindOfClass:[NSString class]] || value.length == 0) {
        return @[];
    }

    static NSRegularExpression *expression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expression = [NSRegularExpression regularExpressionWithPattern:@"[a-z]+|[\\u4e00-\\u9fff]+"
                                                              options:0
                                                                error:nil];
    });

    NSString *searchSource = [[value stringByFoldingWithOptions:NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch
                                                         locale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]] lowercaseString];
    NSMutableOrderedSet<NSString *> *tokens = [NSMutableOrderedSet orderedSet];
    [expression enumerateMatchesInString:searchSource
                                 options:0
                                   range:NSMakeRange(0, searchSource.length)
                              usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.range.location == NSNotFound || result.range.length == 0) {
            return;
        }
        NSString *token = VFNormalizedFlagKey([searchSource substringWithRange:result.range]);
        if (token.length > 0) {
            [tokens addObject:token];
        }
    }];
    return tokens.array;
}

static void VFAddFlagAlias(NSMutableDictionary<NSString *, NSString *> *exactAliasMap,
                           NSMutableArray<NSDictionary<NSString *, NSString *> *> *containsAliasRules,
                           NSString *alias,
                           NSString *imageName) {
    NSString *normalizedAlias = VFNormalizedFlagKey(alias);
    if (normalizedAlias.length == 0 || imageName.length == 0) {
        return;
    }

    if (exactAliasMap[normalizedAlias].length == 0) {
        exactAliasMap[normalizedAlias] = imageName;
    }

    if (!VFShouldUseContainsMatch(normalizedAlias)) {
        return;
    }

    for (NSDictionary<NSString *, NSString *> *rule in containsAliasRules) {
        if ([rule[@"alias"] isEqualToString:normalizedAlias]) {
            return;
        }
    }
    [containsAliasRules addObject:@{
        @"alias": normalizedAlias,
        @"imageName": imageName
    }];
}

@implementation VFHomeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"banner": [self class],
            @"start": [self class]
            };
}


+ (UIImage *)getFlagImage:(NSString *)name
{
    NSString *imageName = [self returnImageName:name];
    if (imageName.length == 0) {
        return nil;
    }
    return [UIImage imageNamed:imageName];
}

+ (NSString *)returnImageName:(NSString *)name
{
    NSString *normalizedName = VFNormalizedFlagKey(name);
    if (normalizedName.length == 0) {
        return nil;
    }

    static NSDictionary<NSString *, NSString *> *exactAliasMap = nil;
    static NSArray<NSDictionary<NSString *, NSString *> *> *containsAliasRules = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray<NSDictionary<NSString *, id> *> *flagItems = @[
            @{@"name": @"中国", @"image": @"pic_china", @"enableServiceAlias": @NO},
            @{@"name": @"欧洲"},
            @{@"name": @"台湾"},
            @{@"name": @"加拿大"},
            @{@"name": @"美国"},
            @{@"name": @"墨西哥"},
            @{@"name": @"澳大利亚"},
            @{@"name": @"南非"},
            @{@"name": @"阿根廷"},
            @{@"name": @"巴西"},
            @{@"name": @"哥伦比亚"},
            @{@"name": @"智利"},
            @{@"name": @"爱尔兰"},
            @{@"name": @"爱沙尼亚"},
            @{@"name": @"奥地利"},
            @{@"name": @"保加利亚"},
            @{@"name": @"比利时"},
            @{@"name": @"冰岛"},
            @{@"name": @"波兰"},
            @{@"name": @"德国"},
            @{@"name": @"俄罗斯"},
            @{@"name": @"法国"},
            @{@"name": @"荷兰"},
            @{@"name": @"捷克"},
            @{@"name": @"立陶宛"},
            @{@"name": @"罗马尼亚"},
            @{@"name": @"挪威"},
            @{@"name": @"瑞典"},
            @{@"name": @"瑞士", @"image": @"欧洲-瑞士"},
            @{@"name": @"塞尔维亚"},
            @{@"name": @"土耳其"},
            @{@"name": @"乌克兰"},
            @{@"name": @"西班牙"},
            @{@"name": @"希腊", @"image": @"欧洲-希腊"},
            @{@"name": @"意大利"},
            @{@"name": @"英国"},
            @{@"name": @"阿塞拜疆"},
            @{@"name": @"巴基斯坦"},
            @{@"name": @"菲律宾"},
            @{@"name": @"哈萨克斯坦"},
            @{@"name": @"韩国"},
            @{@"name": @"柬埔寨"},
            @{@"name": @"马来西亚"},
            @{@"name": @"孟加拉国"},
            @{@"name": @"缅甸"},
            @{@"name": @"尼泊尔"},
            @{@"name": @"日本"},
            @{@"name": @"泰国"},
            @{@"name": @"香港"},
            @{@"name": @"新加坡"},
            @{@"name": @"印度"},
            @{@"name": @"印度尼西亚"},
            @{@"name": @"越南"},
            @{@"name": @"阿联酋"},
            @{@"name": @"阿曼"},
            @{@"name": @"巴林"},
            @{@"name": @"卡塔尔"},
            @{@"name": @"沙特阿拉伯"},
            @{@"name": @"伊拉克"},
            @{@"name": @"以色列"},
            @{@"name": @"免费", @"enableServiceAlias": @NO},
            @{@"name": @"收藏", @"enableServiceAlias": @NO}
        ];

        NSDictionary<NSString *, NSArray<NSString *> *> *manualAliases = @{
            @"中国": @[@"china", @"cn", @"chn", @"中国大陆"],
            @"欧洲": @[@"eu", @"europe", @"european union", @"europeanunion", @"欧服"],
            @"台湾": @[@"tw", @"twn", @"taiwan", @"台服", @"中国台湾", @"中国台湾地区", @"台湾地区"],
            @"美国": @[@"us", @"usa", @"united states", @"united states of america", @"unitedstatesofamerica", @"america", @"美服"],
            @"英国": @[@"uk", @"gbr", @"united kingdom", @"great britain", @"greatbritain", @"britain", @"england", @"英服"],
            @"韩国": @[@"kr", @"kor", @"korea", @"south korea", @"southkorea", @"korean", @"韩服", @"韩国服"],
            @"日本": @[@"jp", @"jpn", @"japan", @"日服"],
            @"香港": @[@"hk", @"hkg", @"hong kong", @"hongkong", @"港服", @"中国香港", @"中国香港地区", @"香港地区"],
            @"新加坡": @[@"sg", @"sgp", @"singapore", @"new server", @"newserver", @"新服"],
            @"马来西亚": @[@"my", @"mys", @"malaysia", @"马来", @"马来服", @"马服"],
            @"俄罗斯": @[@"ru", @"rus", @"russia", @"俄服"],
            @"越南": @[@"vn", @"vnm", @"vietnam", @"越服"],
            @"阿联酋": @[@"ae", @"are", @"uae", @"united arab emirates", @"unitedarabemirates"],
            @"免费": @[@"free"],
            @"收藏": @[@"favorite", @"favorites", @"favourite", @"favourites"]
        };

        NSMutableDictionary<NSString *, NSString *> *mutableExactAliasMap = [NSMutableDictionary dictionary];
        NSMutableArray<NSDictionary<NSString *, NSString *> *> *mutableContainsAliasRules = [NSMutableArray array];
        NSMutableDictionary<NSString *, NSNumber *> *serviceAliasCounter = [NSMutableDictionary dictionary];
        NSBundle *englishBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]];
        NSLocale *englishLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];

        for (NSDictionary<NSString *, id> *item in flagItems) {
            NSString *displayName = item[@"name"];
            BOOL enableServiceAlias = [item[@"enableServiceAlias"] ?: @YES boolValue];
            if (!enableServiceAlias || displayName.length == 0) {
                continue;
            }
            NSString *serviceAlias = [NSString stringWithFormat:@"%@服", [displayName substringToIndex:1]];
            serviceAliasCounter[serviceAlias] = @(serviceAliasCounter[serviceAlias].integerValue + 1);
        }

        for (NSDictionary<NSString *, id> *item in flagItems) {
            NSString *displayName = item[@"name"];
            NSString *imageName = item[@"image"] ?: displayName;
            if (displayName.length == 0 || imageName.length == 0) {
                continue;
            }

            VFAddFlagAlias(mutableExactAliasMap, mutableContainsAliasRules, displayName, imageName);

            NSString *localizedCode = [englishBundle localizedStringForKey:displayName value:nil table:nil];
            if (localizedCode.length > 0 && ![localizedCode isEqualToString:displayName]) {
                VFAddFlagAlias(mutableExactAliasMap, mutableContainsAliasRules, localizedCode, imageName);

                if (localizedCode.length == 2) {
                    NSString *englishName = [englishLocale displayNameForKey:NSLocaleCountryCode value:localizedCode.uppercaseString];
                    if (englishName.length > 0) {
                        VFAddFlagAlias(mutableExactAliasMap, mutableContainsAliasRules, englishName, imageName);
                    }
                }
            }

            NSString *serviceAlias = [NSString stringWithFormat:@"%@服", [displayName substringToIndex:1]];
            BOOL allowServiceAlias = [item[@"enableServiceAlias"] ?: @YES boolValue];
            if (allowServiceAlias && serviceAliasCounter[serviceAlias].integerValue == 1) {
                VFAddFlagAlias(mutableExactAliasMap, mutableContainsAliasRules, serviceAlias, imageName);
            }

            for (NSString *alias in manualAliases[displayName]) {
                VFAddFlagAlias(mutableExactAliasMap, mutableContainsAliasRules, alias, imageName);
            }
        }

        containsAliasRules = [mutableContainsAliasRules sortedArrayUsingComparator:^NSComparisonResult(NSDictionary<NSString *,NSString *> *obj1, NSDictionary<NSString *,NSString *> *obj2) {
            NSString *alias1 = obj1[@"alias"] ?: @"";
            NSString *alias2 = obj2[@"alias"] ?: @"";
            if (alias1.length == alias2.length) {
                return [alias1 compare:alias2];
            }
            return alias1.length > alias2.length ? NSOrderedAscending : NSOrderedDescending;
        }];
        exactAliasMap = mutableExactAliasMap.copy;
    });

    NSString *imageName = exactAliasMap[normalizedName];
    if (imageName.length > 0) {
        return imageName;
    }

    for (NSString *token in VFExtractFlagTokens(name)) {
        NSString *tokenImageName = exactAliasMap[token];
        if (tokenImageName.length > 0) {
            return tokenImageName;
        }
    }

    for (NSDictionary<NSString *, NSString *> *rule in containsAliasRules) {
        NSString *alias = rule[@"alias"];
        if (alias.length > 0 && [normalizedName containsString:alias]) {
            return rule[@"imageName"];
        }
    }

    return nil;
}






@end
