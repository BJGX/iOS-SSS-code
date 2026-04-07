//
//  SSNewAddFeedbackHeader.m

//
//  Created by  on 2025/7/14.

//

#import "SSNewAddFeedbackHeader.h"
#import "UITextView+PlaceHolder.h"
#import "QYUploadImageManger.h"
#import "YQTagView.h"
@interface SSNewAddFeedbackHeader()
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UITextView *contentTF;
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *codeStringLabel;
@property (nonatomic, strong) NSString *codeString;
@property (nonatomic, strong) YQTagView *tagView;
@property (nonatomic, strong) QYUploadImageManger *upload;

@property (nonatomic, assign) NSInteger type;

@end

@implementation SSNewAddFeedbackHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentTF.placeholder = @"若付款成功VIP时间未到账, 请提供App订单截图+支付成功截图, 以便优先处理".localized;
    int code = arc4random() % 8000 + 1000;
    self.codeString = [NSString stringWithFormat:@"%d", code];
    self.codeStringLabel.text = self.codeString;
    
    QYUploadImageManger *upload = [[QYUploadImageManger alloc] initWithFrame:CGRectMake(15, 46, ScreenWidth - 24, 72)];
    upload.itemHeight = 72;
    upload.maxCount = 3;
    [self.imageView addSubview:upload];
    [upload showView:YES];
    self.upload = upload;
    
    self.codeTF.placeholder = self.codeTF.placeholder.localized;
    
    self.tagView = [[YQTagView alloc] init];
    [self.typeView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(55);
        make.height.offset(70);
        make.right.offset(-15);
    }];
    self.tagView.allowEmptySelection = YES;
    self.tagView.allowsMultipleSelection = NO;
    self.tagView.tagInsets = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tagView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //字体
    self.tagView.tagFont = Font(14);
    self.tagView.tagSelectedFont = Font(14);
    
    //文字
    self.tagView.tagTextColor = [UIColor subTextColor];
    self.tagView.tagSelectedTextColor = [UIColor whiteColor];
    
    
    //背景
    self.tagView.tagBackgroundColor = [[UIColor appThemeColor] colorWithAlphaComponent:0.1];
    self.tagView.tagSelectedBackgroundColor = [UIColor appThemeColor];
    
    self.tagView.tagHeight = 30;
    self.tagView.tagcornerRadius = 12;
    
    self.tagView.backgroundColor = [UIColor clearColor];
    self.tagView.tagsArray = @[@"产品建议".localized,@"功能故障".localized,@"隐私问题".localized,@"其他问题".localized];
    WeakSelf;
    [self.tagView setDidClickTag:^(NSInteger index) {
        weakSelf.type = index+1;
    }];
    [self.tagView selectTagAtIndex:0 animate:YES];
    
    
}


- (NSDictionary *)getParams
{

    if (self.contentTF.text.length == 0) {
        [YQUtils showCenterMessage:@"请输入内容"];
        return nil;
    }
    
    if (![self.codeTF.text isEqualToString:self.codeString]) {
        [YQUtils showCenterMessage:@"验证码错误"];
        return nil;
    }
    
    NSString *images = [self.upload getImages];
    if (images == nil) {
        [YQUtils showCenterMessage:@"正在上传图片, 请稍后"];
        return nil;
    }
    
    NSDictionary *dic = @{@"content":self.contentTF.text,
                          @"imgs":images,
                          @"type":@(self.type)
    };
    return dic;
}
@end
