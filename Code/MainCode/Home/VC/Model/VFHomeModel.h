//
//  VFHomeModel.h
//  VFProject
//


//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VFHomeModel : NSObject


@property (nonatomic, strong) NSString *ID;//用户ID
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *question;

@property (nonatomic, strong) NSArray *start;
@property (nonatomic, strong) NSArray *banner;

@property (nonatomic, assign) NSInteger times;
@property (nonatomic, assign) NSInteger invite_user_activity;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *share_time;
@property (nonatomic, strong) NSString *share;
@property (nonatomic, strong) NSString *invite;

@property (nonatomic, strong) NSString *create_at;

+ (UIImage *)getFlagImage:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
