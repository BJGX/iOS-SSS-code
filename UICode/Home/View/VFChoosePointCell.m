//
//  VFChoosePointCell.m
//  VFProject
//


//

#import "VFChoosePointCell.h"
@interface VFChoosePointCell()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UILabel *proLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation VFChoosePointCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YQBaseModel *)model
{
    _model = model;
    self.nameLabel.text = model.name;
    self.vipLabel.hidden = model.vip == 1 ? NO : YES;
    self.proLabel.text = [NSString stringWithFormat:@"%ld%%", model.pro];
    self.progressView.progress = model.pro/100.0;
    self.iconView.image = [VFHomeModel getFlagImage:model.name];
    
    self.backView.hidden = [[YQUserModel shared].chooseModel.ID isEqualToString:model.ID] ? NO : YES;
}

@end
