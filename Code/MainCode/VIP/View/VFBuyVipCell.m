//
//  VFBuyVipCell.m
//  VFProject
//


//

#import "VFBuyVipCell.h"
#import "NSMutableAttributedString+YQString.h"

@implementation VFBuyVipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImage *image = [YQUtils imageOfStretchByName:@"tag_xianshi"];
    self.tipsImageView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VFVipModel *)model
{
    _model = model;
    NSString *price = [NSString stringWithFormat:@"￥%@/%@天",model.price,model.time];
    NSMutableAttributedString *attr = [self.titleLabel setColorAndFontSizeWithString:price font:[YQUtils systemSemiboldFontOfSize:24] color:rgb(175, 145, 47) rang:NSMakeRange(0, model.price.length+1)];
    
    self.titleLabel.attributedText = [NSMutableAttributedString attributeFontSizeWithLabel:attr font:Font(17) rang:NSMakeRange(0, 1)];
    
    self.dayLabel.hidden = model.add_time > 0 ? NO : YES;
    self.tipsImageView.hidden = self.dayLabel.hidden;
    self.dayLabel.text = model.mark;
//    [self.dayLabel setTitle:model.mark forState:0];
    
}



- (IBAction)buyAction:(UIButton *)sender {
    if (self.buyActionBlock) {
        self.buyActionBlock(self.model);
    }
}

@end
