//
//  YQWebViewVC.h
//  YQBaseProject
//
//  Created by Cjml on 2020/1/10.
//  Copyright © 2020 Cjml. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQBaseViewController.h"



NS_ASSUME_NONNULL_BEGIN

@interface YQWebViewVC : YQBaseViewController

///如果titleString=nil   显示网页的title
@property (nonatomic, strong) NSString *titleString;
///加载url
@property (nonatomic, strong) NSString *url;
///html文本
@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) NSInteger agreementType;

@end

NS_ASSUME_NONNULL_END
