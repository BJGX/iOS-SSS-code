//
//   NTVideoTool.h
   

#import <Foundation/Foundation.h>

@class PHAsset;

typedef void(^MovEncodeToMpegToolResultBlock)(NSURL *mp4FileUrl, NSData *mp4Data, NSError *error);

typedef enum : NSUInteger {
    ExportPresetLowQuality,        //低质量 可以通过移动网络分享
    ExportPresetMediumQuality,     //中等质量 可以通过WIFI网络分享
    ExportPresetHighestQuality,    //高等质量
    ExportPreset640x480,
    ExportPreset960x540,
    ExportPreset1280x720,    //720pHD
    ExportPreset1920x1080,   //1080pHD
    ExportPreset3840x2160,
} ExportPresetQuality;

NS_ASSUME_NONNULL_BEGIN

@interface NTVideoTool : NSObject

+ (void)convertMovToMp4FromPHAsset:(PHAsset*)resourceAsset
     andAVAssetExportPresetQuality:(ExportPresetQuality)exportQuality
 andMovEncodeToMpegToolResultBlock:(MovEncodeToMpegToolResultBlock)movEncodeToMpegToolResultBlock;

@end

NS_ASSUME_NONNULL_END
