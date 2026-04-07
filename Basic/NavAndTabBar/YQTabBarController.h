//
//  YQTabBarController.h

//
//  Created by  on 2018/3/16.
//  
//

#import <UIKit/UIKit.h>
#import "TBTabBar.h"

@interface YQTabBarController : UITabBarController
@property(nonatomic,strong) TBTabBar* myTabBar;

///是否开启旋转
@property (nonatomic, assign) BOOL allRotation;


- (void)reloadTabBarUI:(BOOL)isReview;

@end
