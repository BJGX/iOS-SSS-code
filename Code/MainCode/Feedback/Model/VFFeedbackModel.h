//
//  VFFeedbackModel.h
//  VFProject
//


//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VFFeedbackModel : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *img;

@property (nonatomic, strong) NSString *reply_content;
@property (nonatomic, strong) NSArray *reply_img;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
