//
//  UITextField+YQEditingText.m
//  HTDealApp
//
//  Created by 零度设计 on 2019/9/2.
//  Copyright © 2019 mxkj. All rights reserved.
//

#import "UITextField+YQEditingText.h"

#import <objc/runtime.h>
static const void *yq_addEditingTextKey = &yq_addEditingTextKey;

static const void *yq_addBeginEditingTextKey = &yq_addBeginEditingTextKey;

@implementation UITextField (YQEditingText)

- (void)yq_addTextFieldBeginEdit:(addEditingText)touchHandler
{
    objc_setAssociatedObject(self, yq_addBeginEditingTextKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(textFieldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)textFieldBeginEditing:(UITextField *)textFiled
{
    addEditingText block = objc_getAssociatedObject(self, yq_addBeginEditingTextKey);
    if (block) {
        block(textFiled);
    }
}


- (void)yq_addTextFieldChangedAction:(addEditingText)touchHandler {
    objc_setAssociatedObject(self, yq_addEditingTextKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(textFieldStringdDidChange:) forControlEvents:UIControlEventEditingChanged];
}


- (void)textFieldStringdDidChange: (UITextField *)textFiled {
    addEditingText block = objc_getAssociatedObject(self, yq_addEditingTextKey);
    NSString *language = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    BOOL isChinese = NO;
    if ([language isEqualToString:@"zh-Hans"] || [language isEqualToString:@"zh-Hant"]) {
        isChinese = YES;
    }

    if (isChinese) {
        UITextRange *selcetedRang = [textFiled markedTextRange];
        UITextPosition *position = [textFiled positionFromPosition:selcetedRang.start offset:0];
        if (!position) {
            if (block) {
                block(textFiled);
            }
        }
    }
    else
    {
        if (block) {
            block(textFiled);
        }
    }

}

- (void)setPlaceholderColor
{
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.placeholder.localized attributes:@{NSFontAttributeName : self.font, NSForegroundColorAttributeName : [UIColor subTextColor]}];
//    self.attributedPlaceholder = attributedString;
    
    self.placeholder = self.placeholder.localized;
    
    UIView *leftView = [UIView viewWithFrame:CGRectMake(0, 0, 20, 45) backgroundColor:[UIColor clearColor]];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    UIView *rightView = [UIView viewWithFrame:CGRectMake(0, 0, 20, 45) backgroundColor:[UIColor clearColor]];
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    
}




@end
