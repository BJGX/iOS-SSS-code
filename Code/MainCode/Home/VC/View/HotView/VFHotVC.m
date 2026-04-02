//
//  VFHotVC.m
//  VFProject
//


//

#import "VFHotVC.h"
#import "VFHotCell.h"
#import "VFTipsView.h"

@interface VFHotVC ()
@property (nonatomic, strong) UIView *backView;
@end

@implementation VFHotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavigationBar:YES];
    [self registerCellWithNib:VFHotCell.className];
    self.view.backgroundColor = rgba(0, 0, 0, 0.3);
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.itemSize = CGSizeMake(70, 100);
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    
    self.backView = [UIView viewWithFrame:CGRectMake(0, ScreenHeight - 300, ScreenWidth, 300) backgroundColor:[UIColor tableBackgroundColor] superView:self.view];
    self.backView.cornerRadius = 10;
    
    NSString *ip = [YQCache getDataFromPlist:@"contactIpString"];
    NSString *title = [NSString stringWithFormat:@"海外热门 IP:%@", ip];
    UILabel *label = [UILabel YQLabelWithString:title textColor:[UIColor whiteColor] font:Font(17) superView:self.backView];
    
    [label setColorAndFontSizeWithString:title font:Font(15) color:[UIColor subTextColor] rang:NSMakeRange(4, title.length - 4)];
    label.frame = CGRectMake(20, 20, 300, 20);
    
    UIButton *setting = [UIButton buttonWithTitle:@"设置" titleColor:[UIColor whiteColor] font:Font(16) backgroundColor:[UIColor clearColor] superView:self.backView btnClick:^(UIButton *btn) {
        [VFTipsView showView:@"不再弹出热门推荐" content:@"可在个人中心设置中重新打开" leftBtn:@"不在弹出" rightBtn:@"暂不提示" block:^(NSInteger code) {
            if (code == 0) {
                [QYSettingConfig shared].openTipsType = 3;
                
            }
            else{
                [QYSettingConfig shared].openTipsType = 1;
            }
        }];
    }];
    setting.cornerRadius = 4;
    setting.borderWidth = 1;
    setting.borderColor = [UIColor whiteColor];
    setting.frame = CGRectMake(ScreenWidth - 100, 0, 60, 25);
    setting.centerY = label.center.y;
    
    UIButton *close = [UIButton buttonWithNormalImage:@"icon_f_close" selectedImage:@"icon_f_close" superView:self.backView btnClick:^(UIButton *btn) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.centerY.mas_equalTo(setting);
        make.height.width.offset(25);
    }];
    
    
    [self.collectionView removeFromSuperview];
    [self.backView addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, 70, ScreenWidth, 200);
    
    [self loadData];
    

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData
{
    NSString *url = @"api/en/mine/hot";
    NSDictionary *dic = [YQCache getCache:url];
    if (dic) {
        self.dataArray = [VFHomeModel mj_objectArrayWithKeyValuesArray:dic];
        [self.collectionView reloadData];
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VFHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VFHotCell.className forIndexPath:indexPath];
    VFHomeModel *model = self.dataArray[indexPath.row];
    [cell.iconView sd_setImageWithURL:imageOfNSURL(model.icon)];
    cell.nameLabel.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VFHomeModel *model = self.dataArray[indexPath.row];
    [YQUtils openUrl:model.url];
//    [self dismissViewControllerAnimated:YES completion:nil];
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
