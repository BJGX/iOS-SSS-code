//
//  YQAlert.h
//  YYTplayer
//
//  Created by  on 2017/10/27.
//  Copyright © 2017年 mxkj. All rights reserved.
//

typedef void(^alertSheetBlock)(int index);
typedef void(^alertNormalBlock)(void);

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YQAlert : NSObject



/**
 自定义 UIAlertController

 @param title 标题
 @param subTitle 子标题
 @param actionNames 按钮名字(数组形势)
 @param vc viewController
 @param block 回调 0开始
 */
+ (UIAlertController *)alertCustomAlertAcion: (NSString *)title
                                         sub: (NSString *)subTitle
                                 actionNames: (NSArray *)actionNames
                                          vc: (UIViewController *)vc
                                       block: (alertSheetBlock)block;


/**
 底部模态弹窗
 
 @param title 标题
 @param subTitle 子标题
 @param actionNames 按钮名字(数组形势)
 @param vc viewController
 @param block 回调 0开始
 */
+ (void)alertSheetViewController: (NSString *)title
                             sub: (NSString *)subTitle
                     actionNames: (NSArray *)actionNames
                              vc: (UIViewController *)vc
                           block: (alertSheetBlock)block;



///两事件模态弹窗
+ (void)alertMessageBaseAcion: (NSString *)title
                          sub: (NSString *)subTitle
                     leftName: (NSString* )leftName
                    rightName: (NSString* )rightName
                           vc: (UIViewController *)vc
                    leftBlock: (alertNormalBlock) leftBlock
                   rightBlock: (alertNormalBlock) rightBlock;


///一事件模态弹窗
+ (void)alertMessageOneAction: (NSString *)title
                          sub: (NSString *)subTitle
                     leftName: (NSString* )leftName
                    rightName: (NSString* )rightName
                           vc: (UIViewController *)vc
                   rightBlock: (alertNormalBlock) rightBlock;


///无事件模态弹窗
+ (void)alertMessageNoAction: (NSString *)title
                         sub: (NSString *)subTitle
                      action: (NSString* )name
                          vc: (UIViewController *)vc;







@end
