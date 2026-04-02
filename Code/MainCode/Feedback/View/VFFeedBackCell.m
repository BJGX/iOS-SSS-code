//
//  VFFeedBackCell.m
//  VFProject
//


//

#import "VFFeedBackCell.h"
#import "YQBrowserImage.h"

@interface VFFeedBackCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *repleyLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *replayImages;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgViews;


@end


@implementation VFFeedBackCell

- (void)setModel:(VFFeedbackModel *)model
{
    _model = model;
    
    self.stateLabel.selected = model.reply_content.length > 0 ? YES : NO;
    
    self.contentLabel.text = model.content;
    self.timelabel.text = model.created_at;
    self.repleyLabel.text = model.reply_content;
    
//    WeakSelf;
    [self.imgViews enumerateObjectsUsingBlock:^(UIImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < model.img.count) {
            obj.hidden = NO;
            [obj sd_setImageWithURL:imageOfNSURL(model.img[idx])];
        }
        else{
            obj.hidden = YES;
        }
    }];
    
    [self.replayImages enumerateObjectsUsingBlock:^(UIImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (  idx < model.reply_img.count) {
            obj.hidden = NO;
            [obj sd_setImageWithURL:imageOfNSURL(model.reply_img[idx])];
        }
        else{
            obj.hidden = YES;
        }
    }];
    
    self.ViewHeight.constant = model.img.count == 0 ? 0 : 70;
    [self layoutIfNeeded];
    
    if (model.cellHeight == 0) {
        CGFloat height = CGRectGetMaxY(self.timelabel.frame)+10;
        if (self.stateLabel.selected) {
            height = CGRectGetMaxY(self.repleyLabel.frame);
            if (model.reply_img.count > 0) {
                height += 80;
            }
        }
        model.cellHeight = height;
    }
    
    
    
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    WeakSelf;
    [self.replayImages enumerateObjectsUsingBlock:^(__weak UIImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addTapActionWithBlock:^(UIGestureRecognizer * _Nullable sender) {
            [YQBrowserImage showImageArray:weakSelf.model.reply_img current:idx view:obj];
        }];
    }];
    
    [self.imgViews enumerateObjectsUsingBlock:^(__weak UIImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addTapActionWithBlock:^(UIGestureRecognizer * _Nullable sender) {
            [YQBrowserImage showImageArray:weakSelf.model.img current:idx view:obj];
        }];
    }];
    self.contentView.backgroundColor = [UIColor tableBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
