//
//  YQAlert.m
//  YYTplayer
//
//  Created by  on 2017/10/27.
//  Copyright © 2017年 mxkj. All rights reserved.
//

#import "YQAlert.h"


@implementation YQAlert


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
                           block: (alertSheetBlock)block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < actionNames.count; i++) {
        NSString *name = actionNames[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(i);
        }];
        [alert addAction:action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    if (vc == nil) {
        vc = [YQUtils getCurrentVC];
    }
    
    if (is_iPad) {
        alert.popoverPresentationController.sourceView = vc.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(ScreenWidth/2.0, ScreenHeight, 1, 1);
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    
    
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (UIAlertController *)alertCustomAlertAcion: (NSString *)title
                                         sub: (NSString *)subTitle
                                 actionNames: (NSArray *)actionNames
                                          vc: (UIViewController *)vc
                                       block: (alertSheetBlock)block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i = 0; i < actionNames.count; i++) {
        NSString *name = actionNames[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(i);
        }];
        [alert addAction:action];
    }
    if (is_iPad) {
        alert.popoverPresentationController.sourceView = vc.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(ScreenWidth/2.0, ScreenHeight, 1, 1);
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    return alert;
}

+ (void)alertMessageBaseAcion: (NSString *)title
                          sub: (NSString *)subTitle
                     leftName: (NSString* )leftName
                    rightName: (NSString* )rightName
                           vc: (UIViewController *)vc
                    leftBlock: (alertNormalBlock) leftBlock
                   rightBlock: (alertNormalBlock) rightBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:UIAlertControllerStyleAlert];

    
    if (leftName.length > 0) {
        UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (leftBlock) {
                leftBlock();
            }
            
        }];
        [alert addAction:leftAction];
    }
    
    if (rightName.length > 0) {
        UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightName style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (rightBlock) {
                rightBlock();
            }
            
        }];
        [alert addAction:rightAction];
    }
    
    
    
    
    
    if (vc == nil) {
        vc = [YQUtils getCurrentVC];
    }
    
    if (is_iPad) {
        alert.popoverPresentationController.sourceView = vc.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(ScreenWidth/2.0, ScreenHeight, 1, 1);
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)alertMessageNoAction:(NSString *)title sub:(NSString *)subTitle action:(NSString *)name vc:(UIViewController *)vc {
    
    [self alertMessageBaseAcion:title sub:subTitle leftName:nil rightName:name vc:vc leftBlock:nil rightBlock:nil];
}


+ (void)alertMessageOneAction: (NSString *)title
                          sub:(NSString *)subTitle
                     leftName: (NSString* )leftName
                    rightName: (NSString* )rightName
                           vc: (UIViewController *)vc
                   rightBlock: (alertNormalBlock) rightBlock
{
    [self alertMessageBaseAcion:title sub:subTitle leftName:leftName rightName:rightName vc:vc leftBlock:nil rightBlock:rightBlock];
}


    









@end
