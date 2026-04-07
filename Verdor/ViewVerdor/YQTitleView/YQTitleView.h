//
//   YQTitleView.h
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQTitleView : UIScrollView
///type==2 view.contentSize != view.frame.size.width
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIColor * normalColor;
@property (nonatomic, strong) UIColor * selectedColor;
///设置数组颜色 selectedColor无效
@property (nonatomic, strong) NSArray * selectedArrayColor;

@property (nonatomic, assign) BOOL isHiddenLine;
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;

@property (nonatomic, strong) UIColor * lineColor;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CGFloat itemSpace;
@property (nonatomic, assign) CGFloat itemWidth; //itemWidth == 0 item的宽度自适应

@property (nonatomic, strong) UIImageView * lineView;


@property (nonatomic, assign) NSInteger lastIndex;

@property (nonatomic, copy) void(^didSelectedBtn)(NSInteger index);

@property (nonatomic, assign) BOOL showBackImage;


///是否是点击
@property (nonatomic , assign) BOOL  isClick;

///初始化
- (void)loadUI:(NSArray *)array;

//选中
- (void)selectedIndex: (NSInteger)index;

///重置某个Btn
- (void)reloadTitle:(id)title index: (NSInteger)index;


- (void)selectedIndexWithValueChanged:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
