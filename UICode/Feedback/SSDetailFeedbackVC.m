//
//  SSDetailFeedbackVC.m

//
//  Created by  on 2025/7/15.

//

#import "SSDetailFeedbackVC.h"

@interface SSDetailFeedbackVC ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageArr1;
@property (weak, nonatomic) IBOutlet UILabel *replayLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageArr2;

@property (weak, nonatomic) IBOutlet UIView *kfView;

@end

@implementation SSDetailFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"意见反馈";
    
    self.contentLabel.text = self.model.content;
    self.timeLabel1.text = self.model.created_at;
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor subBackgroundColor];
    [self.imageArr1 enumerateObjectsUsingBlock:^(UIImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.model.img.count) {
            obj.hidden = NO;
            [obj sd_setImageWithURL:imageOfNSURL(self.model.img[idx])];
        }
        else{
            obj.hidden = YES;
        }
    }];
    
    
    if (self.model.reply_content.length == 0) {
        self.kfView.hidden = YES;
        return;
    }
    self.replayLabel.text = self.model.reply_content;
    
    
    
    [self.imageArr2 enumerateObjectsUsingBlock:^(UIImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.model.reply_img.count) {
            obj.hidden = NO;
            [obj sd_setImageWithURL:imageOfNSURL(self.model.reply_img[idx])];
        }
        else{
            obj.hidden = YES;
        }
    }];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sureAction:(UIButton *)sender {
}
- (IBAction)kfAction:(UIButton *)sender {
    [QYCommonFuncation shouKefu];
}

@end
