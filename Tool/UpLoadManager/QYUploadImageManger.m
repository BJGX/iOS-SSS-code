

#import "QYUploadImageManger.h"
#import "HXUploadImageView.h"
#import <ZLPhotoBrowser.h>

@interface QYUploadImageManger()
@property (nonatomic, strong) NSMutableArray *viewArray;
@end

@implementation QYUploadImageManger

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConf];
    }
    return self;
}

- (void)initConf
{
    self.addImage = @"icon_f_pic";
    self.lineCount = 3;
    self.lineSpace = 10;
    self.maxCount = 9;
    self.viewArray = [NSMutableArray new];
}

- (void)showView:(BOOL)showAdd
{
    if (showAdd) {
        [self createAgreeView:nil];
    }
}


- (void)createAgreeView:(YQUpdataTool *)model
{

    
    WeakSelf;
    HXUploadImageView *imageView = [[HXUploadImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setDeleteSelf:^(HXUploadImageView * _Nonnull selfView, YQUpdataTool * _Nonnull model) {

        [selfView removeFromSuperview];
        [weakSelf.viewArray removeObject:selfView];
        [weakSelf reloadView];
    }];
    
    if (model == nil) {
        imageView.image = [UIImage imageNamed:@"icon_f_pic"];
        [self.viewArray addObject:imageView];
        imageView.deleteBtn.hidden = YES;
        [imageView addTapActionWithBlock:^(UIGestureRecognizer * _Nullable sender) {
            [weakSelf chooseImageView];
        }];
    }
    else{
        imageView.model = model;
        [self.viewArray insertObject:imageView atIndex:self.viewArray.count - 1];
    }
    
    [self reloadView];
    
    
}

- (void)reloadView
{
    CGFloat width = (self.frame.size.width - (self.lineCount * (self.lineCount - 1))) / self.lineCount / 1.0;
    
    if (self.itemHeight>0) {
        width = self.itemHeight;
    }
    
    __block CGFloat height = 50;
    [self.viewArray enumerateObjectsUsingBlock:^(HXUploadImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger count = idx % self.lineCount;
        NSInteger row = idx / self.lineCount;
        obj.frame = CGRectMake(width*(self.lineCount * count) , width * (self.lineCount * row), width, width);
        height = CGRectGetMaxY(obj.frame);
        obj.contentMode = UIViewContentModeScaleAspectFill;
    }];
    self.mj_h = height;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
    if (self.maxCount == self.viewArray.count - 1) {
        UIView *lastView = self.viewArray.lastObject;
        lastView.hidden = YES;
    }

}


- (void)chooseImageView
{
    [self endEditing:YES];
    if (self.maxCount - self.viewArray.count + 1 <= 0) {
        NSString *msg = [NSString stringWithFormat:@"最多只能选择%ld张", self.maxCount];
        [YQUtils showCenterMessage:msg];
        return;
    }
    
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.configuration.maxSelectCount = self.maxCount - self.viewArray.count + 1;
    actionSheet.configuration.maxPreviewCount = 0;
    actionSheet.configuration.allowSelectVideo = NO;
    actionSheet.configuration.allowEditImage = YES;
//    actionSheet.configuration.navBarImage = [UIImage imageNamed:@"icon_normal_nav_back"];
    actionSheet.configuration.navTitleColor = [UIColor blackColor];
    actionSheet.configuration.allowTakePhotoInLibrary = NO;
    actionSheet.configuration.mutuallyExclusiveSelectInMix = YES;
    actionSheet.configuration.navBarColor = [UIColor whiteColor];
    actionSheet.configuration.showSelectBtn = YES;
    actionSheet.sender = [YQUtils getCurrentVC];
    actionSheet.configuration.allowSlideSelect = NO;
    [actionSheet showPreviewAnimated:YES];
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YQUpdataTool *model = [[YQUpdataTool alloc] init];
            model.image = obj;
            [self createAgreeView:model];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadView];;
        });
        
    }];
}


- (NSString *)getImages
{
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < self.viewArray.count - 1; i++) {
        HXUploadImageView *view = self.viewArray[i];
        if (view.model.img.length == 0) {
            [YQUtils showCenterMessage:@"图片还没有上传完成"];
            return nil;
        }
        [array addObject:view.model.img];
    }

    NSString *images = @"";
    
    if (array.count > 0) {
        images = [array componentsJoinedByString:@","];
//        images = [array mj_JSONString];
    }
    return images;
}

@end
