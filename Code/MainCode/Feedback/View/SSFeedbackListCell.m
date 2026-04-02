//
//  SSFeedbackListCell.m

//
//  Created by  on 2025/7/14.

//

#import "SSFeedbackListCell.h"

@interface SSFeedbackListCell()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *readView;

@end


@implementation SSFeedbackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VFFeedbackModel *)model
{
    _model = model;
    self.timeLabel.text = model.created_at;
    self.titleLabel.text = model.content;
    self.statusLabel.text = @"问题处理中".localized;
    if (model.reply_content.length > 0) {
        self.readView.hidden = NO;
        self.typeBtn.backgroundColor = rgba(97, 203, 204, 0.1);
        [self.typeBtn setTitle:@"已回复".localized forState:UIControlStateNormal];
        [self.typeBtn setTitleColor:rgba(97, 203, 204, 1) forState:UIControlStateNormal];
    }
    else{
        [self.typeBtn setTitle:@"待处理".localized forState:UIControlStateNormal];
        self.readView.hidden = YES;
        self.typeBtn.backgroundColor = [UIColor subBackgroundColor];
        [self.typeBtn setTitleColor:[UIColor subTextColor] forState:UIControlStateNormal];
    }
}

@end
