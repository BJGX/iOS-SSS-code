
//
//   YQEmptyView.m
   

#import "YQEmptyView.h"

@interface YQEmptyView()

@end

@implementation YQEmptyView


+ (instancetype)initWithFrame:(CGRect)frame{
    YQEmptyView *view = [[NSBundle mainBundle] loadNibNamed:YQEmptyView.className owner:nil options:nil].firstObject;
    view.frame = frame;
    return view;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}




@end
