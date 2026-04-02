//
//   TBScrollView.m
   

#import "TBScrollView.h"

@interface TBScrollView()<UIGestureRecognizerDelegate>

@end

@implementation TBScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
