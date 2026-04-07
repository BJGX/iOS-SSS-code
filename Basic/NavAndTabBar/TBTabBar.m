//
//   TBTabBar.m
   

#import "TBTabBar.h"


@interface TBTabBar()

@property (nonatomic, strong) NSMutableArray *itemArray;


@end
//#import <UITabBar>


@implementation TBTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backImageView.backgroundColor = [UIColor whiteColor];
//        [self.backImageView shadowLayerColor:rgba(17, 25, 36, 0.1)];
    }
    return self;
}

- (UIView *)backImageView
{
    if (!_backImageView) {
        CGFloat width = [DeviceHelper isiPad] ? 100 : 50;
        _backImageView = [UIView viewWithFrame:CGRectMake(0, 0, width, 50) backgroundColor:[UIColor whiteColor]];
//        _backImageView.shadowLayerColor = rgba(217, 217, 217, 0.5);
//        UIRectCorner r = UIRectCornerTopLeft | UIRectCornerTopRight;
//        [YQUtils clipTheViewCornerWithCorner:r andView:_backImageView andCornerRadius:16];
        
        [_backImageView addLiquidGlassView:12 glassColor:[[UIColor appThemeColor] colorWithAlphaComponent:0.8] shadowColor:[[UIColor appThemeColor] colorWithAlphaComponent:1]];
        [self insertSubview:_backImageView atIndex:1];
        
        
        
    }
    return _backImageView;;
}
//
//- (YQCurveView *)curveView
//{
//    if (!_curveView) {
//        _curveView = [YQCurveView viewWithFrame:CGRectMake(0, -11, ScreenWidth, PUB_TABBAR_HEIGHT + 11) backgroundColor:[UIColor clearColor]];
//        [self insertSubview:_curveView atIndex:1];
//        _curveView.color = rgb(230, 230, 230);
//        _curveView.waveHeight = 13;
//        
//    }
//    return _curveView;
//}


- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    NSInteger index = -1;
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            index+=1;
            if (index == selectIndex) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.backImageView.center = sub.center;
                }];
                break;
            }
        }
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.subviews.firstObject.hidden = YES;

//    for (UIView *sub in self.subviews) {
//        if ([sub isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            CGRect frame = sub.frame;
//            frame.origin.y = 11;
//            sub.frame = frame;
//        }
//    }
}


//- (void)createUI{
//    if (self.itemArray.count > 0) {
//        return;
//    }
//    
//    
//    
////    CGFloat width = ScreenWidth / self.items.count / 1.0;
////    for (int i = 0; i < self.items.count; i++) {
////        UITabBarItem *item = self.items[i];
////        UIButton *btn = [UIButton buttonWithTitle:item.title titleColor:rgba(170,191,212,1) font:Font(13)];
////        [btn setImage:item.image forState:0];
////        [btn setImage:item.selectedImage forState:UIControlStateSelected];
////        [btn setImage:item.selectedImage forState:UIControlStateHighlighted];
////        [btn setTitleColor:kBlackColor forState:UIControlStateSelected];
////        [btn addTarget:self action:@selector(tabbarSelected:) forControlEvents:UIControlEventTouchUpInside];
////        [self addSubview:btn];
////        btn.frame = CGRectMake(i * width, 7, width, 44);
////        btn.rightTitleAndLeftImageWithSpace = 3;
////        btn.tag = 100 + i;
////        if (i == 0) {
////            btn.selected = YES;
////        }
////        [self.itemArray addObject:btn];
////    }
//    
//}
//
//- (void)setSelectIndex:(NSInteger)selectIndex{
//    _selectIndex = selectIndex;
//    UIButton *sender = self.itemArray[selectIndex];
//    [self tabbarSelected:sender];
//}
//
//- (void)tabbarSelected:(UIButton *)sender
//{
//    for (UIButton *btn in self.itemArray) {
//        btn.selected = NO;
//    }
//    sender.selected = YES;
//    if (self.didSelectedTabbar) {
//        self.didSelectedTabbar(sender.tag - 100, sender.currentTitle);
//    }
//}
//




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
 /miniprogram_npm/tdesign-miniprogram/.wechatide.ib.json: 75.03 KB
 /miniprogram_npm/lodash/index.js: 71.44 KB
 /miniprogram_npm/mobx-miniprogram/index.js: 52.03 KB
 /miniprogram_npm/tdesign-miniprogram/icon/icon.wxss: 51.02 KB
 /assets/svg/empty.svg: 20.96 KB
 /miniprogram_npm/tdesign-miniprogram/button/button.wxss: 20.53 KB
 /static/staging/already.png: 16.09 KB
 /pages/staging/finance/finance.js: 15.58 KB
 /pages/instrumentEquip/index.js: 13.90 KB
 /pages/staging/finance/finance.wxml: 12.57 KB
 /pages/staging/invoice/collect/collect.js: 11.55 KB
 /static/staging/experimentalReagents.png: 10.99 KB
 /static/staging/agreementPact.png: 10.57 KB
 /miniprogram_npm/tdesign-miniprogram/common/style/theme/_index.wxss: 10.24 KB
 /static/staging/experiment.png: 10.24 KB
 /miniprogram_npm/tdesign-miniprogram/tag/tag.wxss: 10.15 KB
 /pages/instrumentEquip/create/index.js: 9.89 KB
 /pages/instrumentEquip/index.wxml: 9.73 KB
 /miniprogram_npm/tdesign-miniprogram/check-tag/check-tag.wxss: 9.67 KB
 /miniprogram_npm/tdesign-miniprogram/upload/README.md: 9.67 KB
 /pages/equipmentParts/index.js: 9.51 KB
 /static/staging/customerResource.png: 9.46 KB
 /miniprogram_npm/tdesign-miniprogram/input/README.md: 9.34 KB
 /static/staging/equipmentPart.png: 9.33 KB
 /miniprogram_npm/tdesign-miniprogram/guide/guide.js: 9.25 KB
 /pages/labConsumables/index.js: 9.09 KB
 /miniprogram_npm/miniprogram-computed/index.js: 9.08 KB
 /pages/staging/finance/finance.wxss: 8.98 KB
 /miniprogram_npm/tdesign-miniprogram/slider/slider.js: 8.98 KB
 /pages/instrumentEquip/index.wxss: 8.89 KB
 /static/staging/invoiceManage.png: 8.73 KB
 /static/staging/instrument.png: 8.66 KB
 /miniprogram_npm/tdesign-miniprogram/upload/upload.js: 8.64 KB
 /pages/equipmentParts/index.wxss: 8.62 KB
 /pages/LRlist/index.js: 8.58 KB
 /pages/staging/invoice/collect/collect.wxml: 8.51 KB
 /miniprogram_npm/tdesign-miniprogram/guide/README.md: 8.50 KB
 /pages/equipmentParts/create/index.js: 8.46 KB
 /pages/equipmentParts/index.wxml: 8.37 KB
 /pages/erInventory/erInventory.js: 8.35 KB
 /pages/labConsumables/index.wxml: 8.17 KB
 /pages/LRlist/index.wxss: 8.12 KB
 /pages/labConsumables/index.wxss: 7.93 KB
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/date-time-picker.js: 7.89 KB
 /pages/labConsumables/create/index.js: 7.80 KB
 /pages/LRlist/index.wxml: 7.70 KB
 /pages/LRlist/create/index.wxml: 7.69 KB
 /pages/LRlist/create/index.js: 7.67 KB
 /miniprogram_npm/dayjs/index.js: 7.65 KB
 /pages/labConsumables/create/index.wxml: 7.61 KB
 /miniprogram_npm/tdesign-miniprogram/cascader/cascader.js: 7.55 KB
 /pages/index/approve/approve.js: 7.45 KB
 /components/process-render/index.js: 7.37 KB
 /static/staging/financialManage.png: 7.36 KB
 /miniprogram_npm/tdesign-miniprogram/slider/slider.wxss: 7.32 KB
 /pages/index/approve/approve.wxml: 7.24 KB
 /pages/staging/invoice/openr/openr.js: 7.21 KB
 /pages/staging/invoice/collect/collect.wxss: 7.16 KB
 /miniprogram_npm/tdesign-miniprogram/upload/drag.wxs: 7.09 KB
 /miniprogram_npm/tdesign-miniprogram/miniprogram_npm/dayjs/index.js: 7.08 KB
 /assets/images/logo.png: 7.03 KB
 /miniprogram_npm/tdesign-miniprogram/tabs/README.md: 6.89 KB
 /pages/staging/invoice/openr/openr.wxss: 6.88 KB
 /pages/LRlist/detail/index.wxml: 6.82 KB
 /pages/staging/invoice/openr/openr.wxml: 6.74 KB
 /miniprogram_npm/tdesign-miniprogram/steps/README.md: 6.70 KB
 /miniprogram_npm/tdesign-miniprogram/step-item/step-item.wxss: 6.63 KB
 /miniprogram_npm/tdesign-miniprogram/swiper/README.md: 6.61 KB
 /@babel/runtime/helpers/regeneratorRuntime.js: 6.61 KB
 /miniprogram_npm/tdesign-miniprogram/upload/upload.wxml: 6.42 KB
 /miniprogram_npm/tdesign-miniprogram/tag/README.md: 6.40 KB
 /miniprogram_npm/tdesign-miniprogram/picker/README.md: 6.39 KB
 /miniprogram_npm/tdesign-miniprogram/tabs/tabs.js: 6.35 KB
 /miniprogram_npm/mobx-miniprogram-bindings/index.js: 6.33 KB
 /pages/instrumentEquip/detail/index.wxml: 6.33 KB
 /miniprogram_npm/tdesign-miniprogram/dialog/README.md: 6.20 KB
 /pages/instrumentEquip/create/index.wxml: 6.09 KB
 /miniprogram_npm/tdesign-miniprogram/search/README.md: 6.04 KB
 /miniprogram_npm/tdesign-miniprogram/radio/README.md: 6.04 KB
 /pages/index/index.js: 6.00 KB
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/README.md: 5.93 KB
 /pages/equipmentParts/detail/index.wxml: 5.79 KB
 /pages/index/index.wxss: 5.75 KB
 /miniprogram_npm/tdesign-miniprogram/message/README.md: 5.71 KB
 /miniprogram_npm/tdesign-miniprogram/checkbox/checkbox.wxss: 5.62 KB
 /pages/index/approve/approveDetail/approveDetail.wxml: 5.62 KB
 /miniprogram_npm/tdesign-miniprogram/textarea/README.md: 5.55 KB
 /miniprogram_npm/tdesign-miniprogram/upload/README.en-US.md: 5.54 KB
 /pages/equipmentParts/create/index.wxml: 5.47 KB
 /miniprogram_npm/tdesign-miniprogram/radio/radio.wxss: 5.47 KB
 /miniprogram_npm/tdesign-miniprogram/dropdown-menu/README.md: 5.39 KB
 /pages/labConsumables/detail/index.wxml: 5.38 KB
 /miniprogram_npm/tdesign-miniprogram/slider/README.md: 5.36 KB
 /pages/LRlist/multipCreate/index.js: 5.28 KB
 /miniprogram_npm/tdesign-miniprogram/indexes/indexes.js: 5.25 KB
 /components/org-picker/index.js: 5.19 KB
 /miniprogram_npm/tdesign-miniprogram/loading/loading.wxss: 5.18 KB
 /miniprogram_npm/tdesign-miniprogram/notice-bar/README.md: 5.17 KB
 /components/process-render/index.wxml: 5.10 KB
 /miniprogram_npm/tdesign-miniprogram/slider/slider.wxml: 5.10 KB
 /miniprogram_npm/tdesign-miniprogram/grid/README.md: 5.09 KB
 /miniprogram_npm/tdesign-miniprogram/pull-down-refresh/pull-down-refresh.js: 5.04 KB
 /miniprogram_npm/tdesign-miniprogram/tabs/tabs.wxss: 4.97 KB
 /miniprogram_npm/tdesign-miniprogram/switch/switch.wxss: 4.96 KB
 /miniprogram_npm/tdesign-miniprogram/input/input.wxss: 4.85 KB
 /miniprogram_npm/tdesign-miniprogram/pull-down-refresh/README.md: 4.80 KB
 /miniprogram_npm/tdesign-miniprogram/common/style/theme/_light.wxss: 4.76 KB
 /miniprogram_npm/tdesign-miniprogram/message-item/message-item.js: 4.76 KB
 /pages/equipmentParts/multipCreate/index.js: 4.76 KB
 /pages/instrumentEquip/create/index.wxss: 4.74 KB
 /components/actions/index.js: 4.74 KB
 /miniprogram_npm/tdesign-miniprogram/swipe-cell/swipe-cell.wxs: 4.74 KB
 /miniprogram_npm/tdesign-miniprogram/common/utils.js: 4.73 KB
 /miniprogram_npm/tdesign-miniprogram/guide/README.en-US.md: 4.73 KB
 /pages/instrumentEquip/multipCreate/index.js: 4.68 KB
 /miniprogram_npm/tdesign-miniprogram/notice-bar/notice-bar.js: 4.68 KB
 /miniprogram_npm/tdesign-miniprogram/progress/progress.wxss: 4.66 KB
 /miniprogram_npm/tdesign-miniprogram/icon/README.md: 4.64 KB
 /miniprogram_npm/tdesign-miniprogram/link/link.wxss: 4.62 KB
 /store/index.js: 4.58 KB
 /miniprogram_npm/tdesign-miniprogram/calendar/calendar.wxss: 4.58 KB
 /miniprogram_npm/tdesign-miniprogram/common/style/theme/_dark.wxss: 4.57 KB
 /miniprogram_npm/tdesign-miniprogram/indexes/README.md: 4.54 KB
 /components/uploadFile/index.js: 4.49 KB
 /miniprogram_npm/tdesign-miniprogram/drawer/README.md: 4.48 KB
 /pages/LRlist/create/index.wxss: 4.45 KB
 /miniprogram_npm/tdesign-miniprogram/switch/README.md: 4.42 KB
 /miniprogram_npm/tdesign-miniprogram/message/message.js: 4.37 KB
 /pages/equipmentParts/create/index.wxss: 4.34 KB
 /pages/labConsumables/create/index.wxss: 4.34 KB
 /pages/labConsumables/multipCreate/index.js: 4.25 KB
 /miniprogram_npm/tdesign-miniprogram/progress/README.md: 4.23 KB
 /miniprogram_npm/tdesign-miniprogram/checkbox-group/checkbox-group.js: 4.15 KB
 /pages/index/approve/approve.wxss: 4.14 KB
 /miniprogram_npm/tdesign-miniprogram/rate/README.md: 4.12 KB
 /miniprogram_npm/tdesign-miniprogram/footer/README.md: 4.11 KB
 /miniprogram_npm/tdesign-miniprogram/input/README.en-US.md: 4.11 KB
 /miniprogram_npm/tdesign-miniprogram/count-down/count-down.wxss: 4.11 KB
 /miniprogram_npm/tdesign-miniprogram/tab-bar/README.md: 4.10 KB
 /miniprogram_npm/tdesign-miniprogram/dialog/dialog.js: 4.08 KB
 /miniprogram_npm/tdesign-miniprogram/image-viewer/README.md: 4.08 KB
 /miniprogram_npm/tdesign-miniprogram/navbar/navbar.js: 4.07 KB
 /miniprogram_npm/tdesign-miniprogram/result/README.md: 4.05 KB
 /miniprogram_npm/tdesign-miniprogram/calendar/calendar.js: 4.04 KB
 /miniprogram_npm/tdesign-miniprogram/navbar/README.md: 4.03 KB
 /miniprogram_npm/tdesign-miniprogram/picker/README.en-US.md: 4.02 KB
 /miniprogram_npm/tdesign-miniprogram/link/README.md: 4.02 KB
 /miniprogram_npm/tdesign-miniprogram/skeleton/README.md: 3.99 KB
 /miniprogram_npm/tdesign-miniprogram/dropdown-item/dropdown-item.js: 3.97 KB
 /miniprogram_npm/tdesign-miniprogram/action-sheet/action-sheet.wxss: 3.92 KB
 /miniprogram_npm/tdesign-miniprogram/popup/README.md: 3.90 KB
 /miniprogram_npm/tdesign-miniprogram/tag/README.en-US.md: 3.88 KB
 /miniprogram_npm/tdesign-miniprogram/image/README.md: 3.82 KB
 /miniprogram_npm/rfdc/index.js: 3.78 KB
 /miniprogram_npm/tdesign-miniprogram/image-viewer/image-viewer.js: 3.74 KB
 /miniprogram_npm/tdesign-miniprogram/guide/guide.wxss: 3.71 KB
 /pages/staging/staging.js: 3.70 KB
 /miniprogram_npm/tdesign-miniprogram/input/input.js: 3.70 KB
 /miniprogram_npm/tdesign-miniprogram/collapse-panel/collapse-panel.wxss: 3.69 KB
 /miniprogram_npm/tdesign-miniprogram/picker/picker.js: 3.68 KB
 /miniprogram_npm/tdesign-miniprogram/common/src/instantiationDecorator.js: 3.66 KB
 /miniprogram_npm/tdesign-miniprogram/cascader/cascader.wxss: 3.65 KB
 /miniprogram_npm/tdesign-miniprogram/swiper-nav/swiper-nav.wxss: 3.63 KB
 /miniprogram_npm/tdesign-miniprogram/tab-bar-item/tab-bar-item.wxss: 3.59 KB
 /miniprogram_npm/tdesign-miniprogram/grid-item/grid-item.js: 3.58 KB
 /miniprogram_npm/tdesign-miniprogram/progress/progress.wxml: 3.54 KB
 /miniprogram_npm/tdesign-miniprogram/count-down/README.md: 3.46 KB
 /miniprogram_npm/tdesign-miniprogram/picker-item/picker-item.js: 3.46 KB
 /miniprogram_npm/tdesign-miniprogram/toast/README.md: 3.46 KB
 /pages/staging/agreement/agreement.wxss: 3.44 KB
 /miniprogram_npm/tdesign-miniprogram/grid-item/grid-item.wxss: 3.43 KB
 /miniprogram_npm/tdesign-miniprogram/avatar-group/avatar-group.wxss: 3.43 KB
 /miniprogram_npm/tdesign-miniprogram/loading/README.md: 3.41 KB
 /pages/staging/customer/customerResource.wxss: 3.35 KB
 /miniprogram_npm/tdesign-miniprogram/fab/draggable/draggable.js: 3.35 KB
 /miniprogram_npm/tdesign-miniprogram/steps/README.en-US.md: 3.35 KB
 /miniprogram_npm/tdesign-miniprogram/stepper/stepper.js: 3.34 KB
 /miniprogram_npm/tdesign-miniprogram/tab-bar-item/tab-bar-item.js: 3.33 KB
 /miniprogram_npm/tdesign-miniprogram/upload/upload.wxss: 3.33 KB
 /pages/staging/invoice/invoice.js: 3.33 KB
 /miniprogram_npm/tdesign-miniprogram/cell/cell.wxss: 3.33 KB
 /miniprogram_npm/tdesign-miniprogram/action-sheet/action-sheet.js: 3.33 KB
 /miniprogram_npm/tdesign-miniprogram/swipe-cell/README.md: 3.32 KB
 /pages/staging/agreement/agreement.js: 3.26 KB
 /miniprogram_npm/tdesign-miniprogram/skeleton/skeleton.js: 3.25 KB
 /pages/index/index.wxml: 3.24 KB
 /miniprogram_npm/tdesign-miniprogram/sticky/sticky.js: 3.24 KB
 /miniprogram_npm/tdesign-miniprogram/upload/upload-info.json: 3.18 KB
 /miniprogram_npm/tdesign-miniprogram/rate/rate.js: 3.18 KB
 /miniprogram_npm/tdesign-miniprogram/radio-group/radio-group.js: 3.15 KB
 /pages/erInventory/erInventory.wxml: 3.12 KB
 /miniprogram_npm/tdesign-miniprogram/textarea/textarea.js: 3.12 KB
 /miniprogram_npm/tdesign-miniprogram/tree-select/README.md: 3.11 KB
 /miniprogram_npm/tdesign-miniprogram/button/button.js: 3.11 KB
 /miniprogram_npm/tdesign-miniprogram/tabs/README.en-US.md: 3.09 KB
 /miniprogram_npm/tdesign-miniprogram/fab/README.md: 3.08 KB
 /miniprogram_npm/tdesign-miniprogram/rate/rate.wxml: 3.07 KB
 /miniprogram_npm/tdesign-miniprogram/swiper/README.en-US.md: 3.04 KB
 /miniprogram_npm/tdesign-miniprogram/rate/rate.wxss: 3.02 KB
 /miniprogram_npm/tdesign-miniprogram/stepper/README.md: 3.01 KB
 /pages/index/approve/approveDetail/approveDetail.wxss: 3.00 KB
 /miniprogram_npm/tdesign-miniprogram/radio/radio.js: 2.98 KB
 /pages/staging/invoice/invoice.wxml: 2.98 KB
 /miniprogram_npm/tdesign-miniprogram/collapse-panel/collapse-panel.js: 2.96 KB
 /miniprogram_npm/tdesign-miniprogram/search/search.js: 2.95 KB
 /miniprogram_npm/tdesign-miniprogram/dialog/README.en-US.md: 2.94 KB
 /miniprogram_npm/tdesign-miniprogram/tree-select/tree-select.js: 2.94 KB
 /miniprogram_npm/tdesign-miniprogram/side-bar/README.md: 2.93 KB
 /miniprogram_npm/tdesign-miniprogram/navbar/navbar.wxss: 2.93 KB
 /utils/common.wxs: 2.92 KB
 /miniprogram_npm/tdesign-miniprogram/input/input.wxml: 2.92 KB
 /miniprogram_npm/tdesign-miniprogram/radio/README.en-US.md: 2.91 KB
 /miniprogram_npm/tdesign-miniprogram/skeleton/skeleton.wxss: 2.89 KB
 /components/formRender/modules/select/index.js: 2.88 KB
 /miniprogram_npm/tdesign-miniprogram/toast/toast.js: 2.86 KB
 /miniprogram_npm/tdesign-miniprogram/stepper/stepper.wxss: 2.85 KB
 /miniprogram_npm/tdesign-miniprogram/swiper/swiper.js: 2.84 KB
 /miniprogram_npm/tdesign-miniprogram/search/search.wxss: 2.84 KB
 /miniprogram_npm/tdesign-miniprogram/dialog/dialog.wxss: 2.83 KB
 /miniprogram_npm/tdesign-miniprogram/common/utils.wxs: 2.81 KB
 /miniprogram_npm/tdesign-miniprogram/dropdown-menu/README.en-US.md: 2.79 KB
 /miniprogram_npm/tdesign-miniprogram/overlay/README.md: 2.78 KB
 /pages/staging/customer/addCustomer/addCustomer.wxml: 2.77 KB
 /miniprogram_npm/tdesign-miniprogram/image/image.js: 2.77 KB
 /miniprogram_npm/tdesign-miniprogram/count-down/count-down.js: 2.76 KB
 /miniprogram_npm/tdesign-miniprogram/checkbox/checkbox.js: 2.74 KB
 /miniprogram_npm/tdesign-miniprogram/tabs/tabs.wxml: 2.74 KB
 /miniprogram_npm/tdesign-miniprogram/swipe-cell/swipe-cell.js: 2.74 KB
 /miniprogram_npm/tdesign-miniprogram/search/README.en-US.md: 2.73 KB
 /miniprogram_npm/tdesign-miniprogram/tag/tag.js: 2.72 KB
 /miniprogram_npm/tdesign-miniprogram/dropdown-menu/dropdown-menu.js: 2.72 KB
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/README.en-US.md: 2.71 KB
 /miniprogram_npm/tdesign-miniprogram/badge/badge.wxss: 2.71 KB
 /miniprogram_npm/tdesign-miniprogram/icon/icon.js: 2.71 KB
 /app.json: 2.68 KB
 /miniprogram_npm/tdesign-miniprogram/progress/progress.js: 2.64 KB
 /miniprogram_npm/tdesign-miniprogram/fab/fab.js: 2.62 KB
 /miniprogram_npm/tdesign-miniprogram/dropdown-item/dropdown-item.wxml: 2.61 KB
 /miniprogram_npm/tdesign-miniprogram/common/shared/calendar/index.js: 2.61 KB
 /miniprogram_npm/tdesign-miniprogram/cell/cell.js: 2.60 KB
 /miniprogram_npm/tdesign-miniprogram/picker/picker.wxss: 2.59 KB
 /miniprogram_npm/tdesign-miniprogram/link/link.js: 2.58 KB
 /miniprogram_npm/tdesign-miniprogram/switch/README.en-US.md: 2.56 KB
 /miniprogram_npm/tdesign-miniprogram/divider/README.md: 2.56 KB
 /miniprogram_npm/tdesign-miniprogram/grid-item/grid-item.wxml: 2.49 KB
 /miniprogram_npm/tdesign-miniprogram/avatar-group/avatar-group.js: 2.47 KB
 /miniprogram_npm/tdesign-miniprogram/avatar/avatar.wxss: 2.46 KB
 /miniprogram_npm/tdesign-miniprogram/check-tag/check-tag.js: 2.45 KB
 /miniprogram_npm/tdesign-miniprogram/sticky/README.md: 2.44 KB
 /miniprogram_npm/tdesign-miniprogram/notice-bar/notice-bar.wxss: 2.44 KB
 /miniprogram_npm/tdesign-miniprogram/message/README.en-US.md: 2.43 KB
 /miniprogram_npm/tdesign-miniprogram/empty/README.md: 2.43 KB
 /miniprogram_npm/tdesign-miniprogram/dropdown-item/dropdown-item.wxss: 2.42 KB
 /miniprogram_npm/tdesign-miniprogram/side-bar-item/side-bar-item.wxss: 2.42 KB
 /pages/login/login.js: 2.41 KB
 /miniprogram_npm/tdesign-miniprogram/grid/README.en-US.md: 2.39 KB
 /miniprogram_npm/tdesign-miniprogram/back-top/back-top.wxss: 2.37 KB
 /pages/test/page.js: 2.37 KB
 /miniprogram_npm/tdesign-miniprogram/message-item/message-item.wxss: 2.36 KB
 /pages/login/login.wxml: 2.35 KB
 /miniprogram_npm/tdesign-miniprogram/popup/popup.wxss: 2.35 KB
 /miniprogram_npm/tdesign-miniprogram/miniprogram_npm/dayjs/locale/ru.js: 2.35 KB
 /miniprogram_npm/tdesign-miniprogram/step-item/step-item.js: 2.33 KB
 /miniprogram_npm/tdesign-miniprogram/mixins/transition.js: 2.32 KB
 /components/search-bar/index.js: 2.30 KB
 /components/inventoryCard/inventoryCard.wxml: 2.29 KB
 /miniprogram_npm/tdesign-miniprogram/tab-bar/tab-bar.js: 2.29 KB
 /api/process.js: 2.29 KB
 /miniprogram_npm/tdesign-miniprogram/avatar/avatar.js: 2.29 KB
 /miniprogram_npm/tdesign-miniprogram/slider/README.en-US.md: 2.28 KB
 /miniprogram_npm/tdesign-miniprogram/grid/grid.js: 2.28 KB
 /components/formRender/index.wxml: 2.27 KB
 /pages/instrumentEquip/detail/index.wxss: 2.25 KB
 /miniprogram_npm/tdesign-miniprogram/back-top/back-top.js: 2.25 KB
 /api/lyLists/equipmentParts.js: 2.24 KB
 /miniprogram_npm/tdesign-miniprogram/steps/steps.js: 2.24 KB
 /api/lyLists/instrumentEquip.js: 2.24 KB
 /miniprogram_npm/tdesign-miniprogram/textarea/textarea.wxss: 2.23 KB
 /components/formRender/modules/cascader/index.js: 2.23 KB
 /api/org.js: 2.22 KB
 /pages/LRlist/detail/index.wxss: 2.22 KB
 /pages/equipmentParts/detail/index.wxss: 2.22 KB
 /pages/labConsumables/detail/index.wxss: 2.22 KB
 /miniprogram_npm/tdesign-miniprogram/dialog/index.js: 2.21 KB
 /miniprogram_npm/tdesign-miniprogram/drawer/drawer.wxss: 2.20 KB
 /miniprogram_npm/tdesign-miniprogram/footer/footer.wxss: 2.19 KB
 /miniprogram_npm/tdesign-miniprogram/tab-bar-item/tab-bar-item.wxml: 2.15 KB
 /pages/LRlist/detail/index.js: 2.15 KB
 /miniprogram_npm/tdesign-miniprogram/calendar/template.wxml: 2.15 KB
 /pages/staging/agreement/agreement.wxml: 2.15 KB
 /pages/mine/mine.js: 2.14 KB
 /miniprogram_npm/tdesign-miniprogram/miniprogram_npm/dayjs/plugin/localeData.js: 2.12 KB
 /api/lyLists/labConsumables.js: 2.11 KB
 /api/lyLists/ly.js: 2.11 KB
 /miniprogram_npm/tdesign-miniprogram/tab-panel/tab-panel.js: 2.11 KB
 /miniprogram_npm/tdesign-miniprogram/checkbox/checkbox.wxml: 2.11 KB
 /miniprogram_npm/tdesign-miniprogram/side-bar/side-bar.js: 2.09 KB
 /components/process-render/index.wxss: 2.08 KB
 /miniprogram_npm/tdesign-miniprogram/notice-bar/README.en-US.md: 2.07 KB
 /miniprogram_npm/tdesign-miniprogram/footer/README.en-US.md: 2.07 KB
 /miniprogram_npm/tdesign-miniprogram/search/search.wxml: 2.06 KB
 /pages/mine/editPassword/index.js: 2.06 KB
 /miniprogram_npm/tdesign-miniprogram/collapse/collapse.js: 2.05 KB
 /pages/erInventory/erInventory.wxss: 2.05 KB
 /miniprogram_npm/tdesign-miniprogram/side-bar-item/side-bar-item.js: 2.04 KB
 /miniprogram_npm/tdesign-miniprogram/button/button.wxml: 2.04 KB
 /miniprogram_npm/tdesign-miniprogram/drawer/README.en-US.md: 2.04 KB
 /miniprogram_npm/tdesign-miniprogram/result/result.js: 2.02 KB
 /miniprogram_npm/tdesign-miniprogram/loading/loading.js: 2.02 KB
 /miniprogram_npm/tdesign-miniprogram/switch/switch.js: 2.02 KB
 /pages/staging/staging.wxml: 2.01 KB
 /miniprogram_npm/tdesign-miniprogram/popup/popup.js: 2.01 KB
 /miniprogram_npm/tdesign-miniprogram/toast/toast.wxss: 2.01 KB
 /miniprogram_npm/tdesign-miniprogram/swiper-nav/swiper-nav.js: 2.00 KB
 /pages/instrumentEquip/detail/index.js: 2.00 KB
 /api/material/inventory.js: 1.99 KB
 /miniprogram_npm/tdesign-miniprogram/tab-bar/README.en-US.md: 1.99 KB
 /miniprogram_npm/tdesign-miniprogram/col/col.wxss: 1.98 KB
 /miniprogram_npm/tdesign-miniprogram/image-viewer/image-viewer.wxss: 1.98 KB
 /miniprogram_npm/tdesign-miniprogram/tree-select/tree-select.wxml: 1.97 KB
 /miniprogram_npm/tdesign-miniprogram/cascader/cascader.wxml: 1.97 KB
 /miniprogram_npm/tdesign-miniprogram/drawer/drawer.js: 1.96 KB
 /miniprogram_npm/tdesign-miniprogram/indexes/README.en-US.md: 1.96 KB
 /miniprogram_npm/tdesign-miniprogram/overlay/overlay.js: 1.95 KB
 /miniprogram_npm/tdesign-miniprogram/loading/loading.wxml: 1.95 KB
 /miniprogram_npm/tdesign-miniprogram/badge/badge.wxs: 1.94 KB
 /miniprogram_npm/tdesign-miniprogram/dialog/dialog.wxml: 1.94 KB
 /miniprogram_npm/tdesign-miniprogram/pull-down-refresh/README.en-US.md: 1.94 KB
 /miniprogram_npm/tdesign-miniprogram/popup/README.en-US.md: 1.93 KB
 /miniprogram_npm/tdesign-miniprogram/radio/radio.wxml: 1.91 KB
 /pages/erTask/erTask.js: 1.89 KB
 /miniprogram_npm/tdesign-miniprogram/indexes/indexes.wxss: 1.89 KB
 /pages/staging/customer/customerResource.wxml: 1.89 KB
 /miniprogram_npm/tdesign-miniprogram/dropdown-menu/dropdown-menu.wxss: 1.89 KB
 /miniprogram_npm/tdesign-miniprogram/badge/badge.js: 1.87 KB
 /pages/login/login.wxss: 1.87 KB
 /miniprogram_npm/tdesign-miniprogram/divider/divider.wxss: 1.87 KB
 /miniprogram_npm/tdesign-miniprogram/cell-group/cell-group.js: 1.86 KB
 /pages/staging/staging.wxss: 1.85 KB
 /pages/staging/invoice/invoice.wxss: 1.84 KB
 /miniprogram_npm/tdesign-miniprogram/cell/cell.wxml: 1.83 KB
 /miniprogram_npm/tdesign-miniprogram/divider/divider.js: 1.82 KB
 /pages/staging/customer/addCustomer/addCustomer.js: 1.82 KB
 /pages/labConsumables/detail/index.js: 1.81 KB
 /miniprogram_npm/tdesign-miniprogram/pull-down-refresh/pull-down-refresh.wxml: 1.81 KB
 /miniprogram_npm/tdesign-miniprogram/result/result.wxss: 1.79 KB
 /miniprogram_npm/tdesign-miniprogram/navbar/README.en-US.md: 1.78 KB
 /pages/equipmentParts/detail/index.js: 1.78 KB
 /miniprogram_npm/tdesign-miniprogram/empty/empty.js: 1.78 KB
 /miniprogram_npm/tdesign-miniprogram/row/row.js: 1.78 KB
 /components/signature/signature.js: 1.77 KB
 /miniprogram_npm/tdesign-miniprogram/rate/rate.wxs: 1.77 KB
 /miniprogram_npm/tdesign-miniprogram/progress/README.en-US.md: 1.76 KB
 /miniprogram_npm/tdesign-miniprogram/avatar/avatar.wxml: 1.75 KB
 /miniprogram_npm/tdesign-miniprogram/message-item/message-item.wxml: 1.75 KB
 /components/org-picker/index.wxml: 1.75 KB
 /miniprogram_npm/tdesign-miniprogram/swiper/swiper.wxml: 1.73 KB
 /miniprogram_npm/tdesign-miniprogram/step-item/step-item.wxml: 1.69 KB
 /pages/erList/erList.wxml: 1.68 KB
 /miniprogram_npm/tdesign-miniprogram/link/README.en-US.md: 1.67 KB
 /miniprogram_npm/tdesign-miniprogram/textarea/README.en-US.md: 1.67 KB
 /static/tabbar/mine.png: 1.67 KB
 /static/tabbar/个人中心-选中@2x.png: 1.67 KB
 /miniprogram_npm/tdesign-miniprogram/indexes-anchor/indexes-anchor.js: 1.66 KB
 /miniprogram_npm/tdesign-miniprogram/result/README.en-US.md: 1.65 KB
 /miniprogram_npm/tdesign-miniprogram/cell-group/cell-group.wxss: 1.64 KB
 /miniprogram_npm/tdesign-miniprogram/image-viewer/image-viewer.wxml: 1.64 KB
 /miniprogram_npm/tdesign-miniprogram/image/image.wxml: 1.63 KB
 /miniprogram_npm/tdesign-miniprogram/indexes-anchor/indexes-anchor.wxss: 1.62 KB
 /miniprogram_npm/tdesign-miniprogram/toast/README.en-US.md: 1.62 KB
 /miniprogram_npm/tdesign-miniprogram/skeleton/README.en-US.md: 1.61 KB
 /miniprogram_npm/tdesign-miniprogram/col/col.js: 1.61 KB
 /miniprogram_npm/tdesign-miniprogram/swipe-cell/swipe-cell.wxml: 1.60 KB
 /miniprogram_npm/tdesign-miniprogram/notice-bar/notice-bar.wxml: 1.59 KB
 /miniprogram_npm/tdesign-miniprogram/progress/progress.wxs: 1.59 KB
 /miniprogram_npm/tdesign-miniprogram/overlay/README.en-US.md: 1.59 KB
 /miniprogram_npm/tdesign-miniprogram/rate/README.en-US.md: 1.58 KB
 /package-lock.json: 1.58 KB
 /miniprogram_npm/tdesign-miniprogram/transition/transition.js: 1.58 KB
 /miniprogram_npm/tdesign-miniprogram/footer/footer.js: 1.57 KB
 /miniprogram_npm/tdesign-miniprogram/input/props.js: 1.56 KB
 /miniprogram_npm/tdesign-miniprogram/action-sheet/action-sheet.wxml: 1.56 KB
 /components/actions/index.wxml: 1.56 KB
 /miniprogram_npm/tdesign-miniprogram/image/image-info.json: 1.56 KB
 /miniprogram_npm/tdesign-miniprogram/common/src/flatTool.js: 1.55 KB
 /utils/util.js: 1.54 KB
 /static/tabbar/首页-选中@2x.png: 1.54 KB
 /miniprogram_npm/tdesign-miniprogram/link/link.wxml: 1.54 KB
 /miniprogram_npm/tdesign-miniprogram/action-sheet/template/grid.wxml: 1.53 KB
 /components/my-picker/index.js: 1.53 KB
 /miniprogram_npm/tdesign-miniprogram/miniprogram_npm/dayjs/locale/zh-cn.js: 1.52 KB
 /miniprogram_npm/tdesign-miniprogram/textarea/textarea.wxml: 1.52 KB
 /miniprogram_npm/tdesign-miniprogram/tree-select/README.en-US.md: 1.51 KB
 /api/operate/finance.js: 1.50 KB
 /pages/staging/customer/customerResource.js: 1.50 KB
 /miniprogram_npm/tdesign-miniprogram/toast/toast.wxml: 1.49 KB
 /miniprogram_npm/tdesign-miniprogram/miniprogram_npm/dayjs/locale/zh-tw.js: 1.49 KB
 /miniprogram_npm/tdesign-miniprogram/tab-bar/tab-bar.wxss: 1.47 KB
 /miniprogram_npm/tdesign-miniprogram/stepper/stepper.wxml: 1.43 KB
 /components/process-render/methods.wxs: 1.43 KB
 /api/operate/invoice.js: 1.42 KB
 /utils/request2.js: 1.40 KB
 /components/inventoryCard/inventoryCard.wxss: 1.40 KB
 /miniprogram_npm/tdesign-miniprogram/tree-select/tree-select.wxss: 1.39 KB
 /miniprogram_npm/tdesign-miniprogram/transition/README.md: 1.39 KB
 /utils/auth.js: 1.37 KB
 /miniprogram_npm/fast-deep-equal/index.js: 1.36 KB
 /miniprogram_npm/tdesign-miniprogram/miniprogram_npm/dayjs/locale/ko.js: 1.36 KB
 /pages/instrumentEquip/index.json: 1.35 KB
 /pages/erList/erList.wxss: 1.34 KB
 /static/tabbar/个人中心-未选中@2x.png: 1.34 KB
 /miniprogram_npm/tdesign-miniprogram/collapse-panel/collapse-panel.wxml: 1.33 KB
 /miniprogram_npm/tdesign-miniprogram/miniprogram_npm/dayjs/locale/ja.js: 1.33 KB
 /static/tabbar/工作台选中@2x.png: 1.32 KB
 /miniprogram_npm/tdesign-miniprogram/side-bar/README.en-US.md: 1.32 KB
 /pages/erList/erList.js: 1.31 KB
 /miniprogram_npm/tdesign-miniprogram/guide/guide.wxml: 1.31 KB
 /utils/common.js: 1.30 KB
 /miniprogram_npm/tdesign-miniprogram/image-viewer/README.en-US.md: 1.29 KB
 /miniprogram_npm/tdesign-miniprogram/badge/badge.wxml: 1.27 KB
 /api/processTask.js: 1.27 KB
 /miniprogram_npm/tdesign-miniprogram/popup/popup.wxml: 1.27 KB
 /pages/mine/mine.wxss: 1.26 KB
 /miniprogram_npm/tdesign-miniprogram/index.js: 1.26 KB
 /pages/erInventory/erInventory.json: 1.25 KB
 /static/tabbar/首页-未选中@2x.png: 1.25 KB
 /pages/mine/editPassword/index.wxml: 1.24 KB
 /miniprogram_npm/tdesign-miniprogram/common/template/button.wxml: 1.23 KB
 /miniprogram_npm/tdesign-miniprogram/count-down/README.en-US.md: 1.23 KB
 /miniprogram_npm/tdesign-miniprogram/image/image.wxss: 1.22 KB
 /utils/request3.js: 1.21 KB
 /miniprogram_npm/tdesign-miniprogram/drawer/drawer.wxml: 1.21 KB
 /miniprogram_npm/tdesign-miniprogram/message-item/index.js: 1.20 KB
 /components/search-bar/index.wxml: 1.19 KB
 /utils/request.js: 1.18 KB
 /miniprogram_npm/tdesign-miniprogram/pull-down-refresh/pull-down-refresh.wxss: 1.18 KB
 /components/formRender/modules/uploadFile/index.js: 1.18 KB
 /miniprogram_npm/tdesign-miniprogram/message/index.js: 1.18 KB
 /miniprogram_npm/tdesign-miniprogram/empty/empty.wxss: 1.17 KB
 /miniprogram_npm/tdesign-miniprogram/loading/README.en-US.md: 1.17 KB
 /pages/LRlist/index.json: 1.17 KB
 /pages/equipmentParts/index.json: 1.17 KB
 /pages/labConsumables/index.json: 1.17 KB
 /pages/LRlist/multipCreate/index.wxml: 1.17 KB
 /pages/equipmentParts/multipCreate/index.wxml: 1.17 KB
 /pages/instrumentEquip/multipCreate/index.wxml: 1.17 KB
 /pages/labConsumables/multipCreate/index.wxml: 1.17 KB
 /miniprogram_npm/tdesign-miniprogram/image/README.en-US.md: 1.17 KB
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/locale/dayjs.js: 1.15 KB
 /components/taskCard/taskCard.wxml: 1.12 KB
 /pages/mine/mine.wxml: 1.11 KB
 /miniprogram_npm/tdesign-miniprogram/stepper/README.en-US.md: 1.10 KB
 /miniprogram_npm/tdesign-miniprogram/swipe-cell/swipe-cell.wxss: 1.08 KB
 /components/formRender/modules/Pdf/index.js: 1.07 KB
 /miniprogram_npm/tdesign-miniprogram/picker-item/picker-item.wxss: 1.07 KB
 /miniprogram_npm/tdesign-miniprogram/swipe-cell/README.en-US.md: 1.07 KB
 /pages/LRlist/multipCreate/index.wxss: 1.07 KB
 /pages/equipmentParts/multipCreate/index.wxss: 1.07 KB
 /pages/instrumentEquip/multipCreate/index.wxss: 1.07 KB
 /pages/labConsumables/multipCreate/index.wxss: 1.07 KB
 /app.wxss: 1.06 KB
 /pages/test/page.wxss: 1.06 KB
 /api/operate/agreement.js: 1.05 KB
 /miniprogram_npm/tdesign-miniprogram/count-down/utils.js: 1.04 KB
 /miniprogram_npm/tdesign-miniprogram/common/shared/date.js: 1.03 KB
 /components/uploadFile/index.wxml: 1.03 KB
 /static/tabbar/工作台-未选中@2x.png: 1.02 KB
 /static/LRlists/add_i.png: 1.02 KB
 /miniprogram_npm/tdesign-miniprogram/navbar/navbar.wxml: 1.02 KB
 /components/org-picker/index.wxss: 1.01 KB
 /miniprogram_npm/tdesign-miniprogram/switch/switch.wxml: 1.01 KB
 /components/taskCard/taskCard.wxss: 1.01 KB
 /components/formRender/modules/Pdf/index.wxml: 1.00 KB
 /miniprogram_npm/tdesign-miniprogram/side-bar-item/side-bar-item.wxml: 1016 B
 /components/inventoryCard/inventoryCard.js: 1014 B
 /miniprogram_npm/tdesign-miniprogram/progress/utils.js: 1011 B
 /miniprogram_npm/tdesign-miniprogram/action-sheet/show.js: 1004 B
 /components/formRender/modules/table/index.wxss: 1002 B
 /miniprogram_npm/tdesign-miniprogram/button/props.js: 987 B
 /miniprogram_npm/tdesign-miniprogram/search/props.js: 983 B
 /miniprogram_npm/tdesign-miniprogram/footer/footer.wxml: 982 B
 /miniprogram_npm/tdesign-miniprogram/checkbox-group/checkbox-group.wxml: 979 B
 /miniprogram_npm/tdesign-miniprogram/guide/content.wxml: 975 B
 /miniprogram_npm/tdesign-miniprogram/textarea/props.js: 974 B
 /api/procure/index.js: 969 B
 /miniprogram_npm/tdesign-miniprogram/radio-group/radio-group.wxml: 960 B
 /miniprogram_npm/tdesign-miniprogram/toast/index.js: 955 B
 /api/property/index.js: 952 B
 /pages/staging/invoice/openr/openr.json: 952 B
 /static/LRlists/filter_i.png: 951 B
 /miniprogram_npm/tdesign-miniprogram/count-down/count-down.wxml: 950 B
 /miniprogram_npm/tdesign-miniprogram/swiper-nav/swiper-nav.wxml: 946 B
 /utils/ProcessUtil.js: 943 B
 /pages/instrumentEquip/create/index.json: 942 B
 /api/system/dict.js: 939 B
 /miniprogram_npm/tdesign-miniprogram/common/src/index.js: 935 B
 /pages/test/page.wxml: 905 B
 /miniprogram_npm/tdesign-miniprogram/avatar/avatar.wxs: 904 B
 /components/formRender/index.js: 901 B
 /miniprogram_npm/tdesign-miniprogram/fab/README.en-US.md: 893 B
 /miniprogram_npm/tdesign-miniprogram/picker/template.wxml: 888 B
 /components/formRender/modules/uploadFileids/index.js: 875 B
 /miniprogram_npm/tdesign-miniprogram/dropdown-menu/dropdown-menu.wxml: 872 B
 /miniprogram_npm/tdesign-miniprogram/calendar/calendar.wxs: 863 B
 /miniprogram_npm/tdesign-miniprogram/mixins/page-scroll.js: 851 B
 /assets/svg/cc.svg: 831 B
 /api/system/user.js: 829 B
 /miniprogram_npm/tdesign-miniprogram/empty/empty.wxml: 826 B
 /pages/LRlist/create/index.json: 824 B
 /pages/equipmentParts/create/index.json: 824 B
 /pages/labConsumables/create/index.json: 824 B
 /components/choose-process/index.wxml: 822 B
 /miniprogram_npm/tdesign-miniprogram/overlay/overlay.wxml: 816 B
 /@babel/runtime/helpers/createForOfIteratorHelper.js: 805 B
 /miniprogram_npm/tdesign-miniprogram/result/result.wxml: 802 B
 /miniprogram_npm/tdesign-miniprogram/empty/README.en-US.md: 801 B
 /miniprogram_npm/tdesign-miniprogram/indexes/indexes.wxml: 797 B
 /pages/staging/finance/finance.json: 796 B
 /miniprogram_npm/tdesign-miniprogram/swiper/swiper.wxss: 792 B
 /pages/staging/invoice/collect/collect.json: 791 B
 /miniprogram_npm/tdesign-miniprogram/divider/README.en-US.md: 778 B
 /static/staging/run.png: 776 B
 /miniprogram_npm/tdesign-miniprogram/check-tag/check-tag.wxml: 772 B
 /pages/staging/customer/addCustomer/addCustomer.wxss: 767 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/date-time-picker.wxml: 766 B
 /components/taskCard/taskCard.js: 756 B
 /miniprogram_npm/tdesign-miniprogram/steps/steps.wxss: 754 B
 /pages/index/approve/approve.json: 747 B
 /miniprogram_npm/tdesign-miniprogram/common/src/control.js: 746 B
 /components/search-bar/index.wxss: 744 B
 /miniprogram_npm/tdesign-miniprogram/collapse/index.js: 740 B
 /components/uploadFile/index.wxss: 721 B
 /components/org-picker/index.json: 716 B
 /components/my-picker/index.wxml: 715 B
 /miniprogram_npm/tdesign-miniprogram/message-item/message-item.wxs: 715 B
 /miniprogram_npm/tdesign-miniprogram/side-bar/side-bar.wxss: 714 B
 /pages/index/approve/approveDetail/approveDetail.js: 714 B
 /pages/erTask/erTask.wxml: 713 B
 /components/choose-process/index.js: 712 B
 /miniprogram_npm/tdesign-miniprogram/tag/tag.wxml: 711 B
 /miniprogram_npm/tdesign-miniprogram/dropdown-menu/index.js: 702 B
 /miniprogram_npm/tdesign-miniprogram/picker-item/picker-item.wxml: 699 B
 /miniprogram_npm/tdesign-miniprogram/swiper-nav/index.js: 699 B
 /miniprogram_npm/tdesign-miniprogram/fab/draggable/index.js: 698 B
 /@babel/runtime/helpers/objectSpread2.js: 696 B
 /miniprogram_npm/tdesign-miniprogram/loading/index.js: 696 B
 /miniprogram_npm/tdesign-miniprogram/mixins/touch.js: 696 B
 /miniprogram_npm/tdesign-miniprogram/overlay/index.js: 696 B
 /miniprogram_npm/tdesign-miniprogram/button/index.js: 695 B
 /miniprogram_npm/tdesign-miniprogram/result/index.js: 695 B
 /miniprogram_npm/tdesign-miniprogram/sticky/index.js: 695 B
 /miniprogram_npm/tdesign-miniprogram/badge/index.js: 694 B
 /miniprogram_npm/tdesign-miniprogram/popup/index.js: 694 B
 /api/project.js: 693 B
 /miniprogram_npm/tdesign-miniprogram/tabs/index.js: 693 B
 /static/LRlists/newadd_i.png: 689 B
 /components/formRender/modules/select/index.wxml: 688 B
 /api/operate/customer.js: 686 B
 /miniprogram_npm/tdesign-miniprogram/checkbox/props.js: 680 B
 /components/choose-process/index.wxss: 674 B
 /components/signature/signature.wxml: 673 B
 /miniprogram_npm/tdesign-miniprogram/overlay/overlay.wxss: 670 B
 /miniprogram_npm/tdesign-miniprogram/swiper/props.js: 659 B
 /miniprogram_npm/tdesign-miniprogram/grid/grid.wxss: 650 B
 /components/inventoryCard/inventoryCard.json: 648 B
 /miniprogram_npm/tdesign-miniprogram/pull-down-refresh/props.js: 647 B
 /miniprogram_npm/tdesign-miniprogram/upload/props.js: 645 B
 /miniprogram_npm/tdesign-miniprogram/swiper/index.wxs: 641 B
 /miniprogram_npm/tdesign-miniprogram/miniprogram_npm/dayjs/locale/en.js: 637 B
 /miniprogram_npm/tdesign-miniprogram/skeleton/skeleton.wxml: 632 B
 /assets/svg/approve.svg: 631 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/props.js: 630 B
 /miniprogram_npm/tdesign-miniprogram/radio/props.js: 630 B
 /miniprogram_npm/tdesign-miniprogram/action-sheet/template/list.wxml: 621 B
 /api/document/index.js: 596 B
 /components/actions/index.wxss: 590 B
 /miniprogram_npm/tdesign-miniprogram/mixins/using-custom-navbar.js: 587 B
 /miniprogram_npm/tdesign-miniprogram/fab/fab.wxss: 580 B
 /miniprogram_npm/tdesign-miniprogram/avatar-group/avatar-group.wxml: 577 B
 /miniprogram_npm/tdesign-miniprogram/dialog/props.js: 576 B
 /miniprogram_npm/tdesign-miniprogram/common/bus.js: 575 B
 /static/staging/goodsManage.png: 570 B
 /miniprogram_npm/tdesign-miniprogram/message/props.js: 569 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/date-time-picker.wxss: 568 B
 /miniprogram_npm/tdesign-miniprogram/back-top/back-top.wxml: 565 B
 /miniprogram_npm/tdesign-miniprogram/common/template/image.wxml: 564 B
 /pages/staging/invoice/invoice.json: 561 B
 /miniprogram_npm/tdesign-miniprogram/rate/props.js: 559 B
 /api/purchase.js: 551 B
 /components/processAction/index.wxml: 545 B
 /components/actions/index.json: 542 B
 /components/formRender/modules/Pdf/index.wxss: 536 B
 /miniprogram_npm/tdesign-miniprogram/guide/props.js: 536 B
 /api/system/auth.js: 535 B
 /miniprogram_npm/tdesign-miniprogram/icon/icon.wxml: 531 B
 /miniprogram_npm/tdesign-miniprogram/popup/props.js: 528 B
 /miniprogram_npm/tdesign-miniprogram/picker/props.js: 524 B
 /miniprogram_npm/tdesign-miniprogram/calendar/props.js: 522 B
 /components/formRender/modules/select/index.wxss: 519 B
 /pages/erList/erList.json: 518 B
 /miniprogram_npm/tdesign-miniprogram/slider/props.js: 516 B
 /miniprogram_npm/tdesign-miniprogram/loading/props.js: 515 B
 /project.private.config.json: 509 B
 /utils/processMethode.js: 508 B
 /miniprogram_npm/tdesign-miniprogram/common/version.js: 507 B
 /miniprogram_npm/tdesign-miniprogram/upload/upload.wxs: 504 B
 /miniprogram_npm/tdesign-miniprogram/stepper/props.js: 503 B
 /components/formRender/index.json: 499 B
 /miniprogram_npm/tdesign-miniprogram/divider/divider.wxml: 499 B
 /miniprogram_npm/tdesign-miniprogram/popup/popup.wxs: 498 B
 /pages/staging/agreement/agreement.json: 498 B
 /utils/behavior.js: 495 B
 /miniprogram_npm/tdesign-miniprogram/cell/props.js: 492 B
 /miniprogram_npm/tdesign-miniprogram/image/props.js: 489 B
 /miniprogram_npm/tdesign-miniprogram/calendar/index.js: 488 B
 /miniprogram_npm/tdesign-miniprogram/image/index.js: 486 B
 /miniprogram_npm/tdesign-miniprogram/action-sheet/props.js: 485 B
 /miniprogram_npm/tdesign-miniprogram/transition/index.js: 485 B
 /miniprogram_npm/tdesign-miniprogram/tab-panel/tab-panel.wxss: 477 B
 /miniprogram_npm/tdesign-miniprogram/notice-bar/props.js: 467 B
 /components/search-bar/index.json: 464 B
 /miniprogram_npm/tdesign-miniprogram/collapse/collapse.wxss: 459 B
 /components/formRender/modules/table/index.wxml: 456 B
 /miniprogram_npm/tdesign-miniprogram/action-sheet/action-sheet.wxs: 456 B
 /pages/mine/editPassword/index.wxss: 454 B
 /@babel/runtime/helpers/iterableToArrayLimit.js: 453 B
 /miniprogram_npm/tdesign-miniprogram/tabs/props.js: 453 B
 /pages/erTask/erTask.wxss: 451 B
 /miniprogram_npm/tdesign-miniprogram/image-viewer/props.js: 446 B
 /components/formRender/modules/datetime/index.wxml: 440 B
 /miniprogram_npm/tdesign-miniprogram/dropdown-item/props.js: 438 B
 /@babel/runtime/helpers/unsupportedIterableToArray.js: 436 B
 /components/formRender/index.wxss: 436 B
 /pages/erTask/erTask.json: 435 B
 /miniprogram_npm/tdesign-miniprogram/steps/props.js: 434 B
 /miniprogram_npm/tdesign-miniprogram/picker/picker.wxml: 433 B
 /miniprogram_npm/tdesign-miniprogram/grid/grid.wxml: 432 B
 /miniprogram_npm/tdesign-miniprogram/sticky/README.en-US.md: 431 B
 /static/staging/customer/searchIcon.png: 431 B
 /pages/LRlist/multipCreate/index.json: 430 B
 /pages/equipmentParts/multipCreate/index.json: 430 B
 /pages/instrumentEquip/multipCreate/index.json: 430 B
 /pages/labConsumables/multipCreate/index.json: 430 B
 /miniprogram_npm/tdesign-miniprogram/cascader/props.js: 428 B
 /miniprogram_npm/tdesign-miniprogram/check-tag/props.js: 426 B
 /@babel/runtime/helpers/createClass.js: 421 B
 /miniprogram_npm/tdesign-miniprogram/indexes-anchor/indexes-anchor.wxml: 419 B
 /miniprogram_npm/tdesign-miniprogram/tab-bar/props.js: 418 B
 /@babel/runtime/helpers/asyncToGenerator.js: 416 B
 /miniprogram_npm/tdesign-miniprogram/badge/props.js: 414 B
 /miniprogram_npm/tdesign-miniprogram/avatar/props.js: 412 B
 /components/formRender/modules/uploadFile/index.wxss: 410 B
 /miniprogram_npm/tdesign-miniprogram/link/props.js: 408 B
 /components/processAction/index.wxss: 407 B
 /pages/mine/mine.json: 407 B
 /miniprogram_npm/tdesign-miniprogram/toast/props.js: 401 B
 /miniprogram_npm/tdesign-miniprogram/grid-item/props.js: 397 B
 /miniprogram_npm/tdesign-miniprogram/fab/draggable/draggable.wxss: 395 B
 /miniprogram_npm/tdesign-miniprogram/sticky/sticky.wxss: 395 B
 /miniprogram_npm/tdesign-miniprogram/common/template/badge.wxml: 393 B
 /miniprogram_npm/tdesign-miniprogram/count-down/props.js: 390 B
 /miniprogram_npm/tdesign-miniprogram/tag/props.js: 387 B
 /pages/index/index.json: 386 B
 /miniprogram_npm/tdesign-miniprogram/fab/template/draggable.wxml: 385 B
 /miniprogram_npm/tdesign-miniprogram/collapse-panel/props.js: 384 B
 /miniprogram_npm/tdesign-miniprogram/col/col.wxs: 381 B
 /miniprogram_npm/tdesign-miniprogram/row/row.wxs: 381 B
 /miniprogram_npm/tdesign-miniprogram/radio-group/props.js: 380 B
 /@babel/runtime/helpers/toConsumableArray.js: 379 B
 /@babel/runtime/helpers/Arrayincludes.js: 378 B
 /miniprogram_npm/tdesign-miniprogram/drawer/props.js: 378 B
 /@babel/runtime/helpers/slicedToArray.js: 377 B
 /components/formRender/modules/uploadFileids/index.wxss: 377 B
 /miniprogram_npm/tdesign-miniprogram/switch/props.js: 375 B
 /miniprogram_npm/tdesign-miniprogram/textarea/textarea.wxs: 374 B
 /@babel/runtime/helpers/inherits.js: 372 B
 /pages/login/login.json: 372 B
 /miniprogram_npm/tdesign-miniprogram/swiper-nav/props.js: 368 B
 /miniprogram_npm/tdesign-miniprogram/common/index.wxss: 367 B
 /miniprogram_npm/tdesign-miniprogram/common/style/index.wxss: 367 B
 /miniprogram_npm/tdesign-miniprogram/common/style/utilities/_index.wxss: 367 B
 /components/formRender/modules/textarea/index.wxss: 365 B
 /miniprogram_npm/tdesign-miniprogram/message/message.wxml: 365 B
 /miniprogram_npm/tdesign-miniprogram/slider/tool.js: 362 B
 /@babel/runtime/helpers/possibleConstructorReturn.js: 359 B
 /miniprogram_npm/tdesign-miniprogram/mixins/theme-change.js: 359 B
 /components/formRender/modules/datetime/index.js: 356 B
 /components/my-picker/index.json: 356 B
 /miniprogram_npm/tdesign-miniprogram/calendar/calendar.wxml: 354 B
 /miniprogram_npm/tdesign-miniprogram/collapse/props.js: 354 B
 /components/formRender/modules/uploadFile/index.wxml: 352 B
 /miniprogram_npm/tdesign-miniprogram/input/input.wxs: 345 B
 /miniprogram_npm/tdesign-miniprogram/progress/props.js: 345 B
 /components/formRender/modules/select/index.json: 344 B
 /@babel/runtime/helpers/toPrimitive.js: 343 B
 /app.js: 341 B
 /miniprogram_npm/tdesign-miniprogram/back-top/props.js: 337 B
 /miniprogram_npm/tdesign-miniprogram/dropdown-menu/props.js: 337 B
 /api/system/tenant.js: 336 B
 /miniprogram_npm/tdesign-miniprogram/common/template/icon.wxml: 335 B
 /components/formRender/modules/uploadFileids/index.wxml: 330 B
 /miniprogram_npm/tdesign-miniprogram/checkbox-group/props.js: 330 B
 /miniprogram_npm/tdesign-miniprogram/overlay/props.js: 330 B
 /miniprogram_npm/tdesign-miniprogram/tabs/tabs.wxs: 327 B
 /miniprogram_npm/tdesign-miniprogram/common/style/theme/_components.wxss: 326 B
 /miniprogram_npm/tdesign-miniprogram/grid/props.js: 325 B
 /components/formRender/modules/cascader/index.wxss: 324 B
 /miniprogram_npm/tdesign-miniprogram/navbar/props.js: 324 B
 /miniprogram_npm/tdesign-miniprogram/tab-panel/tab-panel.wxml: 322 B
 /components/choose-process/index.json: 320 B
 /miniprogram_npm/tdesign-miniprogram/action-sheet/index.js: 319 B
 /miniprogram_npm/tdesign-miniprogram/tree-select/tree-select.json: 319 B
 /components/processAction/index.js: 317 B
 /miniprogram_npm/tdesign-miniprogram/sticky/sticky.wxml: 317 B
 /miniprogram_npm/tdesign-miniprogram/transition/props.js: 317 B
 /components/formRender/modules/cascader/index.wxml: 315 B
 /components/uploadFile/index.json: 314 B
 /miniprogram_npm/tdesign-miniprogram/common/style/theme/_font.wxss: 313 B
 /miniprogram_npm/tdesign-miniprogram/fab/template/view.wxml: 313 B
 /miniprogram_npm/tdesign-miniprogram/fab/props.js: 311 B
 /pages/instrumentEquip/detail/index.json: 309 B
 /miniprogram_npm/tdesign-miniprogram/tab-panel/props.js: 308 B
 /components/formRender/modules/Input/index.wxss: 307 B
 /components/formRender/modules/datetime/index.wxss: 307 B
 /miniprogram_npm/tdesign-miniprogram/cell-group/cell-group.wxml: 306 B
 /miniprogram_npm/tdesign-miniprogram/dialog/dialog.wxs: 306 B
 /miniprogram_npm/tdesign-miniprogram/divider/props.js: 303 B
 /miniprogram_npm/tdesign-miniprogram/step-item/props.js: 297 B
 /miniprogram_npm/tdesign-miniprogram/common/src/superComponent.js: 295 B
 /miniprogram_npm/tdesign-miniprogram/dropdown-item/dropdown-item.json: 289 B
 /@babel/runtime/helpers/typeof.js: 286 B
 /miniprogram_npm/tdesign-miniprogram/col/col.wxml: 285 B
 /pages/index/approve/approveDetail/approveDetail.json: 284 B
 /miniprogram_npm/tdesign-miniprogram/tree-select/props.js: 282 B
 /api/material/local.js: 281 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/locale/ru.js: 277 B
 /components/formRender/modules/table/index.js: 276 B
 /components/formRender/modules/Input/index.wxml: 275 B
 /components/process-render/index.json: 271 B
 /miniprogram_npm/tdesign-miniprogram/avatar-group/props.js: 267 B
 /miniprogram_npm/tdesign-miniprogram/skeleton/props.js: 267 B
 /miniprogram_npm/tdesign-miniprogram/tab-bar/tab-bar.wxml: 264 B
 /miniprogram_npm/tdesign-miniprogram/sticky/props.js: 263 B
 /.eslintrc.js: 262 B
 /components/formRender/modules/textarea/index.wxml: 257 B
 /pages/LRlist/detail/index.json: 257 B
 /pages/equipmentParts/detail/index.json: 257 B
 /pages/labConsumables/detail/index.json: 257 B
 /components/formRender/modules/Input/index.js: 256 B
 /miniprogram_npm/tdesign-miniprogram/fab/draggable/draggable.wxml: 254 B
 /miniprogram_npm/tdesign-miniprogram/result/props.js: 254 B
 /miniprogram_npm/tdesign-miniprogram/common/wechat.js: 252 B
 /miniprogram_npm/tdesign-miniprogram/indexes-anchor/README.md: 252 B
 /utils/setting.js: 251 B
 /miniprogram_npm/tdesign-miniprogram/icon/props.js: 248 B
 /miniprogram_npm/tdesign-miniprogram/transition/transition.wxml: 248 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/locale/ja.js: 246 B
 /pages/staging/customer/customerResource.json: 242 B
 /miniprogram_npm/tdesign-miniprogram/side-bar-item/props.js: 239 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/locale/ko.js: 237 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/locale/tc.js: 237 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/locale/zh.js: 237 B
 /miniprogram_npm/tdesign-miniprogram/cell-group/props.js: 235 B
 /miniprogram_npm/tdesign-miniprogram/dropdown-item/index.wxs: 235 B
 /miniprogram_npm/tdesign-miniprogram/slider/slider.wxs: 235 B
 /miniprogram_npm/tdesign-miniprogram/swipe-cell/props.js: 235 B
 /static/staging/customer/backIcon.png: 234 B
 /miniprogram_npm/tdesign-miniprogram/indexes/props.js: 232 B
 /miniprogram_npm/tdesign-miniprogram/cascader/cascader.json: 229 B
 /pages/staging/template/template.wxss: 229 B
 /components/taskCard/taskCard.json: 228 B
 /@babel/runtime/helpers/defineProperty.js: 227 B
 /components/org-picker/methods.wxs: 227 B
 /@babel/runtime/helpers/getPrototypeOf.js: 225 B
 /pages/approve/approve.js: 222 B
 /pages/approve/approveDetail/approveDetail.js: 222 B
 /pages/approve/index/approve/approve.js: 222 B
 /pages/approve/index/approve/approveDetail/approveDetail.js: 222 B
 /pages/er/inventory/erInventory.js: 222 B
 /pages/er/list/erList.js: 222 B
 /pages/er/task/erTask.js: 222 B
 /pages/financeReg/staging/invoice/finance-reg/index.js: 222 B
 /pages/staging/agreement/editAgreement/editAgreement.js: 222 B
 /pages/staging/finance/editFinance/editFinance.js: 222 B
 /pages/staging/invoice/finance-reg/index.js: 222 B
 /pages/staging/staging/staging.js: 222 B
 /pages/staging/template/template.js: 222 B
 /pages/user/mine/editPassword/index.js: 222 B
 /@babel/runtime/helpers/nonIterableRest.js: 221 B
 /miniprogram_npm/tdesign-miniprogram/footer/props.js: 221 B
 /@babel/runtime/helpers/nonIterableSpread.js: 220 B
 /miniprogram_npm/tdesign-miniprogram/empty/empty.wxs: 219 B
 /miniprogram_npm/tdesign-miniprogram/fab/fab.wxml: 218 B
 /pages/logs/logs.js: 216 B
 /miniprogram_npm/tdesign-miniprogram/message/message.interface.js: 215 B
 /pages/staging/customer/addCustomer/addCustomer.json: 215 B
 /miniprogram_npm/tdesign-miniprogram/common/component.js: 212 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/locale/en.js: 212 B
 /components/navbar/index.js: 211 B
 /@babel/runtime/helpers/setPrototypeOf.js: 209 B
 /miniprogram_npm/tdesign-miniprogram/empty/props.js: 209 B
 /@babel/runtime/helpers/Objectvalues.js: 208 B
 /miniprogram_npm/tdesign-miniprogram/steps/steps.wxml: 208 B
 /miniprogram_npm/tdesign-miniprogram/collapse/collapse.wxml: 207 B
 /pages/mine/editPassword/index.json: 206 B
 /miniprogram_npm/tdesign-miniprogram/indexes-anchor/README.en-US.md: 204 B
 /miniprogram_npm/tdesign-miniprogram/side-bar/side-bar.wxml: 204 B
 /miniprogram_npm/tdesign-miniprogram/tree-select/index.wxs: 204 B
 /miniprogram_npm/tdesign-miniprogram/tab-bar-item/props.js: 200 B
 /miniprogram_npm/tdesign-miniprogram/search/search.wxs: 199 B
 /static/staging/customer/dropGreen.png: 199 B
 /@babel/runtime/helpers/toPropertyKey.js: 196 B
 /components/formRender/modules/textarea/index.js: 195 B
 /components/signature/signature.wxss: 185 B
 /miniprogram_npm/tdesign-miniprogram/action-sheet/action-sheet.json: 184 B
 /miniprogram_npm/tdesign-miniprogram/upload/upload.json: 184 B
 /@babel/runtime/helpers/assertThisInitialized.js: 182 B
 /static/staging/dropDown.png: 176 B
 /components/empty/index.wxss: 175 B
 /pages/logs/logs.wxml: 173 B
 /sitemap.json: 171 B
 /miniprogram_npm/tdesign-miniprogram/transition/transition.wxss: 170 B
 /miniprogram_npm/tdesign-miniprogram/step-item/step-item.wxs: 169 B
 /package.json: 167 B
 /miniprogram_npm/tdesign-miniprogram/picker-item/props.js: 166 B
 /miniprogram_npm/tdesign-miniprogram/indexes-anchor/props.js: 164 B
 /@babel/runtime/helpers/arrayWithoutHoles.js: 163 B
 /miniprogram_npm/tdesign-miniprogram/side-bar/props.js: 163 B
 /@babel/runtime/helpers/iterableToArray.js: 161 B
 /components/signature/signature.json: 161 B
 /miniprogram_npm/tdesign-miniprogram/common/style/theme/_radius.wxss: 161 B
 /miniprogram_npm/tdesign-miniprogram/guide/guide.json: 160 B
 /miniprogram_npm/tdesign-miniprogram/indexes/indexes.json: 160 B
 /miniprogram_npm/tdesign-miniprogram/toast/toast.json: 160 B
 /@babel/runtime/helpers/arrayLikeToArray.js: 155 B
 /miniprogram_npm/tdesign-miniprogram/common/config.js: 154 B
 /miniprogram_npm/tdesign-miniprogram/fab/draggable/props.js: 153 B
 /pages/staging/template/template.wxml: 153 B
 /miniprogram_npm/tdesign-miniprogram/calendar/calendar.json: 151 B
 /miniprogram_npm/tdesign-miniprogram/dialog/dialog.json: 151 B
 /miniprogram_npm/tdesign-miniprogram/row/row.wxml: 151 B
 /miniprogram_npm/tdesign-miniprogram/tabs/tabs.json: 151 B
 /miniprogram_npm/tdesign-miniprogram/common/style/theme/_spacer.wxss: 150 B
 /components/formRender/modules/uploadFile/index.json: 148 B
 /miniprogram_npm/tdesign-miniprogram/avatar/avatar.json: 148 B
 /miniprogram_npm/tdesign-miniprogram/grid-item/grid-item.json: 148 B
 /miniprogram_npm/tdesign-miniprogram/row/row.wxss: 147 B
 /miniprogram_npm/tdesign-miniprogram/col/props.js: 145 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/date-time-picker.json: 145 B
 /components/formRender/modules/datetime/index.json: 143 B
 /components/empty/index.wxml: 140 B
 /@babel/runtime/helpers/classCallCheck.js: 139 B
 /miniprogram_npm/tdesign-miniprogram/swiper/swiper.json: 139 B
 /miniprogram_npm/tdesign-miniprogram/fab/fab.json: 138 B
 /pages/staging/template/template.json: 137 B
 /components/processAction/index.json: 136 B
 /pages/logs/logs.wxss: 133 B
 /@babel/runtime/helpers/Objectentries.js: 131 B
 /components/my-picker/index.wxss: 130 B
 /miniprogram_npm/tdesign-miniprogram/row/props.js: 128 B
 /miniprogram_npm/tdesign-miniprogram/button/button.json: 127 B
 /miniprogram_npm/tdesign-miniprogram/image/image.json: 127 B
 /miniprogram_npm/tdesign-miniprogram/popup/popup.json: 127 B
 /miniprogram_npm/tdesign-miniprogram/switch/switch.json: 127 B
 /miniprogram_npm/tdesign-miniprogram/common/style/utilities/_animation.wxss: 122 B
 /components/formRender/modules/title/index.wxss: 121 B
 /miniprogram_npm/tdesign-miniprogram/cell/cell.json: 121 B
 /miniprogram_npm/tdesign-miniprogram/drawer/drawer.json: 121 B
 /miniprogram_npm/tdesign-miniprogram/empty/empty.json: 121 B
 /miniprogram_npm/tdesign-miniprogram/image-viewer/image-viewer.json: 121 B
 /miniprogram_npm/tdesign-miniprogram/result/result.json: 121 B
 /miniprogram_npm/tdesign-miniprogram/side-bar-item/side-bar-item.json: 121 B
 /miniprogram_npm/tdesign-miniprogram/side-bar/side-bar.json: 121 B
 /miniprogram_npm/tdesign-miniprogram/tab-bar-item/tab-bar-item.json: 121 B
 /components/formRender/modules/cascader/index.json: 119 B
 /miniprogram_npm/tdesign-miniprogram/message-item/message-item.json: 118 B
 /miniprogram_npm/tdesign-miniprogram/message/message.json: 118 B
 /miniprogram_npm/tdesign-miniprogram/search/search.json: 118 B
 /miniprogram_npm/tdesign-miniprogram/stepper/stepper.json: 118 B
 /components/formRender/modules/Pdf/index.json: 110 B
 /components/navbar/index.json: 107 B
 /miniprogram_npm/tdesign-miniprogram/checkbox-group/checkbox-group.json: 106 B
 /miniprogram_npm/tdesign-miniprogram/steps/steps.json: 104 B
 /miniprogram_npm/tdesign-miniprogram/pull-down-refresh/pull-down-refresh.json: 103 B
 /components/navbar/index.wxml: 100 B
 /miniprogram_npm/tdesign-miniprogram/avatar-group/avatar-group.json: 100 B
 /miniprogram_npm/tdesign-miniprogram/footer/footer.json: 97 B
 /miniprogram_npm/tdesign-miniprogram/picker/picker.json: 97 B
 /miniprogram_npm/tdesign-miniprogram/radio-group/radio-group.json: 97 B
 /miniprogram_npm/tdesign-miniprogram/tag/tag.json: 96 B
 /miniprogram_npm/tdesign-miniprogram/back-top/back-top.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/check-tag/check-tag.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/checkbox/checkbox.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/collapse-panel/collapse-panel.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/count-down/count-down.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/dropdown-menu/dropdown-menu.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/input/input.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/link/link.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/navbar/navbar.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/notice-bar/notice-bar.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/progress/progress.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/radio/radio.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/rate/rate.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/step-item/step-item.json: 94 B
 /miniprogram_npm/tdesign-miniprogram/swipe-cell/swipe-cell.json: 94 B
 /@babel/runtime/helpers/arrayWithHoles.js: 88 B
 /pages/approve/index/approve/approveDetail/approveDetail.wxml: 74 B
 /components/formRender/modules/subtitle/index.js: 71 B
 /components/formRender/modules/title/index.js: 71 B
 /miniprogram_npm/tdesign-miniprogram/badge/badge.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/cell-group/cell-group.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/col/col.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/grid/grid.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/icon/icon.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/loading/loading.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/overlay/overlay.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/picker-item/picker-item.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/row/row.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/skeleton/skeleton.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/slider/slider.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/sticky/sticky.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/tab-bar/tab-bar.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/tab-panel/tab-panel.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/textarea/textarea.json: 71 B
 /miniprogram_npm/tdesign-miniprogram/transition/transition.json: 71 B
 /pages/staging/agreement/editAgreement/editAgreement.wxml: 70 B
 /pages/financeReg/staging/invoice/finance-reg/index.wxml: 69 B
 /miniprogram_npm/tdesign-miniprogram/action-sheet/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/avatar-group/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/avatar/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/back-top/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/badge/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/button/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/calendar/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/cascader/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/cell-group/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/cell/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/check-tag/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/checkbox-group/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/checkbox/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/col/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/collapse-panel/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/collapse/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/common/common.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/common/shared/calendar/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/count-down/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/date-time-picker/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/dialog/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/divider/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/drawer/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/dropdown-item/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/dropdown-menu/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/empty/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/fab/draggable/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/fab/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/footer/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/grid-item/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/grid/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/guide/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/icon/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/image-viewer/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/image/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/indexes-anchor/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/indexes/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/input/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/link/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/loading/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/message/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/navbar/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/notice-bar/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/overlay/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/picker-item/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/picker/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/popup/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/progress/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/pull-down-refresh/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/radio-group/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/radio/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/rate/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/result/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/row/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/search/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/side-bar-item/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/side-bar/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/skeleton/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/slider/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/step-item/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/stepper/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/steps/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/sticky/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/swipe-cell/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/swiper-nav/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/swiper/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/switch/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/tab-bar-item/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/tab-bar/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/tab-panel/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/tabs/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/tag/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/textarea/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/toast/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/transition/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/tree-select/type.js: 68 B
 /miniprogram_npm/tdesign-miniprogram/upload/type.js: 68 B
 /pages/logs/logs.json: 68 B
 /components/formRender/modules/subtitle/index.wxss: 65 B
 /pages/staging/finance/editFinance/editFinance.wxml: 64 B
 /project.config.json: 64 B
 /pages/staging/staging.json: 62 B
 /pages/approve/approveDetail/approveDetail.wxml: 60 B
 /components/empty/index.js: 59 B
 /pages/staging/invoice/finance-reg/index.wxml: 58 B
 /pages/approve/index/approve/approve.wxml: 54 B
 /pages/user/mine/editPassword/index.wxml: 53 B
 /miniprogram_npm/tdesign-miniprogram/common/style/utilities/_float.wxss: 52 B
 /miniprogram_npm/tdesign-miniprogram/collapse/collapse.json: 50 B
 /miniprogram_npm/tdesign-miniprogram/divider/divider.json: 50 B
 /miniprogram_npm/tdesign-miniprogram/indexes-anchor/indexes-anchor.json: 50 B
 /miniprogram_npm/tdesign-miniprogram/swiper-nav/swiper-nav.json: 50 B
 /pages/er/inventory/erInventory.wxml: 49 B
 /pages/staging/staging/staging.wxml: 48 B
 /.vscode/extensions.json: 41 B
 /components/formRender/modules/subtitle/index.wxml: 40 B
 /components/formRender/modules/title/index.wxml: 40 B
 /pages/approve/approve.wxml: 40 B
 /components/empty/index.json: 39 B
 /components/formRender/modules/Input/index.json: 39 B
 /components/formRender/modules/subtitle/index.json: 39 B
 /components/formRender/modules/table/index.json: 39 B
 /components/formRender/modules/textarea/index.json: 39 B
 /components/formRender/modules/title/index.json: 39 B
 /components/formRender/modules/uploadFileids/index.json: 39 B
 /miniprogram_npm/tdesign-miniprogram/fab/draggable/draggable.json: 39 B
 /pages/er/list/erList.wxml: 39 B
 /pages/er/task/erTask.wxml: 39 B
 /.cloudbase/container/debug.json: 29 B
 /pages/approve/approve.json: 22 B
 /pages/approve/approveDetail/approveDetail.json: 22 B
 /pages/approve/index/approve/approve.json: 22 B
 /pages/approve/index/approve/approveDetail/approveDetail.json: 22 B
 /pages/er/inventory/erInventory.json: 22 B
 /pages/er/list/erList.json: 22 B
 /pages/er/task/erTask.json: 22 B
 /pages/financeReg/staging/invoice/finance-reg/index.json: 22 B
 /pages/staging/agreement/editAgreement/editAgreement.json: 22 B
 /pages/staging/finance/editFinance/editFinance.json: 22 B
 /pages/staging/invoice/finance-reg/index.json: 22 B
 /pages/staging/staging/staging.json: 22 B
 /pages/test/page.json: 22 B
 /pages/user/mine/editPassword/index.json: 22 B
 /pages/about/about.js: 13 B
 /pages/about/about.wxml: 1 B
 /components/navbar/index.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/checkbox-group/checkbox-group.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/common/style/_variables.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/common/style/base.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/common/style/icons.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/common/style/mixins/_clearfix.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/common/style/mixins/_cursor.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/common/style/mixins/_ellipsis.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/common/style/mixins/_hairline.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/common/style/mixins/_index.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/message/message.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/radio-group/radio-group.wxss: 0 B
 /miniprogram_npm/tdesign-miniprogram/row/README.md: 0 B
 /pages/about/about.wxss: 0 B
 /pages/approve/approve.wxss: 0 B
 /pages/approve/approveDetail/approveDetail.wxss: 0 B
 /pages/approve/index/approve/approve.wxss: 0 B
 /pages/approve/index/approve/approveDetail/approveDetail.wxss: 0 B
 /pages/er/inventory/erInventory.wxss: 0 B
 /pages/er/list/erList.wxss: 0 B
 /pages/er/task/erTask.wxss: 0 B
 /pages/financeReg/staging/invoice/finance-reg/index.wxss: 0 B
 /pages/staging/staging/staging.wxss: 0 B
 /pages/user/mine/editPassword/index.wxss: 0 B

 
*/




@end
