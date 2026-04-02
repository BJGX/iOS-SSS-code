

#import "YQUtils.h"
//#import "VFProject-Swift.h"

@implementation YQUtils


//+ (NSString *)getCharString:(NSArray<NSNumber *> *)array
//{
////    return [[VPNHelper shared] chaStringWithUcharArr:array];
//}

+ (UIWindow *)getKeyWindow{
    
    
    if (@available(iOS 13.0, *)) {
        UIWindow *originalKeyWindow = nil;
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        originalKeyWindow = window;
                        break;
                    }
                }
            }
        }
        
        if (originalKeyWindow) {
            return originalKeyWindow;
        }
        
        return  [UIApplication sharedApplication].windows.firstObject;
    }
    
    return  [[UIApplication sharedApplication] keyWindow];
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    
    NSString *messageText = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];

    NSData *jsonData = [messageText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:kNilOptions
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+ (void)createNewContentView:(UIView *)view
{
    
    CGRect bounds = view.bounds;
    
    view.backgroundColor = [UIColor clearColor];
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = bounds;
    [view.layer addSublayer:layer];
    
    
    
    
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    
    CGFloat normalR = 8;
    CGFloat topSpace = is_iPhone5 ? 28 : 33;
    CGFloat bigR = is_iPhone5 ? 25 : 30;
    
    
    const CGFloat topRightCenterX = maxX - bigR;
    const CGFloat topRightCenterY = minY + bigR;
    
    const CGFloat bottomLeftCenterX = minX +  normalR;
    const CGFloat bottomLeftCenterY = maxY - normalR;
    
    const CGFloat bottomRightCenterX = maxX -  normalR;
    const CGFloat bottomRightCenterY = maxY - normalR;
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    //顶 左
    CGPathAddArc(path, NULL, normalR, normalR + topSpace, 8, M_PI, 3 * M_PI_2, NO);

    
    CGPathAddArc(path, NULL, maxX - 112 - bigR * 0.8, topSpace - bigR, bigR,M_PI_2, M_PI_2 * 0.3, YES);
    
    
    
    CGPathAddArc(path, NULL, maxX - 112 + bigR, bigR, bigR, M_PI_2 * 0.5, 3 * M_PI_2, NO);
    
    
    //顶 右
    CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, bigR, 3 * M_PI_2, 0, NO);
    //底 右
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, normalR,0, M_PI_2, NO);
    //底 左
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, normalR, M_PI_2,M_PI, NO);
    
    
    CGPathCloseSubpath(path);
    
    
    
    //用路径创建浪
    layer.path = path;
    layer.fillColor = rgb(255, 250, 205).CGColor;
    
    
    
    
    
    CALayer *subLayer = view.layer;
    
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = rgba(173,212,227,0.5).CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,1);
    subLayer.shadowOpacity = 1;//阴影透明度，默认0
    subLayer.shadowRadius = 8;
    subLayer.shadowPath = path;

    //释放路径
    CGPathRelease(path);
    
}

+ (void)viewGradientBorder:(UIView *)view
                 locations:(NSArray *)locations
                    colors:(NSArray *)colors
                startPoint:(CGPoint)startPoint
                  endPoint:(CGPoint)endPoint
              cornerRadius:(CGFloat)cornerRadius
{
    CAGradientLayer *layer = [YQUtils viewGradientLayer:view locations:locations colors:colors startPoint:startPoint endPoint:endPoint];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.borderWidth = 4;
    shape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, 1, view.frame.size.width - 2, view.frame.size.height - 2) cornerRadius:cornerRadius-1].CGPath;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = [UIColor whiteColor].CGColor;
    layer.mask = shape;
}

+ (CAGradientLayer *)viewGradientLayer:(UIView *)view
                locations:(NSArray *)locations
                   colors:(NSArray *)colors
               startPoint:(CGPoint)startPoint
                 endPoint:(CGPoint)endPoint
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.locations = locations;
    gradientLayer.colors = colors;
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = startPoint; //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = endPoint;
    [view.layer insertSublayer:gradientLayer atIndex:0];
    return gradientLayer;
}


+ (NSString *)getTimeFromTimestamp:(NSString *)timeStr{
    
    if (timeStr.length <10) {
        return @"";
    }
    long time = [[timeStr substringToIndex:10] longLongValue];
    //将对象类型的时间转换为NSDate类型

//    double time =1504667976;

    NSDate * myDate =[NSDate dateWithTimeIntervalSince1970:time];

    //设置时间格式

    NSDateFormatter * formatter= [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];

    //将时间转换为字符串

    NSString *timeData= [formatter stringFromDate:myDate];

    return timeData;

}


+ (void)openWeChat
{
    BOOL open = [self openUrl:@"weixin://"];
    if (!open) {
        [YQUtils showCenterMessage: @"请先安装微信"];
    }
}

+ (BOOL)openUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];

    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];

    if (canOpen) {

        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

    }
    
    return  canOpen;
}


+ (void)copyStringToPasteboard:(NSString *)string
{
    if (string.length > 0) {
        [UIPasteboard generalPasteboard].string = string;
    }
    
}


///view抖动
+ (void)shakeView:(UIView*)viewToShake
{
    CGFloat t =4.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}



+ (void)saveImageToLib:(UIImage *)image{
    if (image == nil) {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        
        [YQUtils showCenterMessage:@"图片保存失败"];
    }
    else
    {
        [YQUtils showCenterMessage:@"已保存到相册"];
        
    }
}


+ (NSString *)formatStringWithInteger:(NSUInteger)interger
{
    return [NSString stringWithFormat:@"%"MZNSI, interger];
}


+ (NSString *)getCurrentTime {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

+(NSInteger)currentTimeStamp{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSInteger time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    return time;
}



+ (UIImage *)screenShot:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}

+ (NSURL *)getURL_byHost:(NSString *)url {
    NSURL *newUrl;
    if (![url containsString:@"http"]) {
        url = [NSString stringWithFormat:@"%@/%@", [YQNetwork getFileHostUrl],url];
    }
    newUrl = [NSURL URLWithString:url];
    return newUrl;
}

//16进制颜色转换
+ (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return kColorRGB(255, 120, 120);
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+(UIImage *)imageOfStretchByImage: (UIImage *)image {
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    return newImage;
}

+(UIImage *)imageOfStretchByName: (NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    return newImage;
}

+ (void)setAttentionBackImage:(UIButton *)sender is_fans:(int)is_fans {
    [sender setTitle:@"" forState:0];
    if (is_fans < 0) {
        is_fans = 0;
    }
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_home_atten%d", is_fans]];
    [sender setBackgroundImage:image forState:0];
}

+ (void)setAttenBtn:(UIButton *)sender is_fans:(int)is_fans {
    if (is_fans == 0) {
        sender.backgroundColor = [UIColor redColor];
        [sender setTitle:@"关注" forState:0];
    }
    if (is_fans == 1) {
        sender.backgroundColor = kColorRGB(200, 200, 200);
        [sender setTitle:@"已关注" forState:0];
    }
    if (is_fans == 2) {
        sender.backgroundColor = kColorRGB(200, 200, 200);
        [sender setTitle:@"互相关注" forState:0];
    }
}

+ (UIFont *)systemMediumFontOfSize: (CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

+ (UIFont *)systemSemiboldFontOfSize: (CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
}

+ (void)showCenterMessage:(NSString *)title {
    
    if (![title length]) {
        return;
    }
    float width = title.localized.length * 13 +  30;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        UIWindow *keywindow  = [self getKeyWindow];;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 50)];
        
        titleLabel.backgroundColor = kColorRGB(26,26,26);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.layer.cornerRadius = 5;
        titleLabel.clipsToBounds = YES;
        titleLabel.text = title.localized;
        titleLabel.numberOfLines = 0;
        [titleLabel sizeToFit];
        titleLabel.mj_w += 30;
        titleLabel.mj_h += 20;
        titleLabel.center = CGPointMake(keywindow.center.x, keywindow.center.y + 100);
        
        [keywindow addSubview:titleLabel];
        
        [UIView animateWithDuration:0.2 animations:^{
            titleLabel.hidden = NO;
        } completion:^(BOOL finished) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                } completion:^(BOOL finished) {
                    titleLabel.hidden = YES;
                }];
            });
        }];
    });
}


//MARK: - 设置导航栏左边按钮
+ (void)setLeftNavItemArray:(NSArray *)array viewController:(UIViewController *)vc isTitleArray:(BOOL)isTitle action:(void (^)(NSInteger))actionBlock {
    NSMutableArray *btnArray = [NSMutableArray new];
    for (int i = 0; i < array.count; i++) {
        NSString *string = array[i];
        UIButton *navBtn = [UIButton buttonWithNormalImage:string selectedImage:string superView:nil btnClick:^(UIButton *btn) {
            if (actionBlock) {
                actionBlock(btn.tag - 233);
            }
        }];
        navBtn.tag = 233 + i;
        navBtn.frame = CGRectMake(0, 0, 40, 25);
        if (isTitle) {
            [navBtn setTitle:string forState:UIControlStateNormal];
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:navBtn];
        [btnArray addObject:item];
    }
    vc.navigationItem.leftBarButtonItems = btnArray;
}


//MARK: - 设置导航栏右边按钮

+ (void)setRightNavItemArray:(NSArray *)array
              viewController:(UIViewController *)vc
                isTitleArray:(BOOL)isTitle
                      action:(void(^)(NSInteger index))actionBlock
{
    NSMutableArray *btnArray = [NSMutableArray new];
    for (int i = 0; i < array.count; i++) {
        NSString *string = array[i];
        UIButton *navBtn = [UIButton buttonWithNormalImage:string selectedImage:string superView:nil btnClick:^(UIButton *btn) {
            if (actionBlock) {
                actionBlock(btn.tag - 233);
            }
        }];
        navBtn.tag = 233 + i;
        navBtn.frame = CGRectMake(0, 0, 40, 25);
        if (isTitle) {
            [navBtn setTitle:string forState:UIControlStateNormal];
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:navBtn];
        [btnArray addObject:item];
    }
    vc.navigationItem.rightBarButtonItems = btnArray;
    
}





+ (void)clipTheViewCornerWithCorner:(UIRectCorner)corner andView:(UIView *)view andCornerRadius:(CGFloat)radius{
    
    UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius , radius)];
    CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
    fieldLayer.frame = view.bounds;
    fieldLayer.path = fieldPath.CGPath;
    view.layer.mask = fieldLayer;
}

+ (void)clipViewWithRounded:(UIView *)view
                    topLeft:(CGFloat)topLeft
                   topRight:(CGFloat)topRight
                 bottomLeft:(CGFloat)bottomLeft
                bottomRight:(CGFloat)bottomRight
{
    
    
    CGRect bounds = view.bounds;
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    
    const CGFloat topLeftCenterX = minX + topLeft;
    const CGFloat topLeftCenterY = minY + topLeft;
    
    const CGFloat topRightCenterX = maxX - topRight;
    const CGFloat topRightCenterY = minY + topRight;
    
    const CGFloat bottomLeftCenterX = minX +  bottomLeft;
    const CGFloat bottomLeftCenterY = maxY - bottomLeft;
    
    const CGFloat bottomRightCenterX = maxX -  bottomRight;
    const CGFloat bottomRightCenterY = maxY - bottomRight;
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    //顶 左
    CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY,topLeft, M_PI, 3 * M_PI_2, NO);
    //顶 右
    CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, topRight, 3 * M_PI_2, 0, NO);
    //底 右
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, bottomRight,0, M_PI_2, NO);
    //底 左
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, bottomLeft, M_PI_2,M_PI, NO);
    CGPathCloseSubpath(path);
    
    
    CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
    fieldLayer.frame = view.bounds;
    fieldLayer.path = path;
    view.layer.mask = fieldLayer;
    
    //释放路径
    CGPathRelease(path);
}


+ (void)sendNotificationWithGame: (CGFloat)y{
    if (y > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewChange" object:@(YES)];
    }
    
    
    if (y < -44) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewChange" object:@(NO)];
    }
}


+ (UIImage *)scaleAvatarImage:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 0.5);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double dataLength = [data length] * 1.0;
    double size = dataLength / 1024.0;
    if (size <= 200) {
        return image;
    }
    
    double scale = 100 / size;
    data = UIImageJPEGRepresentation(image, scale);
    UIImage *newImage = [UIImage imageWithData:data];
    return newImage;
}



+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  [shapeLayer setBounds:lineView.bounds];
  [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
  [shapeLayer setFillColor:[UIColor clearColor].CGColor];
  //  设置虚线颜色为blackColor
  [shapeLayer setStrokeColor:lineColor.CGColor];
  //  设置虚线宽度
  [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
  [shapeLayer setLineJoin:kCALineJoinRound];
  //  设置线宽，线间距
  [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
  //  设置路径
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, 0, 0);
  CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
  [shapeLayer setPath:path];
  CGPathRelease(path);
  //  把绘制好的虚线添加上来
  [lineView.layer addSublayer:shapeLayer];
}


//+ (CGFloat)YQ0 {
//    //获取状态栏的rect
//    
//    if (@available(iOS 11.0, *)) {
//    // 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X以上设备。
//        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
//        if (window.safeAreaInsets.bottom > 0.0) {
//            return 24;
//        }
//    }
//    return 0;
//    
//    
//}
//
//+ (CGFloat)YQ0 {
//    if (@available(iOS 11.0, *)) {
//    // 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X以上设备。
//        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
//        if (window.safeAreaInsets.bottom > 0.0) {
//            return 34;
//        }
//    }
//    return 0;
//}


+ (UIViewController *)returnStoryboardVC: (NSString *)stroyboardName vcName: (NSString *)vcName {
    
    if (stroyboardName == nil) {
        stroyboardName = @"Main";
    }
    
    if (vcName == nil) {
        return [[UIStoryboard storyboardWithName:stroyboardName bundle:nil] instantiateInitialViewController];
    }
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:stroyboardName bundle:nil] instantiateViewControllerWithIdentifier:vcName];
    return vc;
}


/// 底部阴影
+ (void)shadowLayer:(CALayer *)viewLayer color:(UIColor*)color cornerRadius: (CGFloat)cornerRadius{
    if (color==nil) {
        color = kColorRGBA(0,0,0,0.1);
    }
    
    viewLayer.cornerRadius = cornerRadius;
    viewLayer.shadowColor = color.CGColor;
    viewLayer.shadowOffset = CGSizeMake(0, 2);
    viewLayer.shadowOpacity = 1;
    viewLayer.shadowRadius = cornerRadius;
    viewLayer.masksToBounds = YES;
}

+ (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [self getKeyWindow].rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}



//根据高度得到宽度
+ (CGSize)sizeWithText:(NSString *)textstr Font:(UIFont *)font maxH:(CGFloat)maxH {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, maxH);
    return [textstr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
//根据高度得到宽度
+ (CGSize)sizeWithText:(NSString *)textstr Font:(UIFont *)font maxW:(CGFloat)maxW {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [textstr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/** iOS11 适配 */
+ (void)adjustTableView:(UITableView *)tableViews viewController:(UIViewController *)view{
    view.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        tableViews.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        view.automaticallyAdjustsScrollViewInsets = NO;
    }
}

@end
