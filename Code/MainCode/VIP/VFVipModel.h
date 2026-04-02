//
//  VFVipModel.h
//  VFProject
//


//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VFVipModel : NSObject


@property (nonatomic, strong) NSString *ID;//用户ID
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *end;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic, strong) NSString *apple_id;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *old_price;
@property (nonatomic, strong) NSString *old_price_us;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *price_us;
@property (nonatomic, strong) NSString *attribute;
@property (nonatomic, strong) NSString *productid;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *wxts;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *amount_us;
@property (nonatomic, strong) NSString *orderno;
@property (nonatomic, strong) NSArray *activity;
@property (nonatomic, strong) NSArray *vip;
@property (nonatomic, strong) NSArray *listArray;


@property (nonatomic, assign) NSInteger add_time;
@property (nonatomic, assign) long remaining_time;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger space;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) BOOL isSelectedModel;

@end

NS_ASSUME_NONNULL_END
