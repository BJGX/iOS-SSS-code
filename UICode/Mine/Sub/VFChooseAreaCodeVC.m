//
//  VFChooseAreaCodeVC.m
//  SSSVPN
//
//  Created by yuanqiu on 2025/10/15.
//

#import "VFChooseAreaCodeVC.h"

static NSString *VFRegionCodeFromFlagEmoji(NSString *flagEmoji) {
    if (flagEmoji.length != 4) {
        return nil;
    }
    UTF32Char first = CFStringGetLongCharacterForSurrogatePair([flagEmoji characterAtIndex:0], [flagEmoji characterAtIndex:1]);
    UTF32Char second = CFStringGetLongCharacterForSurrogatePair([flagEmoji characterAtIndex:2], [flagEmoji characterAtIndex:3]);
    if (first < 0x1F1E6 || first > 0x1F1FF || second < 0x1F1E6 || second > 0x1F1FF) {
        return nil;
    }
    return [NSString stringWithFormat:@"%c%c",
            'A' + (char)(first - 0x1F1E6),
            'A' + (char)(second - 0x1F1E6)];
}

@interface CountryCodeModel : NSObject

@property (nonatomic, copy) NSString *name;    // 国家/地区名称
@property (nonatomic, copy) NSString *code;    // 区号
@property (nonatomic, copy) NSString *emoji;   // 国旗emoji

@end

@implementation CountryCodeModel


@end

@interface VFChooseAreaCodeVC ()
@property (nonatomic, strong) NSMutableArray *allCountryCodes;
@end

@implementation VFChooseAreaCodeVC

+ (NSArray<NSDictionary *> *)countryCodeItems
{
    static NSArray<NSDictionary *> *array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = @[
            @{@"name":@"中国", @"code":@"+86", @"emoji":@"🇨🇳"},
            @{@"name":@"中国香港地区", @"code":@"+852", @"emoji":@"🇭🇰"},
            @{@"name":@"中国澳门地区", @"code":@"+853", @"emoji":@"🇲🇴"},
            @{@"name":@"中国台湾地区", @"code":@"+886", @"emoji":@"🇨🇳"},
            @{@"name":@"美国", @"code":@"+1", @"emoji":@"🇺🇸"},
            @{@"name":@"加拿大", @"code":@"+1", @"emoji":@"🇨🇦"},
            @{@"name":@"英国", @"code":@"+44", @"emoji":@"🇬🇧"},
            @{@"name":@"法国", @"code":@"+33", @"emoji":@"🇫🇷"},
            @{@"name":@"德国", @"code":@"+49", @"emoji":@"🇩🇪"},
            @{@"name":@"日本", @"code":@"+81", @"emoji":@"🇯🇵"},
            @{@"name":@"韩国", @"code":@"+82", @"emoji":@"🇰🇷"},
            @{@"name":@"印度", @"code":@"+91", @"emoji":@"🇮🇳"},
            @{@"name":@"澳大利亚", @"code":@"+61", @"emoji":@"🇦🇺"},
            @{@"name":@"巴西", @"code":@"+55", @"emoji":@"🇧🇷"},
            @{@"name":@"俄罗斯", @"code":@"+7", @"emoji":@"🇷🇺"},
            @{@"name":@"意大利", @"code":@"+39", @"emoji":@"🇮🇹"},
            @{@"name":@"西班牙", @"code":@"+34", @"emoji":@"🇪🇸"},
            @{@"name":@"墨西哥", @"code":@"+52", @"emoji":@"🇲🇽"},
            @{@"name":@"印度尼西亚", @"code":@"+62", @"emoji":@"🇮🇩"},
            @{@"name":@"巴基斯坦", @"code":@"+92", @"emoji":@"🇵🇰"},
            @{@"name":@"尼日利亚", @"code":@"+234", @"emoji":@"🇳🇬"},
            @{@"name":@"孟加拉国", @"code":@"+880", @"emoji":@"🇧🇩"},
            @{@"name":@"菲律宾", @"code":@"+63", @"emoji":@"🇵🇭"},
            @{@"name":@"埃及", @"code":@"+20", @"emoji":@"🇪🇬"},
            @{@"name":@"越南", @"code":@"+84", @"emoji":@"🇻🇳"},
            @{@"name":@"伊朗", @"code":@"+98", @"emoji":@"🇮🇷"},
            @{@"name":@"土耳其", @"code":@"+90", @"emoji":@"🇹🇷"},
            @{@"name":@"泰国", @"code":@"+66", @"emoji":@"🇹🇭"},
            @{@"name":@"南非", @"code":@"+27", @"emoji":@"🇿🇦"},
            @{@"name":@"阿根廷", @"code":@"+54", @"emoji":@"🇦🇷"},
            @{@"name":@"哥伦比亚", @"code":@"+57", @"emoji":@"🇨🇴"},
            @{@"name":@"肯尼亚", @"code":@"+254", @"emoji":@"🇰🇪"},
            @{@"name":@"缅甸", @"code":@"+95", @"emoji":@"🇲🇲"},
            @{@"name":@"埃塞俄比亚", @"code":@"+251", @"emoji":@"🇪🇹"},
            @{@"name":@"尼泊尔", @"code":@"+977", @"emoji":@"🇳🇵"},
            @{@"name":@"瑞士", @"code":@"+41", @"emoji":@"🇨🇭"},
            @{@"name":@"奥地利", @"code":@"+43", @"emoji":@"🇦🇹"},
            @{@"name":@"比利时", @"code":@"+32", @"emoji":@"🇧🇪"},
            @{@"name":@"荷兰", @"code":@"+31", @"emoji":@"🇳🇱"},
            @{@"name":@"瑞典", @"code":@"+46", @"emoji":@"🇸🇪"},
            @{@"name":@"挪威", @"code":@"+47", @"emoji":@"🇳🇴"},
            @{@"name":@"丹麦", @"code":@"+45", @"emoji":@"🇩🇰"},
            @{@"name":@"芬兰", @"code":@"+358", @"emoji":@"🇫🇮"},
            @{@"name":@"波兰", @"code":@"+48", @"emoji":@"🇵🇱"},
            @{@"name":@"乌克兰", @"code":@"+380", @"emoji":@"🇺🇦"},
            @{@"name":@"罗马尼亚", @"code":@"+40", @"emoji":@"🇷🇴"},
            @{@"name":@"希腊", @"code":@"+30", @"emoji":@"🇬🇷"},
            @{@"name":@"葡萄牙", @"code":@"+351", @"emoji":@"🇵🇹"},
            @{@"name":@"马来西亚", @"code":@"+60", @"emoji":@"🇲🇾"},
            @{@"name":@"新加坡", @"code":@"+65", @"emoji":@"🇸🇬"},
            @{@"name":@"新西兰", @"code":@"+64", @"emoji":@"🇳🇿"},
            @{@"name":@"沙特阿拉伯", @"code":@"+966", @"emoji":@"🇸🇦"},
            @{@"name":@"阿联酋", @"code":@"+971", @"emoji":@"🇦🇪"},
            @{@"name":@"以色列", @"code":@"+972", @"emoji":@"🇮🇱"},
            @{@"name":@"科威特", @"code":@"+965", @"emoji":@"🇰🇼"},
            @{@"name":@"卡塔尔", @"code":@"+974", @"emoji":@"🇶🇦"},
            @{@"name":@"阿曼", @"code":@"+968", @"emoji":@"🇴🇲"},
            @{@"name":@"巴林", @"code":@"+973", @"emoji":@"🇧🇭"},
            @{@"name":@"黎巴嫩", @"code":@"+961", @"emoji":@"🇱🇧"},
            @{@"name":@"约旦", @"code":@"+962", @"emoji":@"🇯🇴"},
            @{@"name":@"伊拉克", @"code":@"+964", @"emoji":@"🇮🇶"},
            @{@"name":@"叙利亚", @"code":@"+963", @"emoji":@"🇸🇾"},
            @{@"name":@"也门", @"code":@"+967", @"emoji":@"🇾🇪"},
            @{@"name":@"斯里兰卡", @"code":@"+94", @"emoji":@"🇱🇰"},
            @{@"name":@"马尔代夫", @"code":@"+960", @"emoji":@"🇲🇻"},
            @{@"name":@"不丹", @"code":@"+975", @"emoji":@"🇧🇹"},
            @{@"name":@"蒙古", @"code":@"+976", @"emoji":@"🇲🇳"},
            @{@"name":@"哈萨克斯坦", @"code":@"+997", @"emoji":@"🇰🇿"},
            @{@"name":@"乌兹别克斯坦", @"code":@"+998", @"emoji":@"🇺🇿"},
            @{@"name":@"土库曼斯坦", @"code":@"+993", @"emoji":@"🇹🇲"},
            @{@"name":@"吉尔吉斯斯坦", @"code":@"+996", @"emoji":@"🇰🇬"},
            @{@"name":@"塔吉克斯坦", @"code":@"+992", @"emoji":@"🇹🇯"},
            @{@"name":@"阿塞拜疆", @"code":@"+994", @"emoji":@"🇦🇿"},
            @{@"name":@"格鲁吉亚", @"code":@"+995", @"emoji":@"🇬🇪"},
            @{@"name":@"亚美尼亚", @"code":@"+374", @"emoji":@"🇦🇲"},
            @{@"name":@"摩尔多瓦", @"code":@"+373", @"emoji":@"🇲🇩"},
            @{@"name":@"白俄罗斯", @"code":@"+375", @"emoji":@"🇧🇾"},
            @{@"name":@"立陶宛", @"code":@"+370", @"emoji":@"🇱🇹"},
            @{@"name":@"拉脱维亚", @"code":@"+371", @"emoji":@"🇱🇻"},
            @{@"name":@"爱沙尼亚", @"code":@"+372", @"emoji":@"🇪🇪"},
            @{@"name":@"捷克", @"code":@"+420", @"emoji":@"🇨🇿"},
            @{@"name":@"斯洛伐克", @"code":@"+421", @"emoji":@"🇸🇰"},
            @{@"name":@"匈牙利", @"code":@"+36", @"emoji":@"🇭🇺"},
            @{@"name":@"斯洛文尼亚", @"code":@"+386", @"emoji":@"🇸🇮"},
            @{@"name":@"克罗地亚", @"code":@"+385", @"emoji":@"🇭🇷"},
            @{@"name":@"波黑", @"code":@"+387", @"emoji":@"🇧🇦"},
            @{@"name":@"塞尔维亚", @"code":@"+381", @"emoji":@"🇷🇸"},
            @{@"name":@"黑山", @"code":@"+382", @"emoji":@"🇲🇪"},
            @{@"name":@"北马其顿", @"code":@"+389", @"emoji":@"🇲🇰"},
            @{@"name":@"阿尔巴尼亚", @"code":@"+355", @"emoji":@"🇦🇱"},
            @{@"name":@"保加利亚", @"code":@"+359", @"emoji":@"🇧🇬"},
            @{@"name":@"阿尔及利亚", @"code":@"+213", @"emoji":@"🇩🇿"},
            @{@"name":@"摩洛哥", @"code":@"+212", @"emoji":@"🇲🇦"},
            @{@"name":@"突尼斯", @"code":@"+216", @"emoji":@"🇹🇳"},
            @{@"name":@"利比亚", @"code":@"+218", @"emoji":@"🇱🇾"},
            @{@"name":@"苏丹", @"code":@"+249", @"emoji":@"🇸🇩"},
            @{@"name":@"南苏丹", @"code":@"+211", @"emoji":@"🇸🇸"},
            @{@"name":@"索马里", @"code":@"+252", @"emoji":@"🇸🇴"},
            @{@"name":@"吉布提", @"code":@"+253", @"emoji":@"🇩🇯"},
            @{@"name":@"厄立特里亚", @"code":@"+291", @"emoji":@"🇪🇷"},
            @{@"name":@"坦桑尼亚", @"code":@"+255", @"emoji":@"🇹🇿"},
            @{@"name":@"乌干达", @"code":@"+256", @"emoji":@"🇺🇬"},
            @{@"name":@"卢旺达", @"code":@"+250", @"emoji":@"🇷🇼"},
            @{@"name":@"布隆迪", @"code":@"+257", @"emoji":@"🇧🇮"},
            @{@"name":@"刚果（金）", @"code":@"+243", @"emoji":@"🇨🇩"},
            @{@"name":@"刚果（布）", @"code":@"+242", @"emoji":@"🇨🇬"},
            @{@"name":@"喀麦隆", @"code":@"+237", @"emoji":@"🇨🇲"},
            @{@"name":@"加蓬", @"code":@"+241", @"emoji":@"🇬🇦"},
            @{@"name":@"赤道几内亚", @"code":@"+240", @"emoji":@"🇬🇶"},
            @{@"name":@"圣多美和普林西比", @"code":@"+239", @"emoji":@"🇸🇹"},
            @{@"name":@"贝宁", @"code":@"+229", @"emoji":@"🇧🇯"},
            @{@"name":@"多哥", @"code":@"+228", @"emoji":@"🇹🇬"},
            @{@"name":@"加纳", @"code":@"+233", @"emoji":@"🇬🇭"},
            @{@"name":@"科特迪瓦", @"code":@"+225", @"emoji":@"🇨🇮"},
            @{@"name":@"利比里亚", @"code":@"+231", @"emoji":@"🇱🇷"},
            @{@"name":@"塞拉利昂", @"code":@"+232", @"emoji":@"🇸🇱"},
            @{@"name":@"几内亚", @"code":@"+224", @"emoji":@"🇬🇳"},
            @{@"name":@"几内亚比绍", @"code":@"+245", @"emoji":@"🇬🇼"},
            @{@"name":@"塞内加尔", @"code":@"+221", @"emoji":@"🇸🇳"},
            @{@"name":@"冈比亚", @"code":@"+220", @"emoji":@"🇬🇲"},
            @{@"name":@"毛里塔尼亚", @"code":@"+222", @"emoji":@"🇲🇷"},
            @{@"name":@"马里", @"code":@"+223", @"emoji":@"🇲🇱"},
            @{@"name":@"布基纳法索", @"code":@"+226", @"emoji":@"🇧🇫"},
            @{@"name":@"尼日尔", @"code":@"+227", @"emoji":@"🇳🇪"},
            @{@"name":@"乍得", @"code":@"+235", @"emoji":@"🇹🇩"},
            @{@"name":@"中非", @"code":@"+236", @"emoji":@"🇨🇫"},
            @{@"name":@"马达加斯加", @"code":@"+261", @"emoji":@"🇲🇬"},
            @{@"name":@"马拉维", @"code":@"+265", @"emoji":@"🇲🇼"},
            @{@"name":@"莫桑比克", @"code":@"+258", @"emoji":@"🇲🇿"},
            @{@"name":@"赞比亚", @"code":@"+260", @"emoji":@"🇿🇲"},
            @{@"name":@"津巴布韦", @"code":@"+263", @"emoji":@"🇿🇼"},
            @{@"name":@"博茨瓦纳", @"code":@"+267", @"emoji":@"🇧🇼"},
            @{@"name":@"纳米比亚", @"code":@"+264", @"emoji":@"🇳🇦"},
            @{@"name":@"莱索托", @"code":@"+266", @"emoji":@"🇱🇸"},
            @{@"name":@"斯威士兰", @"code":@"+268", @"emoji":@"🇸🇿"},
            @{@"name":@"毛里求斯", @"code":@"+230", @"emoji":@"🇲🇺"},
            @{@"name":@"塞舌尔", @"code":@"+248", @"emoji":@"🇸🇨"},
            @{@"name":@"科摩罗", @"code":@"+269", @"emoji":@"🇰🇲"},
            @{@"name":@"巴布亚新几内亚", @"code":@"+675", @"emoji":@"🇵🇬"},
            @{@"name":@"所罗门群岛", @"code":@"+677", @"emoji":@"🇸🇧"},
            @{@"name":@"瓦努阿图", @"code":@"+678", @"emoji":@"🇻🇺"},
            @{@"name":@"斐济", @"code":@"+679", @"emoji":@"🇫🇯"},
            @{@"name":@"汤加", @"code":@"+676", @"emoji":@"🇹🇴"},
            @{@"name":@"萨摩亚", @"code":@"+685", @"emoji":@"🇼🇸"},
            @{@"name":@"库克群岛", @"code":@"+682", @"emoji":@"🇨🇰"},
            @{@"name":@"纽埃", @"code":@"+683", @"emoji":@"🇳🇺"},
            @{@"name":@"托克劳", @"code":@"+690", @"emoji":@"🇹🇰"},
            @{@"name":@"法属波利尼西亚", @"code":@"+689", @"emoji":@"🇵🇫"},
            @{@"name":@"新喀里多尼亚", @"code":@"+687", @"emoji":@"🇳🇨"},
            @{@"name":@"瓦利斯和富图纳", @"code":@"+681", @"emoji":@"🇼🇫"},
            @{@"name":@"皮特凯恩群岛", @"code":@"+64", @"emoji":@"🇵🇳"},
            @{@"name":@"马绍尔群岛", @"code":@"+692", @"emoji":@"🇲🇭"},
            @{@"name":@"密克罗尼西亚", @"code":@"+691", @"emoji":@"🇫🇲"},
            @{@"name":@"帕劳", @"code":@"+680", @"emoji":@"🇵🇼"},
            @{@"name":@"瑙鲁", @"code":@"+674", @"emoji":@"🇳🇷"},
            @{@"name":@"基里巴斯", @"code":@"+686", @"emoji":@"🇰🇮"},
            @{@"name":@"图瓦卢", @"code":@"+688", @"emoji":@"🇹🇻"},
            @{@"name":@"危地马拉", @"code":@"+502", @"emoji":@"🇬🇹"},
            @{@"name":@"伯利兹", @"code":@"+501", @"emoji":@"🇧🇿"},
            @{@"name":@"萨尔瓦多", @"code":@"+503", @"emoji":@"🇸🇻"},
            @{@"name":@"洪都拉斯", @"code":@"+504", @"emoji":@"🇭🇳"},
            @{@"name":@"尼加拉瓜", @"code":@"+505", @"emoji":@"🇳🇮"},
            @{@"name":@"哥斯达黎加", @"code":@"+506", @"emoji":@"🇨🇷"},
            @{@"name":@"巴拿马", @"code":@"+507", @"emoji":@"🇵🇦"},
            @{@"name":@"古巴", @"code":@"+53", @"emoji":@"🇨🇺"},
            @{@"name":@"海地", @"code":@"+509", @"emoji":@"🇭🇹"},
            @{@"name":@"多米尼加", @"code":@"+1", @"emoji":@"🇩🇴"},
            @{@"name":@"牙买加", @"code":@"+1", @"emoji":@"🇯🇲"},
            @{@"name":@"Trinidad and Tobago", @"code":@"+1", @"emoji":@"🇹🇹"},
            @{@"name":@"巴巴多斯", @"code":@"+1", @"emoji":@"🇧🇧"},
            @{@"name":@"格林纳达", @"code":@"+1", @"emoji":@"🇬🇩"},
            @{@"name":@"圣卢西亚", @"code":@"+1", @"emoji":@"🇱🇨"},
            @{@"name":@"圣文森特和格林纳丁斯", @"code":@"+1", @"emoji":@"🇻🇨"},
            @{@"name":@"安提瓜和巴布达", @"code":@"+1", @"emoji":@"🇦🇬"},
            @{@"name":@"多米尼克", @"code":@"+1", @"emoji":@"🇩🇲"},
            @{@"name":@"圣基茨和尼维斯", @"code":@"+1", @"emoji":@"🇰🇳"},
            @{@"name":@"巴哈马", @"code":@"+1", @"emoji":@"🇧🇸"},
            @{@"name":@"特克斯和凯科斯群岛", @"code":@"+1", @"emoji":@"🇹🇨"},
            @{@"name":@"开曼群岛", @"code":@"+1", @"emoji":@"🇰🇾"},
            @{@"name":@"百慕大", @"code":@"+1", @"emoji":@"🇧🇲"},
            @{@"name":@"波多黎各", @"code":@"+1", @"emoji":@"🇵🇷"},
            @{@"name":@"美属维尔京群岛", @"code":@"+1", @"emoji":@"🇻🇮"},
            @{@"name":@"英属维尔京群岛", @"code":@"+1", @"emoji":@"🇻🇬"},
            @{@"name":@"安圭拉", @"code":@"+1", @"emoji":@"🇦🇮"},
            @{@"name":@"蒙特塞拉特", @"code":@"+1", @"emoji":@"🇲🇸"},
            @{@"name":@"瓜德罗普", @"code":@"+590", @"emoji":@"🇬🇵"},
            @{@"name":@"马提尼克", @"code":@"+596", @"emoji":@"🇲🇶"},
            @{@"name":@"法属圭亚那", @"code":@"+594", @"emoji":@"🇬🇫"},
            @{@"name":@"苏里南", @"code":@"+597", @"emoji":@"🇸🇷"},
            @{@"name":@"圭亚那", @"code":@"+592", @"emoji":@"🇬🇾"},
            @{@"name":@"委内瑞拉", @"code":@"+58", @"emoji":@"🇻🇪"},
            @{@"name":@"厄瓜多尔", @"code":@"+593", @"emoji":@"🇪🇨"},
            @{@"name":@"秘鲁", @"code":@"+51", @"emoji":@"🇵🇪"},
            @{@"name":@"玻利维亚", @"code":@"+591", @"emoji":@"🇧🇴"},
            @{@"name":@"智利", @"code":@"+56", @"emoji":@"🇨🇱"},
            @{@"name":@"乌拉圭", @"code":@"+598", @"emoji":@"🇺🇾"},
            @{@"name":@"巴拉圭", @"code":@"+595", @"emoji":@"🇵🇾"},
            @{@"name":@"福克兰群岛", @"code":@"+500", @"emoji":@"🇫🇰"},
            @{@"name":@"法属南半球和南极领地", @"code":@"+685", @"emoji":@"🇹🇦"},
            @{@"name":@"南极洲", @"code":@"+672", @"emoji":@"🇦🇶"}
        ];
    });
    return array;
}

+ (NSDictionary<NSString *,NSString *> *)dialCodeMapByRegionCode
{
    static NSDictionary<NSString *, NSString *> *dialCodeMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary<NSString *, NSString *> *regionOverrides = @{
            @"中国台湾地区": @"TW"
        };
        NSMutableDictionary<NSString *, NSString *> *map = [NSMutableDictionary dictionary];
        for (NSDictionary *item in [self countryCodeItems]) {
            NSString *regionCode = [regionOverrides[item[@"name"]] uppercaseString];
            if (regionCode.length == 0) {
                regionCode = [item[@"region"] uppercaseString];
            }
            if (regionCode.length == 0) {
                regionCode = VFRegionCodeFromFlagEmoji(item[@"emoji"]);
            }
            NSString *dialCode = item[@"code"];
            if (regionCode.length > 0 && dialCode.length > 0) {
                map[regionCode] = dialCode;
            }
        }
        dialCodeMap = [map copy];
    });
    return dialCodeMap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CodeCell"];
    [self.tableView reloadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor subBackgroundColor];
    
    
    
    UIView *view = [UIView viewWithFrame:CGRectMake(70, 0, ScreenWidth - 140, 40) backgroundColor:[UIColor subBackgroundColor] superView:self.navigationBar];
    view.cornerRadius = 8;
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 180, 40)];
    searchText.placeholder = @"搜索国家/地区或区号".localized;
    searchText.textColor = [UIColor mainTextColor];
    searchText.font = Font(14);
    WeakSelf;
    [searchText yq_addTextFieldChangedAction:^(UITextField * _Nullable textField) {
        [weakSelf reloadArray:textField.text];
    }];
//    searchText.returnKeyType = returnKeyType
    
    
    // Do any additional setup after loading the view.
}


- (void)getData
{
    NSArray *array = [VFChooseAreaCodeVC countryCodeItems];
    
    self.allCountryCodes = [NSMutableArray array];
    for (NSDictionary *obj in array) {
        CountryCodeModel *model = [CountryCodeModel mj_objectWithKeyValues:obj];
        [self.allCountryCodes addObject:model];
    }
    
    
    self.dataArray = [self.allCountryCodes mutableCopy];
    
    
    
}


- (void)reloadArray:(NSString *)searchText
{
    if (searchText.length == 0) {
        // 如果搜索文本为空，显示所有数据
        self.dataArray = [self.allCountryCodes mutableCopy];
    } else {
        // 过滤数据：匹配国家名称或区号
        [self.dataArray removeAllObjects];
        for (CountryCodeModel *model in self.allCountryCodes) {
            BOOL nameMatches = [model.name.lowercaseString containsString:searchText.lowercaseString];
            BOOL codeMatches = [model.code containsString:searchText];
            
            if (nameMatches || codeMatches) {
                [self.dataArray addObject:model];
            }
        }
    }
    
    // 刷新表格
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CodeCell" forIndexPath:indexPath];
    CountryCodeModel *model = self.dataArray[indexPath.row];
    
    // 设置单元格内容：国旗 + 国家名称 + 区号
    cell.textLabel.text = [NSString stringWithFormat:@"  %@ %@  %@", model.emoji, model.name, model.code];
    cell.textLabel.textColor = [UIColor mainTextColor];
    cell.textLabel.font = Font(15);
//    cell.detailTextLabel.text = model.code;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CountryCodeModel *model = self.dataArray[indexPath.row];
    if (self.chooseBlock) {
        self.chooseBlock(model.code);
    }
    [self.navigationController popViewControllerAnimated:YES];
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
