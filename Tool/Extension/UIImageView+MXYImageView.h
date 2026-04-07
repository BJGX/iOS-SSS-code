//
//  UIImageView+MXYImageView.h
//  YYTplayer
//
//  Created by  on 2018/1/24.
//  Copyright © 2018年 mxkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MXYImageView)

+(instancetype) imageViewWithBasicSetting: (CGRect) frame
                                     mode: (UIViewContentMode)mode
                                  isClips: (BOOL) isClips
                                  addView: (UIView *) addView;

- (void)rotate360Degree:(BOOL)isClockwise;
- (void)stopRotate;

- (void)YQ_loadImageUrlStr:(NSURL *)urlStr placeHolderImageName:(UIImage *)placeHolderImageName radius:(CGFloat)radius;


- (void)YQ_downloadImage:(NSURL *)url placeHolderImageName:(UIImage *)placeHolderImageName completed: (void(^)(UIImage * image))completed ;

- (void)videoImageWithvideoURL:(NSURL *)videoURL atTime:(NSTimeInterval)time;


@property (nonatomic, strong) CABasicAnimation *animationLayer;

@end
