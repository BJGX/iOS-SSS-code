//
//  UIImageView+MXYImageView.m
//  YYTplayer
//
//  Created by  on 2018/1/24.
//  Copyright © 2018年 mxkj. All rights reserved.
//

#import "UIImageView+MXYImageView.h"
#import <SDWebImageManager.h>
#import <SDImageCache.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@implementation UIImageView (MXYImageView)
+(instancetype)imageViewWithBasicSetting:(CGRect)frame mode:(UIViewContentMode)mode isClips:(BOOL)isClips addView:(UIView *)addView {
    UIImageView *imageView = [[self alloc] initWithFrame:frame];

    imageView.contentMode = mode;
    imageView.clipsToBounds = isClips;
    [addView addSubview:imageView];
    return imageView;
}


/// 旋转  isClockwise 是否顺时针
- (void)rotate360Degree:(BOOL)isClockwise {
    if ([self.layer.animationKeys containsObject:@"360rotate"]) {
        return;
    }
    CABasicAnimation *animation =  [CABasicAnimation
                                    animationWithKeyPath:@"transform.rotation.z"];

    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    
    CGFloat end = isClockwise ? 0.f : -M_PI * 2;
    CGFloat begin = isClockwise ? -M_PI * 2 : 0.f;
    
    animation.fromValue = [NSNumber numberWithFloat:begin];
    animation.toValue =  [NSNumber numberWithFloat: end];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];         // 动画效果慢进慢出
    animation.duration  = 2;  //动画持续时间
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO; //动画后是否回到最初状态（配合kCAFillModeForwards使用）
    animation.repeatCount = 10000; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.layer addAnimation:animation forKey:@"360rotate"];
}

- (void)stopRotate {
    
    
    if (![self.layer.animationKeys containsObject:@"360rotate"]) {
        return;
    }
    
    CALayer *presentationLayer = self.layer.presentationLayer;
    CGFloat currentAngle = [[presentationLayer valueForKeyPath:@"transform.rotation.z"] floatValue];
    
    // 2. 移除所有动画（立即停止当前旋转）
    [self.layer removeAllAnimations];
    
    // 3. 创建复位动画
    CABasicAnimation *resetAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    resetAnimation.fromValue = @(currentAngle); // 从当前角度开始
    resetAnimation.toValue = @(M_PI * 2);            // 回到0°
    resetAnimation.duration = 2;              // 复位时间（可根据需求调整）
    resetAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // 4. 更新模型层值（确保动画结束后保持在0°）
    self.layer.transform = CATransform3DIdentity; // 重置transform
    
    // 5. 添加复位动画
    [self.layer addAnimation:resetAnimation forKey:@"resetAnimation"];
}


- (void)YQ_loadImageUrlStr:(NSURL *)urlStr
      placeHolderImageName:(UIImage *)placeHolderImageName
                    radius:(CGFloat)radius
{
    NSURL *url;
    if (radius == CGFLOAT_MIN) {
        radius = self.frame.size.width/2.0;
    }
    url = urlStr;
    if (radius != 0.0) {
        //需要手动缓存处理成圆角的图片
        NSString *keyStr = urlStr.path;
        NSString *cacheurlStr = [keyStr stringByAppendingString:@"radiusCache"];
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheurlStr];
        if (cacheImage) {
            self.image = cacheImage;
        }
        else {
            [self sd_setImageWithURL:url placeholderImage:placeHolderImageName completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    UIImage *radiusImage = [UIImageView createRoundedRectImage:image size:self.frame.size radius:radius];
                    self.image = radiusImage;
//                    [[SDWebImageManager sharedManager] saveImageToCache:radiusImage forURL:[NSURL URLWithString:cacheurlStr]];
                    //清除原有非圆角图片缓存
                    [[SDImageCache sharedImageCache] removeImageForKey:urlStr.absoluteString withCompletion:nil];
                }
            }];
        }
    }
    else {
        [self sd_setImageWithURL:url placeholderImage:placeHolderImageName completed:nil];
    }
    
    
}

- (void)YQ_downloadImage:(NSURL *)url placeHolderImageName:(UIImage *)placeHolderImageName completed: (void(^)(UIImage * image))completed {
    
//    self.image = placeholderIMG;
    NSString *keyStr = url.path;
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:keyStr];
    if (cacheImage) {
        self.image = cacheImage;
        if (completed) {
            completed(cacheImage);
        }
        return;
    }
    
    
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        if (image != nil) {
//            self.image = image;
//            if (completed) {
//                completed(image);
//            }
//            [[SDWebImageManager sharedManager] saveImageToCache:image forURL:url];
//
//        }
//
//    }];
}


static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    //根据圆角路径绘制
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(CGFloat)r
{

    
    int w = size.width * 4;
    int h = size.height * 4;
    CGFloat radius = r * 4;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    //CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}










- (void)videoImageWithvideoURL:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    //先从缓存中找是否有图片
    SDImageCache *cache =  [SDImageCache sharedImageCache];
    UIImage *memoryImage =  [cache imageFromMemoryCacheForKey:videoURL.absoluteString];
    if (memoryImage) {
        self.image = memoryImage;
        return;
    }else{
        UIImage *diskImage =  [cache imageFromDiskCacheForKey:videoURL.absoluteString];
        if (diskImage) {
            self.image = diskImage;
            return;
        }
    }
    
    if (!time) {
        time = 1;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        if(!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SDImageCache *cache =  [SDImageCache sharedImageCache];
            [cache storeImageToMemory:thumbnailImage forKey:videoURL.absoluteString];
            self.image = thumbnailImage;
        });
        
    });
   
}






@end
