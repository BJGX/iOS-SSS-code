//
//  SSMainLineListCell.m

//
//  Created by  on 2025/7/4.

//

#import "SSMainLineListCell.h"
#import "SSLineListCell.h"
#import "VFAES.h"

@interface SSMainLineListCell()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *nameBTn;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation SSMainLineListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SSLineListCell" bundle:nil] forCellReuseIdentifier:@"SSLineListCell"];
    [self configureCell];
    self.tableView.scrollEnabled = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureCell {
    // 设置圆角
//    _backView.layer.cornerRadius = 12.0;
//    
//    // 设置阴影
//    _backView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _backView.layer.shadowOffset = CGSizeMake(0, 0);
//    _backView.layer.shadowRadius = 6.0;
//    _backView.layer.shadowOpacity = 0.05;
//    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nameBTn.layer.cornerRadius = 12.0;
        
        // 设置阴影
        self.nameBTn.layer.shadowColor = [UIColor blackColor].CGColor;
        self.nameBTn.layer.shadowOffset = CGSizeMake(0, 0);
        self.nameBTn.layer.shadowRadius = 6.0;
        self.nameBTn.layer.shadowOpacity = 0.05;
        self.nameBTn.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.nameBTn.bounds
                                                                    cornerRadius:self.nameBTn.layer.cornerRadius].CGPath;
    });
    
    
    // 立即更新阴影路径
//    [self updateShadowPath];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self updateShadowPath]; // 每次布局更新时刷新阴影路径
}

- (void)updateShadowPath {
    // 使用贝塞尔路径优化阴影性能
    _backView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds
                                                                cornerRadius:_backView.layer.cornerRadius].CGPath;
}


- (IBAction)testSpeedAction:(UIButton *)sender {
    
    for (YQBaseModel *obj in self.model.service) {
        obj.type = -1;
    }
    
    if (self.model.unFold) {
        [self.tableView reloadData];
        return;
    }
    [YQUtils showCenterMessage:@"正在测试速度"];
    self.model.unFold = YES;
    self.rightView.highlighted = self.model.unFold;
    if (self.unfoldBlock) {
        self.unfoldBlock();
    }
}


- (IBAction)openOrFoldAction:(UIButton *)sender {
    self.model.unFold = !self.model.unFold;
    
    self.rightView.highlighted = self.model.unFold;
    if (self.unfoldBlock) {
        self.unfoldBlock();
    }
}

- (void)setModel:(YQBaseModel *)model{
    _model = model;
    [self.nameBTn setTitle:model.name.localized forState:UIControlStateNormal];
    model.cellHeight = model.service.count * 40 + 66;
    self.flagImageView.image = [VFHomeModel getFlagImage:model.name];
    NSLog(@"%@",model.name);
    self.rightView.highlighted = self.model.unFold;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.service.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSLineListCell *cell = [tableView dequeueReusableCellWithIdentifier:SSLineListCell.className forIndexPath:indexPath];
    cell.model = self.model.service[indexPath.row];
    return cell;
}





@end
