//
//  VFQrCodeVC.m
//  VFProject
//


//

#import "VFQrCodeVC.h"
#import <SGQRCode/SGQRCode.h>

@interface VFQrCodeVC ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end

@implementation VFQrCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"分享二维码";
    self.infoLabel.text = self.model.content;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *qrimage = [SGGenerateQRCode generateQRCodeWithData:self.model.share size:320 logoImage:[UIImage imageNamed:@"logo"] ratio:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.qrCodeImageView.image = qrimage;
        });
    });
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)copyAction:(UIButton *)sender {
    [YQUtils copyStringToPasteboard:self.model.share];
    [YQUtils showCenterMessage:@"已复制到剪切板"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
