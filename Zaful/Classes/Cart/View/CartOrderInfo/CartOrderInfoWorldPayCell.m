//
//  CartOrderInfoWorldPayCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/16.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInfoWorldPayCell.h"

@interface CartOrderInfoWorldPayCell ()

@property (nonatomic, strong) UIImageView *worldPayIcon;

@end

@implementation CartOrderInfoWorldPayCell

+ (CartOrderInfoWorldPayCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartOrderInfoWorldPayCell class] forCellReuseIdentifier:ORDERINFO_WORLDPAYCELL_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:ORDERINFO_WORLDPAYCELL_IDENTIFIER forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.worldPaySelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.worldPaySelectBtn setImage:[UIImage imageNamed:@"order_unchoose"] forState:UIControlStateNormal];
        [self.worldPaySelectBtn setImage:[UIImage imageNamed:@"order_choose"] forState:UIControlStateSelected];
        [self.worldPaySelectBtn addTarget:self action:@selector(worldPaySelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.worldPaySelectBtn];
        [self.worldPaySelectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(12);
            make.top.offset(12.5);
            make.size.equalTo(@19);
        }];
        
        self.worldPayIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"worldPay"]];
        [self.contentView addSubview:self.worldPayIcon];
        [self.worldPayIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(12.5);
            make.leading.equalTo(self.worldPaySelectBtn.mas_trailing).offset(2);//透明的PNG,留有左边的白边，本来设置12，往左挪10，设为2
            make.width.equalTo(@270);
            make.height.equalTo(@70);
        }];
        
        self.worldPayLabel = [[UILabel alloc] init];
        self.worldPayLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        self.worldPayLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.worldPayLabel];
        [self.worldPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.worldPayIcon.mas_leading).offset(10);
            make.top.equalTo(self.worldPayIcon.mas_bottom).offset(10);
            make.bottom.offset(-12.5);
        }];
    }
    return self;
}

- (void)worldPaySelectBtnClick:(UIButton *)sender
{
    if (self.worldPaySelectBlock && sender.selected == NO) {
        
        sender.selected = !sender.selected;
        self.worldPaySelectBlock();
    }
}

@end
