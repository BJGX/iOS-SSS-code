//
//   YQTitleView.m
   

#import "YQTitleView.h"
#import <Masonry.h>

static CGFloat const scale = 0.2;

@interface YQTitleView()

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UIImage *lineImage;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, assign) BOOL isScroll;


///滚动变色 相关属性


//记录RGB的值
@property (nonatomic , assign) CGFloat  defaultR,defaultG,defaultB,defaultA,selectedR,selectedG,selectedB,selectedA;
@property (nonatomic , strong) UIColor *nextColor ;



@end

@implementation YQTitleView

- (void)initConfign{
    self.type = 1;
    self.normalColor = [UIColor lightGrayColor];
    self.selectedColor = [UIColor blackColor];
    
    self.normalFont = [UIFont systemFontOfSize:14];
    self.selectedFont = [UIFont systemFontOfSize:14];
    self.lineColor = [UIColor clearColor];
    
    self.lineWidth = 0;
    self.lineHeight = 5;
    self.isHiddenLine = NO;
    

    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    
    self.lineImage = [UIImage imageNamed:@"yuanhu"];
    
    
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfign];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfign];
    }
    return self;
}



- (void)loadUI:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat width = self.frame.size.width / array.count;
        
    self.clipsToBounds = YES;
    self.lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2 * self.lineHeight, self.lineWidth, self.lineHeight)];
    if (self.lineImage) {
        self.lineView.image = self.lineImage;
        self.lineView.frame = CGRectMake(0, self.frame.size.height - 13, 18, 13);
        self.lineView.centerY = self.mj_h / 2.0 + self.selectedFont.pointSize / 2.0 + 6;
        self.lineView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else {
        self.lineView.cornerRadius = self.lineHeight / 2.0;
    }
    
    self.lineView.backgroundColor = self.lineColor == nil ? self.selectedColor : self.lineColor;
    
    self.lineView.clipsToBounds = YES;
    self.lineView.hidden = self.isHiddenLine;
    [self addSubview:self.lineView];
    self.dataArray = [NSMutableArray new];
    self.imageArray = [NSMutableArray new];
    
    NSArray *images = @[@"tag_selected_1",@"tag_selected_2",@"tag_selected_3",@"tag_selected_4"];
    UILabel *leftLabel = nil;
    for (int i  = 0; i < array.count; i ++) {
    
        @autoreleasepool {
            
            
            
            
            
            NSString *title = array[i];
            UILabel *label = [UILabel YQLabelWithString:title textColor:self.normalColor font:self.normalFont];
            if (self.selectedArrayColor) {
                label.highlightedTextColor = self.selectedArrayColor[i];
            }
            else {
                label.highlightedTextColor = self.selectedColor;
            }
            
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            [self.dataArray addObject:label];
            [self addSubview:label];
            label.userInteractionEnabled = YES;
            label.tag = 555 + i;
            label.minimumScaleFactor = 0.5;
//            label.adjustsFontSizeToFitWidth = YES;

            UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelAction:)];
            [label addGestureRecognizer:tapLabel];
            label.frame = CGRectMake(i * width, 0, width, self.frame.size.height);
            if (self.type == 2) {
                
                if (self.itemWidth > 0) {
                    label.frame = CGRectMake(i * self.itemWidth, 0, self.itemWidth, self.frame.size.height);
                }
                
                if (self.itemWidth == 0 && self.itemSpace > 0) {
                    [label sizeToFit];
                    
                    if (leftLabel == nil) {
                        
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.mas_right);
                            make.top.equalTo(self.mas_top);
//                            make.width.offset(label.frame.size.width);
                            make.height.offset(self.frame.size.height);
                        }];
                        
                        
                    }
                    else {
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(leftLabel.mas_right).offset(self.itemSpace);
                            make.top.equalTo(self.mas_top);
//                            make.width.offset(label.frame.size.width);
                            make.height.offset(self.frame.size.height);
                        }];
                    }
                    leftLabel = label;
                }
                
                if (i == array.count - 1) {
                    CGFloat srcollViewW = CGRectGetMaxX(label.frame);
                    self.contentSize  = CGSizeMake(srcollViewW, 0);
                }
            }
            
            if (self.showBackImage) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                imageView.centerX = label.center.x;
                imageView.image = [UIImage imageNamed:images[i]];
                [self addSubview:imageView];
                [self sendSubviewToBack:imageView];
                imageView.alpha = 0;
                [self.imageArray addObject:imageView];
            }
            
            
            
        }
        
    }
//    [self bringSubviewToFront:_lineView];
    [self selectedIndex:0];
    
}


- (void)highlightedLabel: (UILabel *)label
{
    
    if (label.highlighted == YES) {
        return;
    }
    
    NSInteger index= label.tag - 555;
    self.lastIndex = index;
    
    for (UILabel *subLabel in self.dataArray) {
        subLabel.highlighted = NO;
        subLabel.textColor = self.normalColor;
        subLabel.font = self.normalFont;
        
    }
    label.highlighted = YES;
    CGFloat w = [YQUtils sizeWithText:label.text Font:self.selectedFont maxW:MAXFLOAT].width;
    if (self.lineWidth == 0) {
        _lineView.mj_w = w + 5;
    }
    else {
        _lineView.mj_w = self.lineWidth;
    }
    
    UIImageView *image;
    if (self.showBackImage) {
        for (UIImageView *img in self.imageArray) {
            img.alpha = 0;
        }
        image = self.imageArray[label.tag - 555];
        image.alpha = 1;
    }
    if (self.selectedArrayColor) {
        self.lineView.backgroundColor = self.selectedArrayColor[label.tag - 555];
    }
    
    
    

    
    WeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.lineView.centerX = label.center.x;
        label.font = weakSelf.selectedFont;
    
    } completion:^(BOOL finished) {
        
        
        
        weakSelf.isClick = NO;
    }];
    
    if (self.type != 2) {
        return;
    }
    
    CGFloat centerX = label.center.x - (ScreenWidth / 2.0);
    CGFloat y = self.contentSize.width - label.center.x - (ScreenWidth / 2.0);
    
    if (centerX < 0) {
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    
    else if (centerX > 0 && y > 0) {
        
        
        [self setContentOffset:CGPointMake(centerX, 0) animated:YES];
    }

    else {
        if (self.contentSize.width - self.frame.size.width > 0) {
            [self setContentOffset:CGPointMake(self.contentSize.width - self.frame.size.width, 0) animated:YES];
        }
        
    }
//    [label sizeToFit];
//    [self layoutIfNeeded];
    
}


- (void)selectedIndex: (NSInteger)index {
    if (index >= self.dataArray.count) {
        return;
    }
    
    UILabel *label = self.dataArray[index];
    label.transform = CGAffineTransformMakeScale(1,1);
    [self highlightedLabel:label];
}



- (void)selectedIndexWithValueChanged:(CGFloat)value {
    NSInteger index = value / ScreenWidth;
    
    self.isScroll = YES;
    
    if (self.isClick) {
        return;
    }
    
    
    if (value - index * ScreenWidth == 0 && self.isClick == NO) {
        [self selectedIndex:index];
        return;
    }
    
    
    
    
    CGFloat percent =  (value - (index * ScreenWidth)) / ScreenWidth;
    percent = fabs(percent);
    if (index < 0 || index >= self.dataArray.count) {
       return;
    }
    
//    CGFloat itemW = self.frame.size.width / self.dataArray.count / 1.0;
//    CGFloat width = percent * (itemW);
//    self.lineView.centerX = width + (index * itemW) + itemW / 2.0;
    
    
    
    [self animationItem:NO percent:percent index:index];
//    if (index <self.lastIndex) {
//        [self animationItem:YES percent:percent index:index];
//    }else{
//        
//    }
    
    
//

}


- (void)animationItem:(BOOL)isleft percent:(CGFloat)percent index:(NSInteger)index{
    UILabel *nextItem = nil;
    UILabel *lastItem = nil;
    
    
    if (isleft ) {
        nextItem = self.dataArray[index];
        lastItem = self.dataArray[index+1];
        
    }else if(!isleft && index + 1 < self.dataArray.count){
        nextItem = self.dataArray[index +1];
        lastItem = self.dataArray[index];
        
    }
    if (!nextItem) {
        return;
    }
    [self getColorRGB:self.normalColor isSelected:NO];
    [self getColorRGB:self.selectedColor isSelected:YES];
    [self resetNormalLabel:lastItem];
    [self resetNormalLabel:nextItem];
    
    CGFloat width = nextItem.center.x - lastItem.center.x;
    CGFloat value = width * percent + lastItem.center.x;
    self.lineView.centerX = value;
    
    
    self.nextColor =[UIColor colorWithRed:self.defaultR + (self.selectedR - self.defaultR)*percent green:self.defaultG + (self.selectedG - self.defaultG)*percent blue:self.defaultB + (self.selectedB - self.defaultB)*percent alpha:self.defaultA + (self.selectedA - self.defaultA)*percent];
    
    UIColor *lastColor = [UIColor colorWithRed:self.selectedR - (self.selectedR - self.defaultR)*percent green:self.selectedG - (self.selectedG - self.defaultG)*percent blue:self.selectedB - (self.selectedB - self.defaultB)*percent alpha: self.selectedA - (self.selectedA - self.defaultA)*percent];
    
    if (isleft) {
        if (lastItem) {
            lastItem.textColor = self.nextColor;
        }
        nextItem.textColor = lastColor;
        
        
        
        
    }else{
        if (lastItem) {
            lastItem.textColor = lastColor;
        }
        
        nextItem.textColor = self.nextColor;
    }
}


- (void)resetNormalLabel:(UILabel *)label
{
    label.highlighted = NO;
    label.font = self.normalFont;
    
}

///获取颜色值
- (void)getColorRGB:(UIColor *)color isSelected:(BOOL)isSelected

{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    if (isSelected) {
        self.selectedA = alpha;
        self.selectedR = red;
        self.selectedG = green;
        self.selectedB = blue;
    }else{
        self.defaultA = alpha;
        self.defaultR = red;
        self.defaultG = green;
        self.defaultB = blue;
    }
    
}




///点击item
- (void)tapLabelAction: (UIGestureRecognizer *)sender
{
    
    if (self.isClick) {
        return;
    }
    
    UILabel *label = (UILabel *)sender.view;
    self.isClick = YES;
    [self highlightedLabel:label];
    NSInteger index= label.tag - 555;
    self.lastIndex = index;
    
    if (self.didSelectedBtn) {
        self.didSelectedBtn(index);
    }
    
}



//MARK: - 重置title
- (void)reloadTitle:(id)title index:(NSInteger)index {
    UILabel *label = self.dataArray[index];
    if ([title isKindOfClass:[NSString class]]) {
        
        label.text = title;
    }
    else {
        label.attributedText = title;
    }
    label.textAlignment = NSTextAlignmentCenter;
}


///是否显示item 背景
- (void)setShowBackImage:(BOOL)showBackImage {
    _showBackImage = showBackImage;
    if (showBackImage) {
//        self.imageArray = @[@"tag_selected_1",@"tag_selected_2",@"tag_selected_3",@"tag_selected_4"];
//        self.tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [self addSubview:self.tagImageView];
//        [self sendSubviewToBack:self.tagImageView];
//        [self selectedIndex:0];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    if ([self.dataArray count]) {
        for (UILabel *label in self.dataArray) {
            label.textColor = normalColor;
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    if ([self.dataArray count]) {
        for (UILabel *label in self.dataArray) {
            label.highlightedTextColor = selectedColor;
        }
    }
}


@end
