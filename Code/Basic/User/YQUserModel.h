//
//  YQUserModel.h
//  YYTplayer
//
//  Created by 洺信 on 2017/9/15.
//  Copyright © 2017年 mxkj. All rights reserved.
//

#import <Foundation/Foundation.h>




extern CGFloat topHeightIPhoneX;
extern CGFloat bottomHeightIPhoneX;

@interface YQUserModel : NSObject
@property (nonatomic, strong) YQUserModel *user;
@property (nonatomic, strong) YQBaseModel *chooseModel;
@property (nonatomic, strong) YQBaseModel *service;

@property (nonatomic, assign) BOOL  isLogin;//是否登录，该参数自己控制，不是返回数据

@property (nonatomic, strong) NSString *ID;//用户ID
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *createtime;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *invite;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *web;
@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *area_code;
//@property (nonatomic, strong) NSString *hasFavorite;
//@property (nonatomic, strong) NSString *vipStatus;
//@property (nonatomic, strong) NSString *vipEndTime;
//@property (nonatomic, strong) NSString *point;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *link;
//@property (nonatomic, strong) NSString *content;
//@property (nonatomic, strong) NSString *ticket;

@property (nonatomic, assign) NSInteger hot_switch;
@property (nonatomic, assign) NSInteger gift;
@property (nonatomic, assign) NSInteger gift_time;
@property (nonatomic, assign) NSInteger gift_status;
@property (nonatomic, assign) NSInteger password;
@property (nonatomic, assign) NSInteger vip;
@property (nonatomic, assign) NSInteger recharge;
@property (nonatomic, assign) NSInteger tourist;
@property (nonatomic, assign) NSInteger is_vip;
//@property (nonatomic, assign) NSInteger hot_switch;
+ (YQUserModel*)shared;

+ (void)saveUserInfo;

+ (void)getUserInfo;

+ (void)logOutSocket;

+ (void)clearInfo;

+ (BOOL)showLoginVC;

+ (BOOL)isLogined:(BOOL)isPushToLoginVC;

+ (void)loginOutUser;
@end




