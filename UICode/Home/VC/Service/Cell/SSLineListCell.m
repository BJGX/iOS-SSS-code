//
//  SSLineListCell.m

//
//  Created by  on 2025/7/4.

//

#import "SSLineListCell.h"
#import "FCSocket.h"
#import "VFAES.h"

@interface SSLineListCell()
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cllectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *speedAction;

@end

@implementation SSLineListCell


- (IBAction)collectionAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.isCollect = !self.model.isCollect;
    NSString *collectString = [YQCache getDataFromPlist:@"CollectServiceList"] ?: @"";
    if (sender.selected) {
        
        collectString = [NSString stringWithFormat:@"%@ID:%@",collectString, self.model.ID];
    }
    else {
        collectString = [collectString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"ID:%@",self.model.ID] withString:@""];
    }
    [YQCache saveDataToPlist:collectString key:@"CollectServiceList"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectServiceList" object:nil];
//    [QYSettingConfig shared].collectString = collectString;
    
}

- (void)setModel:(YQBaseModel *)model
{
    _model = model;
    self.cllectBtn.selected = model.isCollect;
    self.nameLabel.text = model.name.localized;
    self.speedAction.hidden = YES;
    self.selectedView.hidden = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    if ([model.name isEqualToString:[YQUserModel shared].chooseModel.name]) {
        self.selectedView.hidden = NO;
        self.contentView.backgroundColor = [[UIColor appThemeColor] colorWithAlphaComponent:0.2];
    }
    if (self.model.type >= 0) {
        return;
    }
    if (model.speedString == nil) {
        int port = [model.port intValue];
        [FCSocket contact:model.ip port:port block:^(NSString * _Nonnull string, NSInteger type) {
            model.type = type;
            model.speedString = string;
            NSString *name = [NSString stringWithFormat:@"icon_s_s%ld",model.type];
            self.speedAction.hidden = NO;
            self.speedAction.image = [UIImage imageNamed:name];
        }];
    }
    else {
        
        NSString *name = [NSString stringWithFormat:@"icon_s_s%ld",model.type];
        self.speedAction.image = [UIImage imageNamed:name];
    }
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chooseBtn:(UIButton *)sender {
    YQBaseModel *model = self.model;
    
    
    [QYCommonFuncation getServiceData:model.ID mainThird:YES];
    
    
//    model.service_str = @"ssr://ZGUxdjMuZHNqc2FwaS5jb206NDQzOm9yaWdpbjpub25lOnBsYWluOlEyeE1jVXAwVTJoM1NFMXcvP29iZnNwYXJhbT0mcHJvdG9wYXJhbT0mcmVtYXJrcz1aR1V4ZGpNdVpITnFjMkZ3YVM1amIyMCZncm91cD0mb3RfZW5hYmxlPTEmb3RfZG9tYWluPVpHVXhkak11WkhOcWMyRndhUzVqYjIwJm90X3BhdGg9V1ZSb1JIVlZlbkIwUTBKNE9GVlNOMWR4ZGpr";
    
//    model.param_s = [VFAES aesDecrypt:model.service_str];
//    NSLog(@"pass = %@\n", model.param_s);
//    
//    
//    
//    if (![[YQUserModel shared].chooseModel.ip isEqualToString:model.ip]) {
//        [YQUserModel shared].chooseModel = model;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseXianLu" object:nil];
//    }
//    [[YQUtils getCurrentVC].navigationController popViewControllerAnimated:YES];
}

@end
