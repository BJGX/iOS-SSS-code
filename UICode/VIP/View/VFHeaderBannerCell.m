//
//  VFHeaderBannerCell.m
//  VFProject
//


//

#import "VFHeaderBannerCell.h"

@implementation VFHeaderBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VFVipModel *)model
{
    _model = model;
    [self.backImageView sd_setImageWithURL:imageOfNSURL(model.img) placeholderImage:[UIImage imageNamed:@"banner2"]];
    self.titleLabel.text = model.name;
    NSString *price = [NSString stringWithFormat:@"￥%@/%@天",model.price,model.time];
    [self.subLabel setFontSizeWithString:price font:[YQUtils systemMediumFontOfSize:30] range:NSMakeRange(1, model.price.length)];
    
    self.oldPriceLabel.text = [NSString stringWithFormat:@"原价: ￥%@", model.old_price];
    
    
    NSInteger time = model.remaining_time/1000;
    
    if (time < 60*24) {
        self.timeLabel.text = [NSString stringWithFormat:@"%02ld小时%02ld分钟", time/60, time%60];
    }
    else{
        self.timeLabel.text = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟", time/60/24, time/60%24, time%60];
    }

}

- (IBAction)buyAction:(UIButton *)sender {
    if (self.buyActionBlock) {
        self.buyActionBlock(self.model);
    }
}

@end
