//
//   HXUploadImageView.m
   

#import "HXUploadImageView.h"


@implementation HXUploadImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}



- (void)setModel:(YQUpdataTool *)model{
    _model = model;
    if (model.image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = model.image;
        });
        
        [self uploadImage:model.image];
    }
    else{
        [self sd_setImageWithURL:imageOfNSURL(model.img)];
    }
}




- (void)uploadImage:(UIImage *)image{
    self.tipLabel.hidden = NO;
    self.tipLabel.text = @"上传中";
    self.tipLabel.userInteractionEnabled = NO;
    self.deleteBtn.hidden = YES;
    WeakSelf;
    [YQNetwork uploadImage:image progress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tipLabel.text = [NSString stringWithFormat:@"%.1f%%",progress*100];
        });
    } andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            YQUpdataTool *model = [YQUpdataTool mj_objectWithKeyValues:obj[@"data"]];
            model.image = self.image;
            weakSelf.model = model;
            weakSelf.deleteBtn.hidden = NO;
            weakSelf.tipLabel.hidden = YES;
        }
        else{
            weakSelf.tipLabel.text = @"上传失败\n点击重试";
            weakSelf.tipLabel.userInteractionEnabled = YES;
            weakSelf.deleteBtn.hidden = NO;
        }
    }];

}



- (void)initUI
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    self.tipLabel = [UILabel YQLabelWithString:@"" textColor:[UIColor whiteColor] font:Font(14) superView:self];
    self.tipLabel.backgroundColor = rgba(0, 0, 0, 0.5);
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.left.mas_equalTo(self);
    }];
    self.tipLabel.hidden = YES;
    WeakSelf;
    [self.tipLabel addTapActionWithBlock:^(UIGestureRecognizer * _Nullable sender) {
        [weakSelf uploadImage:weakSelf.image];
    }];
    
    UIButton *deleteBtn = [UIButton buttonWithNormalImage:@"icon_f_close" selectedImage:@"icon_f_close" superView:self btnClick:nil];
    deleteBtn.sd_layout.topEqualToView(self).rightEqualToView(self).widthIs(20).heightIs(20);
    self.deleteBtn = deleteBtn;
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteAction
{
    if (self.deleteSelf) {
        self.deleteSelf(self, self.model);
    }
}

@end
