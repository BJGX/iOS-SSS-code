//
//   YQBrowserImage.m
   

#import "YQBrowserImage.h"
#import <YBImageBrowser.h>
//#import <YBImageBrowser/YBIBVideoData.h>
//#import "YQUploadModel.h"
@implementation YQBrowserImage

+ (void)showImageArray:(NSArray *)array current:(NSInteger)current view:(nonnull UIView *)view
{
    NSMutableArray *datas = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        YBIBImageData *data = [YBIBImageData new];
        if ([obj isKindOfClass:[NSString class]]) {
            data.imageURL = [NSURL URLWithString:obj];
        }
        else{
            data.image = ^UIImage * _Nullable{
                return obj;
            };
        }

        data.projectiveView = view;
        [datas addObject:data];
        

    }];

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = current;
    [browser show];
}



+ (void)showLocalArray:(id)array current:(NSInteger)current view:(nonnull UIView *)view
{
    NSMutableArray *datas = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
//        if ([obj isKindOfClass:[PHAsset class]]) {
//            YBIBVideoData *data = [YBIBVideoData new];
//            data.videoPHAsset = obj;
//            data.projectiveView = view;
//            [datas addObject:data];
//        }
//        else{
//            YBIBImageData *data = [YBIBImageData new];
//            data.image = ^UIImage * _Nullable{
//                return obj;
//            };
//            data.projectiveView = view;
//            [datas addObject:data];
//        }
        
        
        
    }];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = current;
    [browser show];
}

@end
