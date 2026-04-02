// Manager.m
#import "FCVPNManager.h"
#import <NetworkExtension/NetworkExtension.h>
#import <CommUtils/CommUtils.h>
@import MMWormhole;

NSString *const kProxyServiceVPNStatusNotification = @"kProxyServiceVPNStatusNotification";
static NSString *const kDefaultGroupIdentifier = @"defaultGroup";
static NSString *const kDefaultGroupName = @"defaultGroupName";
static NSString *const statusIdentifier = @"status";

@interface FCVPNManager ()

@property (nonatomic, strong) NETunnelProviderManager *providerManager;
@property (nonatomic, assign) BOOL observerAdded;
@property (nonatomic, strong) MMWormhole *wormhole;
@end

@implementation FCVPNManager

+ (instancetype)sharedManager {
    static FCVPNManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FCVPNManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _vpnStatus = FCVPNStatusOff;
        [self loadProviderManagerWithCompletion:^(NETunnelProviderManager * _Nullable manager) {
            if (manager) {
                [self updateVPNStatusWithManager:manager];
            }
        }];
        [self addVPNStatusObserver];
        _wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier: [AppProfile sharedGroupIdentifier] optionalDirectory:@"wormhole"];
        
        WeakSelf;
        [_wormhole listenForMessageWithIdentifier:@"listenAppActionNE" listener:^(id  _Nullable messageObject) {
            [weakSelf.wormhole passMessageObject:@{@"cmd": @"stopCore"} identifier:@"listenAppActionApp"];
        }];
        
        
    }
    return self;
}

+ (void)stopVPN{
    [[FCVPNManager sharedManager] stopVPN];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addVPNStatusObserver {
    if (self.observerAdded) return;
    
    [self loadProviderManagerWithCompletion:^(NETunnelProviderManager * _Nullable manager) {
        if (manager) {
            self.observerAdded = YES;
            [[NSNotificationCenter defaultCenter] addObserverForName:NEVPNStatusDidChangeNotification
                                                             object:manager.connection
                                                              queue:[NSOperationQueue mainQueue]
                                                         usingBlock:^(NSNotification * _Nonnull note) {
                [self updateVPNStatusWithManager:manager];
            }];
        }
    }];
}

- (void)updateVPNStatusWithManager:(NETunnelProviderManager *)manager {
    NSLog(@"manager status %ld",(long)manager.connection.status);
    switch (manager.connection.status) {
        case NEVPNStatusConnected:
            self.vpnStatus = FCVPNStatusON;
            break;
        case NEVPNStatusConnecting:
        case NEVPNStatusReasserting:
            self.vpnStatus = FCVPNStatusConnecting;
            break;
        case NEVPNStatusDisconnecting:
            self.vpnStatus = FCVPNStatusdDsconnecting;
            break;
        case NEVPNStatusDisconnected:
        case NEVPNStatusInvalid:
            self.vpnStatus = FCVPNStatusOff;
            break;
        default:
            break;
    }
}

- (void)setVpnStatus:(FCVPNStatus)vpnStatus{
    _vpnStatus = vpnStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:kProxyServiceVPNStatusNotification object:@(vpnStatus)];
}


- (void)switchVPN
{
    if (self.vpnStatus == FCVPNStatusON) {
        
        [self stopVPN];
        return;
    }
    
    [self switchVPNWithCompletion:^(NETunnelProviderManager * _Nullable manager, NSError * _Nullable error) {
        
    }];
    
    
}

- (void)switchVPNWithCompletion:(void (^_Nullable)(NETunnelProviderManager * _Nullable manager, NSError * _Nullable error))completion {
    [self loadProviderManagerWithCompletion:^(NETunnelProviderManager * _Nullable manager) {
        if (manager) {
            [self updateVPNStatusWithManager:manager];
        }
        
        FCVPNStatus current = self.vpnStatus;
        if (current == FCVPNStatusConnecting || current == FCVPNStatusdDsconnecting) {
            if (completion) completion(nil, nil);
            return;
        }
        
        if (current == FCVPNStatusOff) {
            [self startVPNWithOptions:nil completion:completion];
        } else {
            [self stopVPN];
            if (completion) completion(nil, nil);
        }
    }];
}

- (void)startVPNWithOptions:(NSDictionary<NSString *, id> *)options
                 completion:(void (^)(NETunnelProviderManager * _Nullable, NSError * _Nullable))completion {
    [self loadAndCreateProviderManagerWithCompletion:^(NETunnelProviderManager * _Nullable manager, NSError * _Nullable error) {
        if (error) {
            if (completion) completion(nil, error);
            return;
        }
        
        if (!manager) {
            if (completion) completion(nil, [NSError errorWithDomain:@"ManagerError" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Invalid provider"}]);
            return;
        }
        
        if (manager.connection.status == NEVPNStatusDisconnected || manager.connection.status == NEVPNStatusInvalid) {
            NSError *startError;
            [manager.connection startVPNTunnelWithOptions:options andReturnError:&startError];
            self.providerManager = manager;
            if (startError) {
                [[SimpleLogger sharedLogger] logWithLevel:LogLevelError category:@"NE" message:error.description];
                [YQUtils showCenterMessage:[NSString stringWithFormat:@"NE_Error: %@",error.description]];
                if (completion) completion(nil, startError);
            } else {
                [self addVPNStatusObserver];
                if (completion) completion(manager, nil);
            }
        } else {
            [self addVPNStatusObserver];
            if (completion) completion(manager, nil);
        }
    }];
}

- (void)stopVPN {
    [self.providerManager.connection stopVPNTunnel];
    [self.wormhole passMessageObject:@{@"cmd": @"stopCore"} identifier:@"stopVPNTunnel"];
    [self loadProviderManagerWithCompletion:^(NETunnelProviderManager * _Nullable manager) {
        if (manager) {
            [manager.connection stopVPNTunnel];
            
        }
    }];
}

- (void)setup {
    // Setup implementation
}

- (void)setDefaultConfigGroupWithParam:(NSDictionary *)param proxy:(BOOL)proxy {
    NSError *error;
    [self regenerateConfigFilesWithParam:param proxy:proxy error:&error];
    if (error) {
        NSLog(@"Regenerate config files error: %@", error);
    }
}

- (void)regenerateConfigFilesWithParam:(NSDictionary *)param proxy:(BOOL)proxy error:(NSError **)error {
    [self generateGeneralConfigWithError:error];
    if (*error) return;
    
    [self generateSocksConfigWithError:error];
    if (*error) return;
    
    [self generateShadowsocksConfigWithParam:param error:error];
    if (*error) return;
    
    [self generateHttpProxyConfigWithProxy:proxy error:error];
    
    [[AppProfile sharedUserDefaults] setBool:proxy forKey:@"VPNPAC"];
    
}

#pragma mark - Config Generation

- (void)generateGeneralConfigWithError:(NSError **)error {
    NSURL *confURL = [self generalConfURL];
    NSDictionary *json = @{};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:error];
    if (*error) return;
    
    [jsonData writeToURL:confURL options:NSDataWritingAtomic error:error];
}

- (void)generateSocksConfigWithError:(NSError **)error {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"socks" ofType:@"txt"];
    NSString *socksConf = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:error];
    if (*error) return;
    
    [socksConf writeToURL:[self socksConfURL] atomically:YES encoding:NSUTF8StringEncoding error:error];
}

- (void)generateShadowsocksConfigWithParam:(NSDictionary *)param error:(NSError **)error {
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:error];
    if (*error) return;
    
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [content writeToURL:[self proxyConfURL] atomically:YES encoding:NSUTF8StringEncoding error:error];
}

- (void)generateHttpProxyConfigWithProxy:(BOOL)proxy error:(NSError **)error {
    NSURL *confDirURL = [[self appSharedURL] URLByAppendingPathComponent:@"httpconf"];
    NSString *templateDirPath = [[[self appSharedURL] URLByAppendingPathComponent:@"httptemplate"] path];
    NSString *temporaryDirPath = [[[self appSharedURL] URLByAppendingPathComponent:@"httptemporary"] path];
    NSString *logDir = [[[self appSharedURL] URLByAppendingPathComponent:@"log"] path];
    NSString *maxminddbPath = [[[self appSharedURL] URLByAppendingPathComponent:@"GeoLite2-Country.mmdb"] path];
    NSURL *userActionURL = [confDirURL URLByAppendingPathComponent:@"potatso.action"];
    
    // Create directories
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *path in @[confDirURL.path, templateDirPath, temporaryDirPath, logDir]) {
        if (![fm fileExistsAtPath:path]) {
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
            if (*error) return;
        }
    }
    
    // Load main config template
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"proxy" ofType:@"plist"];
    NSMutableDictionary *mainConf = [NSMutableDictionary dictionary];
//    if (!mainConf) {
//        *error = [NSError errorWithDomain:@"ConfigError" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Failed to load proxy.plist"}];
//        return;
//    }
    
    mainConf[@"confdir"] = confDirURL.path;
    mainConf[@"templdir"] = templateDirPath;
    mainConf[@"logdir"] = logDir;
    mainConf[@"mmdbpath"] = maxminddbPath;
    mainConf[@"global-mode"] = @(proxy);
    mainConf[@"debug"] = @(1024+65536+1);
    mainConf[@"actionsfile"] = userActionURL.path;
    
    // Write main config
    NSMutableString *mainContent = [NSMutableString string];
    for (NSString *key in mainConf.allKeys) {
        [mainContent appendFormat:@"%@ %@\n", key, mainConf[key]];
    }
    [mainContent writeToURL:[self httpProxyConfURL] atomically:YES encoding:NSUTF8StringEncoding error:error];
    if (*error) return;
    
    // Write user action
    NSString *actionPath = [[NSBundle mainBundle] pathForResource:@"userActionString" ofType:@"txt"];
    NSString *userActionString = [NSString stringWithContentsOfFile:actionPath encoding:NSUTF8StringEncoding error:error];
    if (*error) return;
    
    userActionString = [userActionString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [userActionString writeToFile:userActionURL.path atomically:YES encoding:NSUTF8StringEncoding error:error];
}

#pragma mark - Provider Management


- (void)removeManager {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {

        NETunnelProviderManager *manager = managers.firstObject;
        
        BOOL remove = [[NSUserDefaults standardUserDefaults] boolForKey:@"RemoveManager"];
        
        if (remove == NO && manager) {
            [manager removeFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RemoveManager"];
            }];
        }
        else if (manager == nil) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RemoveManager"];
        }
    }];
}

- (void)loadAndCreateProviderManagerWithCompletion:(void (^)(NETunnelProviderManager * _Nullable, NSError * _Nullable))completion {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NETunnelProviderManager *manager = managers.firstObject;
        
        if (!manager) {
            manager = [[NETunnelProviderManager alloc] init];
            NETunnelProviderProtocol *protocol = [[NETunnelProviderProtocol alloc] init];
            manager.protocolConfiguration = protocol;
        }
        
        manager.enabled = YES;
        manager.localizedDescription = @"SSS VPN";
        manager.protocolConfiguration.serverAddress = @"SSS VPN";
        manager.onDemandEnabled = YES;
        
        NEEvaluateConnectionRule *rule = [[NEEvaluateConnectionRule alloc] initWithMatchDomains:@[@"connect.potatso.com"]
                                                                                  andAction:NEEvaluateConnectionRuleActionConnectIfNeeded];
        NEOnDemandRuleEvaluateConnection *quickRule = [[NEOnDemandRuleEvaluateConnection alloc] init];
        quickRule.connectionRules = @[rule];
        manager.onDemandRules = @[quickRule];
        
        [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable saveError) {
            if (saveError) {
                completion(nil, saveError);
            } else {
                [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable loadError) {
                    completion(loadError ? nil : manager, loadError);
                }];
            }
        }];
    }];
}

- (void)loadProviderManagerWithCompletion:(void (^)(NETunnelProviderManager * _Nullable))completion {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        completion(managers.firstObject);
    }];
}

#pragma mark - File Paths

- (NSURL *)appSharedURL {
//    return [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.example.app"];]
    
    return [AppProfile sharedUrl];
}

- (NSURL *)generalConfURL {
//    return [[self appSharedURL] URLByAppendingPathComponent:@"general.xxx"];
    return  [AppProfile sharedGeneralConfUrl];
}

- (NSURL *)socksConfURL {
    return [AppProfile sharedSocksConfUrl];
}

- (NSURL *)proxyConfURL {
    return [AppProfile sharedProxyConfUrl];
}

- (NSURL *)httpProxyConfURL {
    return [AppProfile sharedHttpProxyConfUrl];
}

@end
