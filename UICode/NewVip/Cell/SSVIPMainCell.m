//
//  SSVIPMainCell.m

//
//  Created by  on 2025/7/17.

//

#import "SSVIPMainCell.h"
#import "SSActivityVipCell.h"
#import "SSNormalVipCell.h"
#import "SSVIPForPowerCell.h"
#import "VFPayVC.h"
#import "VFTipsView.h"
#import "VFBindMoblieVC.h"

@interface SSVIPMainCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger type;
@end

@implementation SSVIPMainCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.type = type;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    
    self.titleLabel = [UILabel YQLabelWithString:@"" textColor:[UIColor mainTextColor] font:[YQUtils systemSemiboldFontOfSize:15] superView:self.contentView];
    self.titleLabel.frame = CGRectMake(20, 0, ScreenWidth, 38);
    self.contentView.backgroundColor = [UIColor backGroundColor];
    

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 15;
    
    if (self.type == 0) {
        layout.itemSize = CGSizeMake(ScreenWidth - 40, 108);
        layout.minimumLineSpacing = 15;
    }
    else if (self.type == 1) {
        layout.itemSize = CGSizeMake(100, 130);
        layout.minimumLineSpacing = 15;
    }
    else {
        CGFloat w = (ScreenWidth - 40 - 45) / 4.0;
        layout.itemSize = CGSizeMake(w, 74);
        layout.minimumInteritemSpacing = 15;
    }
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.accessibilityIdentifier = @"collection_view";
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.clipsToBounds = YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.contentView addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(38);
        make.bottom.offset(0);
    }];
    
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    if (self.type == 0) {
        [self.collectionView registerClass:SSActivityVipCell.class forCellWithReuseIdentifier:SSActivityVipCell.className];
    }
    else if (self.type == 1) {
        [self.collectionView registerNib:[UINib nibWithNibName:SSNormalVipCell.className bundle:nil] forCellWithReuseIdentifier:SSNormalVipCell.className];
    }
    else {
        [self.collectionView registerNib:[UINib nibWithNibName:SSVIPForPowerCell.className bundle:nil] forCellWithReuseIdentifier:SSVIPForPowerCell.className];
    }
    
}



- (void)setModel:(VFVipModel *)model
{
    _model = model;
    self.titleLabel.text = model.name.localized;
    [self.collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.listArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 0) {
        SSActivityVipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SSActivityVipCell.className forIndexPath:indexPath];
        cell.model = self.model.listArray[indexPath.row];
        return cell;
    }
    if (self.type == 1) {
        SSNormalVipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SSNormalVipCell.className forIndexPath:indexPath];
        cell.model = self.model.listArray[indexPath.row];
        return cell;
    }
    SSVIPForPowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SSVIPForPowerCell.className forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_vip_i%ld",indexPath.row]];
    NSString *title = self.model.listArray[indexPath.row];
    cell.nameLabel.text = title.localized;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 0) {
        CGFloat width = collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right;
        if (width <= 0) {
            width = ScreenWidth - 40;
        }
        return CGSizeMake(width, 60);
    }
    if (self.type == 1) {
        return CGSizeMake(100, 130);
    }
    CGFloat w = (ScreenWidth - 40 - 45) / 4.0;
    return CGSizeMake(w, 74);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.type == 0 || self.type == 1) {
        return 15;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        
        [self.model.listArray enumerateObjectsUsingBlock:^(VFVipModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelectedModel = NO;
        }];
        
        VFVipModel *model = self.model.listArray[indexPath.row];
        model.isSelectedModel = YES;
        [self.collectionView reloadData];
        if (self.selectedModel) {
            self.selectedModel(model);
        }
        
        
    }
    
    if (self.type == 0) {
        VFVipModel *model = self.model.listArray[indexPath.row];
        [self enterVC:model];
    }
}




- (void)enterVC:(VFVipModel *)model
{
    
//    if ([YQUserModel shared].user.tourist == 1 && [QYSettingConfig shared].isReview) {
//        [VFTipsView showView:@"提示" content:@"请先绑定手机或者邮箱" leftBtn:@"取消" rightBtn:@"绑定" block:^(NSInteger code) {
//            if (code == 1) {
//                VFBindMoblieVC *vc = (VFBindMoblieVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFBindMoblieVC"];
//                vc.isBind = YES;
//                vc.isMail = YES;
//                [[YQUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
//            }
//        }];
////        [FCAlert alertTitle:@"请先绑定手机或者邮箱" message:nil btns:@[@"取消",@"绑定"] window:self.view.window block:^(NSInteger index) {
////            if(index == 1001) {
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedSelectedTab" object:@(4)];
////                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushBindVC" object:@(4)];
////                });
////                
////            }
////        }];
//        return;
//    }
    
    VFPayVC *vc = [[VFPayVC alloc] initWithNibName:@"VFPayVC" bundle:nil];
    vc.wxts = self.model.wxts;
    vc.model = model;
    [[YQUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}


@end
