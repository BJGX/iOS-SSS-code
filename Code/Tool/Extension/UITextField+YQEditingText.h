//
//  UITextField+YQEditingText.h
//  HTDealApp
//
//  Created by 零度设计 on 2019/9/2.
//  Copyright © 2019 mxkj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^addEditingText)(UITextField * _Nullable textField);
NS_ASSUME_NONNULL_BEGIN

@interface UITextField (YQEditingText)


-(void)yq_addTextFieldChangedAction:(addEditingText)touchHandler;

-(void)yq_addTextFieldBeginEdit:(addEditingText)touchHandler;

- (void)setPlaceholderColor;


@end

NS_ASSUME_NONNULL_END
